const axios = require("axios");
const Event = require("../models/Event");
const path = require("path");
const { ObjectID } = require("mongodb");
const User = require("../models/User");
const fs = require("fs");
const jimp = require("jimp");
exports.addEvent = async function (req, res) {
  try {
    let multipleNames = [];
    console.log(req.files);
    if (req.files) {
      if (req.files.eventAttachment) {
        console.log(req.files);
        if (Array.isArray(req.files.eventAttachment)) {
          let files = req.files.eventAttachment;
          // console.log(files);
          const promises = files.map((file) => {
            const fileName = new Date().getTime().toString() + "-" + file.name;
            const savePath = path.join(
              __dirname,
              "../public/",
              "eventAttachments",
              fileName
            );
            multipleNames.push(fileName);
            return file.mv(savePath);
          });
          await Promise.all(promises);
          req.body.eventAttachment = multipleNames;
        } else if (!Array.isArray(req.files)) {
          let file = req.files.eventAttachment;
          const fileName = new Date().getTime().toString() + "-" + file.name;
          const savePath = path.join(
            __dirname,
            "../public/",
            "eventAttachments",
            fileName
          );
          await file.mv(savePath);
          req.body.eventAttachment = fileName;
        }
      }

      if (req.files.eventPoster) {
        const poster = req.files.eventPoster;
        // console.log(logoFile.name);
        const fileName1 = new Date().getTime().toString() + "-" + poster.name;
        const savePath1 = path.join(
          __dirname,
          "../public/",
          "poster",
          fileName1
        );
        await poster.mv(savePath1);
        req.body.eventPoster = fileName1;
      }

      if (req.files.participationCertificateTemplate) {
        const certificate = req.files.participationCertificateTemplate;
        // console.log(logoFile.name);
        const fileName1 =
          new Date().getTime().toString() + "-" + certificate.name;
        const savePath1 = path.join(
          __dirname,
          "../public/",
          "certificateTemplates",
          fileName1
        );
        await certificate.mv(savePath1);
        req.body.participationCertificateTemplate = fileName1;
      } else {
        const defaultFileName = "certificate.png";
        const fileName =
          new Date().getTime().toString() + "-" + defaultFileName;

        const defaultTemplatePath = path.join(
          __dirname,
          "../public/images",
          defaultFileName
        );
        const savePath1 = path.join(
          __dirname,
          "../public/",
          "certificateTemplates",
          fileName
        );
        // Copy the default file to the savePath1 directory
        fs.copyFileSync(defaultTemplatePath, savePath1);

        req.body.participationCertificateTemplate = fileName;
      }

      if (req.files.volunteerCertificateTemplate !== undefined) {
        console.log("Volunteer Certificate Template");
        const certificate = req.files.volunteerCertificateTemplate;
        // console.log(logoFile.name);
        const fileName1 =
          new Date().getTime().toString() + "-" + certificate.name;
        const savePath1 = path.join(
          __dirname,
          "../public/",
          "certificateTemplates",
          fileName1
        );
        await certificate.mv(savePath1);
        req.body.volunteerCertificateTemplate = fileName1;
      } else {
        console.log("fallback Certificate Template");

        const defaultFileName = "certificate.png";
        const fileName =
          new Date().getTime().toString() + "-" + defaultFileName;

        const defaultTemplatePath = path.join(
          __dirname,
          "../public/images",
          defaultFileName
        );
        const savePath1 = path.join(
          __dirname,
          "../public/",
          "certificateTemplates",
          fileName
        );
        // Copy the default file to the savePath1 directory
        fs.copyFileSync(defaultTemplatePath, savePath1);

        req.body.volunteerCertificateTemplate = fileName;
      }
    }

    let event = new Event(req.body);
    // console.log(req.body);
    let volunteerResponsibilities =
      req.body.volunteerResponsibilities.split(", ");
    req.body.volunteerResponsibilities = volunteerResponsibilities;

    let result = await event.addEvent();

    if (result.status == "ok") {
      axios
        .post("http://localhost:4000/account/signUp", {
          accountFirstName: req.body.organizerName,
          accountLastName: req.body.organizerName,
          accountEmail: req.body.organizerEmail,
          accountMobileNo: req.body.organizerNumber,
          accountPassword: "qwerty",
          role: "organizer",
        })
        .then(function (response) {
          console.log(response.data);
          return res
            .status(200)
            .json({ message: "Event Added Successfully", eventId: result.id });
        })
        .catch(function (error) {
          console.log(error);
          return res.status(500).json({ message: "Internal Server Error" });
        });
    }

    // Redirect to the home page and give the message as "Event Added Successfully"
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.deleteEventById = async (req, res) => {
  try {
    console.log("Hit");

    let event = new Event();
    let result = await event.deleteEventById(req.params.eventId);

    // if (result == "ok") {
    //   return res.status(200).json({ message: "Event Deleted Successfully" });
    // }

    // Redirect to the home page and give the message "Event Deleted Successfully"
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getAllEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllEvents();
    return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllEvents();

    // Render the events list page
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getEventById = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getEventById(req.params.eventId);
    // Render the eventPage with the event details
    res.status(200).json({ result });
  } catch (e) {
    console.log(e);
  }
};
exports.getEventCertificateTemplates = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getEventCertificateTemplates(req.params.eventId);
    // Render the eventPage with the event details
    res.status(200).json({ result });
  } catch (e) {
    console.log(e);
  }
};

