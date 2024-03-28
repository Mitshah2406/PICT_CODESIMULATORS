const { ObjectID } = require("mongodb");

const reportCollection = require("../db").db().collection("reports");

let Report = function (data) {
  this.data = data;
  this.errors = [];
};

Report.prototype.cleanUp = function () {
  this.data = {
    uploaderId: ObjectID(this.data.uploaderId),
    uploaderName: this.data.uploaderName,
    uploaderEmail: this.data.uploaderEmail,
    description: this.data.description,
    location: {
      lat: this.data.lat,
      lon: this.data.lon,
      formattedAddress: this.data.formattedAddress,
    },
    reportAttachment: this.data.reportAttachment,
    reportStatus: this.data.reportStatus, //options: 1. pending (by default) 2. resolved  3. rejected (fake report)
    message:this.data.message,
    createdOn: new Date(),
  };
};

Report.prototype.addReport = async function () {
  this.cleanUp();
  try {
    console.log("Function called");
    console.log(this.data);
    if (!this.data.reportStatus) {
      // Set reportStatus to "pending" if not provided
      this.data.reportStatus = "pending";
    }
    let data = await reportCollection.insertOne(this.data);
    console.log(data.insertedId);
    if (data.acknowledged) {
      return "ok";
    }
    return "fail";
  } catch (e) {
    console.log(e);
  }
};

Report.prototype.getAllReports = async function () {
  let data = await reportCollection.find({}).toArray();
  console.log(data);
  return data;
};

Report.prototype.deleteReport = async function (reportId) {
  try {
    let data = await reportCollection.findOneAndDelete({
      _id: new ObjectID(reportId),
    });
    return data;
  } catch (e) {
    console.log(e);
  }
};

Report.prototype.getReportById = async function (reportId) {
  let data = await reportCollection.findOne({ _id: new ObjectID(reportId) });
  return data;
};

Report.prototype.changeReportStatus = async function (reportId, reportStatus) {
  let data = await reportCollection.findOneAndUpdate(
    { _id: new ObjectID(reportId) },
    { $set: { reportStatus: reportStatus } }
  );

  return "Updated";
};
Report.prototype.getReportsByStatus = async function (reportStatus) {
  let data = await reportCollection
    .find({ reportStatus: reportStatus })
    .toArray();
  return data;
};

Report.prototype.getAllUserReports = async function (userId, filter) {
  if (filter == "") {
    let data = await reportCollection
      .find({ uploaderId: new ObjectID(userId) })
      .sort({ _id: -1 })
      .toArray();
    return data;
  } else {
    let data = await reportCollection
      .find({ uploaderId: new ObjectID(userId), reportStatus: filter })
      .sort({ _id: -1 })
      .toArray();
    return data;
  }
};

Report.prototype.getAllUserPendingReports = async function (userId) {
  let data = await reportCollection
    .find({ uploaderId: new ObjectID(userId), reportStatus: "pending" })
    .sort({ _id: -1 })
    .toArray();

  return data;
};

Report.prototype.getAllUserResolvedReports = async function (userId) {
  let data = await reportCollection
    .find({ uploaderId: new ObjectID(userId), reportStatus: "resolved" })
    .sort({ _id: -1 })
    .toArray();

  return data;
};

Report.prototype.getAllUserRejectedReports = async function (userId) {
  let data = await reportCollection
    .find({ uploaderId: new ObjectID(userId), reportStatus: "rejected" })
    .sort({ _id: -1 })
    .toArray();

  return data;
};

Report.prototype.getCountOfAllUserReports = async function (userId) {
  let data = await reportCollection.countDocuments({
    uploaderId: new ObjectID(userId),
  });

  return data;
};

Report.prototype.searchReport = async function (searchTerm) {
  if (searchTerm.length > 0) {
    let data = await reportCollection
      .aggregate([
        {
          $search: {
            index: "searchReport",
            text: {
              query: searchTerm,
              path: {
                wildcard: "*",
              },
              fuzzy: {
                maxEdits: 2,
                prefixLength: 0,
                maxExpansions: 50,
              },
            },
          },
        },
      ])
      .toArray();

    return data;
  }

  return null;
};

module.exports = Report;
