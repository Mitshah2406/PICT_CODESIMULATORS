const eventsCollection = require("../db").db().collection("events");
const ObjectID = require("mongodb").ObjectID;
// const bcrypt = require("bcrypt");
// const validator = require("validator");
// const md5 = require("md5");
// const { ReturnDocument } = require("mongodb");

let Event = function (data) {
  this.data = data;
  this.errors = [];
};

Event.prototype.cleanUp = function () {
  this.data = {
    eventName: this.data.eventName,
    eventDescription: this.data.eventDescription,
    eventPoster: this.data.eventPoster,
    eventStartDate: new Date(this.data.startDate),
    eventStartTime: this.data.startTime,
    eventEndDate: new Date(this.data.endDate),
    eventEndTime: this.data.endTime,
    // isInCollabaration: Boolean(this.data.isInCollabaration),  take this to conditionally show the collab fields on fronted (FOR TAHER)
    collabOrganizationName: this.data.collabOrganizationName,
    collabOrgEmail: this.data.collabOrgEmail,
    eventAttachment: this.data.eventAttachment,
    organizerName: this.data.organizerName,
    organizerEmail: this.data.organizerEmail,
    organizerNumber: this.data.organizerNumber,
    whatsAppLink: this.data.whatsAppLink,
    // areVolunteersNeeded: Boolean(this.data.areVolunteersNeeded), take this to conditionally show the volunteers fields on fronted (FOR TAHER)
    eventAddress: this.data.eventAddress,
    eventCity: this.data.eventCity,
    noOfVolunteersNeeded: Number(this.data.noOfVolunteersNeeded),
    participationCertificateTemplate:
      this.data.participationCertificateTemplate,
    volunteerCertificateTemplate: this.data.volunteerCertificateTemplate,
    volunteerResponsibilities: this.data.volunteerResponsibilities,
    volunteers: [],
    // If user has not registered, but they want to participate in event
    registeredParticipants: [],
    presentParticipants: [],

    createdDate: new Date(),
  };
};

Event.prototype.addEvent = async function () {
  this.cleanUp();
  let event = await eventsCollection.insertOne(this.data);
  return {
    id: event.insertedId,
    status: "ok",
  };
};

Event.prototype.deleteEventById = async function (eventId) {
  await eventsCollection.findOneAndDelete({ _id: new ObjectID(eventId) });

  return "ok";
};

Event.prototype.getAllEvents = async function () {
  let data = await eventsCollection.find().toArray();

  return data;
};

Event.prototype.getEventById = async function (eventId) {
  let data = await eventsCollection.findOne({ _id: new ObjectID(eventId) });

  return data;
};
Event.prototype.getEventCertificateTemplates = async function (eventId) {
  let data = await eventsCollection.findOne({ _id: new ObjectID(eventId) });

  return {
    participationCertificateTemplate: data.participationCertificateTemplate,
    volunteerCertificateTemplate: data.volunteerCertificateTemplate,
  };
};

Event.prototype.getAllUpcomingEvents = async function () {
  let data = await eventsCollection
    .find({
      eventStartDate: { $gte: new Date() },
    })
    .toArray();

  return data;
};

Event.prototype.getAllCompletedEvents = async function () {
  let data = await eventsCollection
    .find({
      eventEndDate: { $lte: new Date() },
    })
    .toArray();

  return data;
};

Event.prototype.getAllOngoingEvents = async function () {
  let data = await eventsCollection
    .find({
      $and: [
        { eventStartDate: { $lte: new Date() } },
        { eventEndDate: { $gte: new Date() } },
      ],
    })
    .toArray();

  return data;
};

Event.prototype.registerEvent = async function (
  userId,
  eventId,
  registeringAs
) {
  if (registeringAs === "participant") {
    let data = await eventsCollection.findOneAndUpdate(
      {
        _id: new ObjectID(eventId),
      },
      {
        $push: {
          registeredParticipants: {
            userId: new ObjectID(userId),
            registeredDate: new Date(),
          },
        },
      }
    );
  } else {
    let data = await eventsCollection.findOneAndUpdate(
      {
        _id: new ObjectID(eventId),
      },
      {
        $push: {
          registeredParticipants: {
            userId: new ObjectID(userId),
            registeredDate: new Date(),
          },
          volunteers: {
            userId: new ObjectID(userId),
            registeredDate: new Date(),
          },
        },
      }
    );
  }

  return "ok";
};

Event.prototype.getUserEventRegistrationCountById = async function (userId) {
  let data = await eventsCollection.countDocuments({
    registeredParticipants: {
      $elemMatch: {
        userId: new ObjectID(userId),
      },
    },
  });

  return data;
};

Event.prototype.getTotalEventsCount = async function () {
  let data = await eventsCollection.countDocuments();

  return data;
};

Event.prototype.getAllUpcomingEventsCount = async function () {
  let data = await eventsCollection.countDocuments({
    eventStartDate: { $gte: new Date() },
  });

  return data;
};

