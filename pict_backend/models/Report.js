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
        lat: this.data.lat,
        lon: this.data.lon,
        reportAttachment: this.data.reportAttachment,
        formattedAddress: this.data.formattedAddress,
        reportStatus: "pending", //options: 1. pending (by default) 2. resolved  3. rejected (fake report)
        createdOn: new Date()
    }
}



Report.prototype.addReport = async function () {
    this.cleanUp();
    try {
        console.log("Function called")
        console.log(this.data)

        let data = await reportCollection.insertOne(this.data);
        console.log(data.insertedId)
        return data.insertedId;
    } catch (e) {
        console.log(e)
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
        return data
    } catch (e) {
        console.log(e);
    }
};

Report.prototype.getReportById = async function (reportId) {
    let data = await reportCollection.findOne({ _id: new ObjectID(reportId) });
    return data;
}

Report.prototype.changeReportStatus = async function (reportId, reportStatus) {
    let data = await reportCollection.findOneAndUpdate({ _id: new ObjectID(reportId) },
        { $set: { reportStatus: reportStatus } });

    return "Updated";
}
Report.prototype.getReportsByStatus = async function (reportStatus) {
    let data = await reportCollection.find({ reportStatus: reportStatus }).toArray();
    return data;
}
module.exports = Report