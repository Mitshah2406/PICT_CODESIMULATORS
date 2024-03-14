const Event = require("../models/Event");
const path = require("path");
const fs = require("fs");
const { ObjectID } = require("mongodb");
const User = require("../models/User");

exports.addEvent = async function (req, res) {
  try {
    let multipleNames = [];
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
    }

    let event = new Event(req.body);
    console.log(req.body);
    let result = await event.addEvent();

    // if (result == "ok") {
    //   return res.status(200).json({ message: "Event Added Successfully" });
    // }

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

    // Render the eventPage with all the details
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
    const { userId, eventId } = req.body;

    let event = new Event();
    let user = new User();
    let result = await event.registerEvent(userId, eventId);

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
    let result = await event.getUserEventRegistrationCountById(userId);

    return res.status(200).json({ result });
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
    // return res.json({ count });
  } catch (e) {
    console.log(e);
  }
};

exports.getAllCompletedEventsCount = async (req, res) => {
  try {
    let event = new Event();

    let count = await event.getAllCompletedEventsCount();

    // This should be displayed on webapp dashboard in chart section
    // return res.json({ count });
  } catch (e) {
    console.log(e);
  }
};

exports.getAllOngoingEventsCount = async (req, res) => {
  try {
    let event = new Event();

    let count = await event.getAllOngoingEventsCount();

    // This should be displayed on webapp dashboard in chart section

    // return res.json({ count });
  } catch (e) {
    console.log(e);
  }
};