Event.prototype.getAllCompletedEventsCount = async function () {
  let data = await eventsCollection.countDocuments({
    eventEndDate: { $lte: new Date() },
  });

  return data;
};

Event.prototype.getAllOngoingEventsCount = async function () {
  let data = await eventsCollection.countDocuments({
    $and: [
      { eventStartDate: { $lte: new Date() } },
      { eventEndDate: { $gte: new Date() } },
    ],
  });

  return data;
};

Event.prototype.markPresent = async function (userId, eventId) {
  let data = await eventsCollection.findOneAndUpdate(
    {
      _id: new ObjectID(eventId),
    },
    {
      $push: {
        presentParticipants: {
          userId: new ObjectID(userId),
          certificateReceived: true,
          date: new Date(),
        },
      },
    }
  );

  return "ok";
};

Event.prototype.getUserEventParticipationCountById = async function (userId) {
  let data = await eventsCollection.countDocuments({
    presentParticipants: {
      $elemMatch: {
        userId: new ObjectID(userId),
      },
    },
  });

  return data;
};

Event.prototype.getPresentParticipants = async function (eventId) {
  let data = await eventsCollection
    .aggregate([
      {
        $match: {
          _id: new ObjectID(eventId),
        },
      },
      {
        $unwind: "$presentParticipants",
      },
      {
        $lookup: {
          from: "users",
          localField: "presentParticipants.userId",
          foreignField: "_id",
          as: "userData",
        },
      },
      {
        $unwind: "$userData",
      },
      {
        $group: {
          _id: new ObjectID(eventId),
          users: {
            $addToSet: "$userData",
          },
        },
      },
    ])
    .toArray();

  if (data.length > 0) {
    return data;
  }

  return null;
};

Event.prototype.getRegisteredParticipants = async function (eventId) {
  let data = await eventsCollection
    .aggregate([
      {
        $match: {
          _id: new ObjectID(eventId),
        },
      },
      {
        $unwind: "$registeredParticipants",
      },
      {
        $lookup: {
          from: "users",
          localField: "registeredParticipants.userId",
          foreignField: "_id",
          as: "userData",
        },
      },
      {
        $unwind: "$userData",
      },
      {
        $group: {
          _id: new ObjectID(eventId),
          users: {
            $addToSet: "$userData",
          },
        },
      },
    ])
    .toArray();

  if (data.length > 0) {
    return data;
  }

  return null;
};

Event.prototype.markCertificateReceived = async function (userId, eventId) {
  try {
    await eventsCollection.findOneAndUpdate(
      {
        _id: new ObjectID(eventId),
        "presentParticipants.userId": new ObjectID(userId),
      },
      {
        $set: {
          "presentParticipants.$.certificateReceived": true,
        },
      }
    );
  } catch (e) {
    console.log(e);
  }
};

Event.prototype.checkIfAlreadyRegistered = async function (userId, eventId) {
  let event = await eventsCollection.findOne({ _id: new ObjectID(eventId) });

  let isPresent = event.registeredParticipants.some((user) =>
    user.userId.equals(new ObjectID(userId))
  );

  return isPresent;
};

Event.prototype.getUserRegisteredEvents = async function (userId) {
  let data = await eventsCollection
    .find({
      registeredParticipants: {
        $elemMatch: {
          userId: new ObjectID(userId),
        },
      },
    })
    .sort({ _id: -1 })
    .toArray();

  return data;
};

Event.prototype.getUserCompletedEvents = async function (userId) {
  let data = await eventsCollection
    .find({
      presentParticipants: {
        $elemMatch: {
          userId: new ObjectID(userId),
          certificateReceived: true,
        },
      },
    })
    .sort({ _id: -1 })
    .toArray();

  return data;
};

Event.prototype.getOngoingEventsByEmail = async function (email) {
  let data = await eventsCollection
    .find({
      organizerEmail: email,
      $and: [
        { eventStartDate: { $lte: new Date() } },
        { eventEndDate: { $gte: new Date() } },
      ],
    })
    .toArray();

  return data;
};

Event.prototype.getLatest3UserRegisteredEvents = async function (userId) {
  let data = await eventsCollection
    .find({
      registeredParticipants: {
        $elemMatch: {
          userId: new ObjectID(userId),
        },
      },
    })
    .sort({ _id: -1 })
    .limit(3)
    .toArray();

  return data;
};

Event.prototype.getUpcomingEventsOfMonth = async function () {
  let currentDate = new Date();

  let lastDayOfMonth = new Date(
    currentDate.getFullYear(),
    currentDate.getMonth() + 1,
    0 // It represents last day of the month i.e 31 march
  );

  let data = await eventsCollection
    .find({
      eventStartDate: { $gte: new Date(), $lte: lastDayOfMonth },
    })
    .toArray();

  return data;
};

module.exports = Event;