exports.getSingleEventById = async (req, res) => {
  try {
    const { eventId } = req.body;

    let event = new Event();
    let result = await event.getEventById(eventId);

    return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getUpcomingEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllUpcomingEvents();

    // Render All Upcoming Events in datatable
  } catch (e) {
    console.log(e);
  }
};

exports.getAllUpcomingEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllUpcomingEvents();

    // Render All Upcoming Events in datatable
    return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getCompletedEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllCompletedEvents();

    // Render All Completed Events in datatable
  } catch (e) {
    console.log(e);
  }
};

exports.getAllCompletedEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllCompletedEvents();

    return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getOngoingEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllOngoingEvents();

    // Render All Ongoing Events in datatable
  } catch (e) {
    console.log(e);
  }
};

exports.getAllOngoingEvents = async (req, res) => {
  try {
    let event = new Event();
    let result = await event.getAllOngoingEvents();

    return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.registerEvent = async (req, res) => {
  try {
    const { userId, eventId, registeringAs } = req.body;

    let event = new Event();
    let user = new User();
    let result = await event.registerEvent(userId, eventId, registeringAs);

    return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getUserEventRegistrationCountById = async (req, res) => {
  try {
    const { userId } = req.body;

    let event = new Event();
    let count = await event.getUserEventRegistrationCountById(userId);

    return res.status(200).json({ count });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getUserEventParticipationCountById = async (req, res) => {
  try {
    const { userId } = req.body;

    let event = new Event();
    let count = await event.getUserEventParticipationCountById(userId);

    return res.status(200).json({ count });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getTotalEventsCount = async (req, res) => {
  try {
    let event = new Event();

    let count = await event.getTotalEventsCount();

    return res.json({ count });
  } catch (e) {
    console.log(e);
  }
};

exports.getAllUpcomingEventsCount = async (req, res) => {
  try {
    let event = new Event();

    let count = await event.getAllUpcomingEventsCount();

    // This should be displayed on webapp dashboard in chart section
    return res.json({ count });
  } catch (e) {
    console.log(e);
  }
};

exports.getAllCompletedEventsCount = async (req, res) => {
  try {
    let event = new Event();

    let count = await event.getAllCompletedEventsCount();

    // This should be displayed on webapp dashboard in chart section
    return res.json({ count });
  } catch (e) {
    console.log(e);
  }
};

exports.getAllOngoingEventsCount = async (req, res) => {
  try {
    let event = new Event();

    let count = await event.getAllOngoingEventsCount();

    // This should be displayed on webapp dashboard in chart section

    return res.json({ count });
  } catch (e) {
    console.log(e);
  }
};

exports.markPresent = async (req, res) => {
  try {
    const { eventId, userId } = req.body;

    let event = new Event();
    let eventDoc = await event.getEventById(eventId);

    if (
      eventDoc.registeredParticipants.find(
        (current) => current.userId.toString() === userId
      )
    ) {
      // Means, The user has already registered in the event.
      if (
        !eventDoc.presentParticipants.find(
          (current) => current.userId.toString() === userId
        )
      ) {
        // Means, The user has registered in the event but not yet attended in the event.

        // Add the user, in the presentParticipants
        let result = await event.markPresent(userId, eventId);

        if (result == "ok") {
          return res
            .status(200)
            .json({ message: "Present Marked Successfully" });
        }
      } else {
        // Means, The user has already attended the event.
        return res.status(200).json({ message: "Already Present" });
      }
    } else {
      // Means, The user has not registered in the event.
      return res.status(200).json({ message: "Not Registered" });
    }
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getPresentParticipants = async (req, res) => {
  try {
    const { eventId } = req.body;

    let event = new Event();
    let result = await event.getPresentParticipants(eventId);

    // Show the present participants in the eventPage in the datatable and there should be button to generate certificate of the user
    // return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getRegisteredParticipants = async (req, res) => {
  try {
    const { eventId } = req.body;

    let event = new Event();
    let result = await event.getRegisteredParticipants(eventId);

    // Show the present participants in the eventPage in the datatable and there should be button to generate certificate of the user
    return res.status(200).json({ result });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.generateCertificate = async (req, res) => {
  try {
    console.log("Generate Certificate route called");
    const { userId, eventId } = req.body;

    let event = new Event();
    let user = new User();
    let userDoc = await user.getUserById(userId);
    console.log(userDoc);

    // Marks the certificateReceived true in the presentParticipants in the user.
    await event.markCertificateReceived(userId, eventId);

    const fullName = `
        ${userDoc.userFirstName + " " + userDoc.userLastName}
      `;
    // axios.get("http://localhost:4000/").then(function (response) {
    //   console.log(response);
    // });

    const certificateTemplate = await event.getEventCertificateTemplates(
      eventId
    );

    const image = await jimp.read(
      path.join(
        __dirname,
        `../public/certificate/${certificateTemplate.participationCertificateTemplate}`
      )
    );

    console.log("Hello image");
    console.log(image);

    const font = await jimp.loadFont(jimp.FONT_SANS_128_BLACK);

    image.print(font, 1000, 1200, fullName);
    // image.print(font, 250, 400, doc);
    // image.quality(100)
    image.resize(1920, 1080);

    await image.writeAsync(
      path.join(
        __dirname,
        `../public/certificate/certificate(${
          userDoc.userFirstName + " " + userDoc.userLastName
        }).png`
      )
    );

    // const name = path.resolve(
    //   __dirname,
    //   `../public/certificates/certificate(${
    //     userDoc.userFirstName + " " + userDoc.userLastName
    //   }).png`
    // );

    // fs.readFile(name, (err, file) => {
    //   // if(err){
    //   //   req.flash("errors", "Couldn't Download")
    //   //   req.session.save(function() {
    //   //     res.redirect(`/clientEventPage/${eventDoc._id}`)
    //   //   })
    //   // }
    //   if (err) return res.status(500).send("Erro" + err);

    //   res.setHeader("Content-Type", "image/png");
    //   res.setHeader(
    //     "Content-Disposition",
    //     `attachment;filename=certificate(${
    //       userDoc.userFirstName + " " + userDoc.userLastName
    //     }).png`
    //   );
    //   return res.send(file);
    // });
    let name = `/certificate(${
      userDoc.userFirstName + " " + userDoc.userLastName
    }).png`;

    // Flash the message as Certificate has been generated in the web app;
    return res.status(200).json({ name });
  } catch (e) {
    console.log(e);
    // return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.checkIfAlreadyRegistered = async function (req, res) {
  try {
    const { userId, eventId } = req.body;

    let event = new Event();
    let data = await event.checkIfAlreadyRegistered(userId, eventId);
    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getUserRegisteredEvents = async function (req, res) {
  try {
    const { userId } = req.body;

    let event = new Event();
    let data = await event.getUserRegisteredEvents(userId);

    return res.status(200).json({ result: data });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getUserCompletedEvents = async function (req, res) {
  try {
    const { userId } = req.body;

    let event = new Event();
    let data = await event.getUserCompletedEvents(userId);

    return res.status(200).json({ result: data });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getOngoingEventsByEmail = async function (req, res) {
  try {
    let { organizerEmail } = req.body;

    let event = new Event();
    let data = await event.getOngoingEventsByEmail(organizerEmail);

    return res.status(200).json({ result: data });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getLatest3UserRegisteredEvents = async function (req, res) {
  try {
    const { userId } = req.body;

    let event = new Event();
    let data = await event.getLatest3UserRegisteredEvents(userId);

    return res.status(200).json({ result: data });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getUpcomingEventsOfMonth = async function (req, res) {
  try {
    let event = new Event();
    let data = await event.getUpcomingEventsOfMonth();
    return res.status(200).json({ result: data });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

// Frontend Controller
exports.viewAllEventsPage = async (req, res) => {
  if (!req.session.authority) {
    return req.redirect("/authority/login-page");
  }
  try {
    const events = await new Event().getAllEvents();
    res.render("Events/viewAllEvents", { events: events });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching events");
  }
};
exports.viewUpcomingEventsPage = async (req, res) => {
  if (!req.session.authority) {
    return req.redirect("/authority/login-page");
  }
  try {
    const upcomingEvents = await new Event().getAllUpcomingEvents();
    res.render("Events/viewUpcomingEvents", { upcomingEvents: upcomingEvents });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching upcoming  events");
  }
};
exports.viewOngoingEventsPage = async (req, res) => {
  if (!req.session.authority) {
    res.redirect("/authority/login-page");
  }
  try {
    const ongoingEvents = await new Event().getAllOngoingEvents();
    res.render("Events/viewOngoingEvents", { ongoingEvents: ongoingEvents });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching ongoing events");
  }
};
exports.viewCompletedEventsPage = async (req, res) => {
  if (!req.session.authority) {
    res.redirect("/authority/login-page");
  }
  try {
    const completedEvents = await new Event().getAllCompletedEvents();
    res.render("Events/viewCompletedEvents", {
      completedEvents: completedEvents,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching ongoing events");
  }
};
exports.viewEventsByIdPage = async (req, res) => {
  if (!req.session.authority) {
    res.redirect("authority/login-page");
  }
  try {
    const eventId = req.params.eventId;
    const event = await new Event().getEventById(eventId);
    res.render("Events/viewIndivitualEvents", { result: event });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching indivitual event");
  }
};
exports.addEventsPage = async (req, res) => {
  if (!req.session.authority) {
    res.redirect("authority/login-page");
  }
  res.render("Events/addEvents");
};
