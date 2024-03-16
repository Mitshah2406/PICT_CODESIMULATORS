const { ObjectID } = require("mongodb");

const wastePickupScheduleCollection = require("../db").db().collection("wastePickupSchedule");

let WastePickupSchedule = function (data) {
    this.data = data;
    this.errors = [];
};

WastePickupSchedule.prototype.cleanUp = function () {
    this.data = {
        startTime: this.data.startTime,
        endTime: this.data.endTime,
        pickupLocation: this.data.pickupLocation,
        pickupSector: this.data.pickupSector,
        repeatInterval: "daily",// or alternate(days), weekly
        // truckId: ObjectID(this.data.truckId),
        createdOn: new Date()
    }
}

WastePickupSchedule.prototype.addWastePickupSchedule = async function () {
    this.cleanUp();
    let wastePickupSchedule = await wastePickupScheduleCollection.insertOne(this.data);
    return wastePickupSchedule.insertedId;
}


module.exports = WastePickupSchedule;