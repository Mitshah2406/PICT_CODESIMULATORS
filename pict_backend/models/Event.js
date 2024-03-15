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
    eventLikeCount: 0,
    eventStartDate: new Date(this.data.startDate),
    eventStartTime: this.data.startTime,
    eventEndDate: new Date(this.data.endDate),
    eventEndTime: this.data.endTime,
    eventAttachment: this.data.eventAttachment,
    contactName1: this.data.contactName1,
    contactNo1: this.data.contactNo1,
    contactName2: this.data.contactName2,
    contactNo2: this.data.contactNo2,
    workSubmissionMail: this.data.email,
    whatsAppLink: this.data.whatsAppLink,
    isCertificate: Boolean(this.data.isCertificate),
    // If user has not registered, but they want to participate in event
    isWalkIn: Boolean(this.data.isWalkIn),
    registeredParticipants: [],
    presentParticipants: [],
    // winners: [],
    createdDate: new Date(),
  };
};

Event.prototype.addEvent = async function () {
  this.cleanUp();
  await eventsCollection.insertOne(this.data);
  return "ok";
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

Event.prototype.registerEvent = async function (userId, eventId) {
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

  return data;
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
          certificateReceived: false,
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
  let isPresent = await eventsCollection
    .aggregate([
      {
        $match: {
          _id: new ObjectID(eventId),
        },
      },
      {
        $project: {
          isRegistered: {
            $in: [new ObjectID(userId), "$registeredParticipants.userId"],
          },
        },
      },
    ])
    .toArray();

  console.log(isPresent);

  return isPresent;
};

module.exports = Event;
