const { ObjectId } = require("mongodb");
const binCollection = require("../db").db().collection("bins");
const trucksCollection = require("../db").db().collection("trucks");
const ObjectID = require("mongodb").ObjectID;

let Truck = function (data) {
    this.data = data;
    this.errors = [];
  };

  Truck.prototype.cleanUp=function(){
    this.data={
        todaysRoutes: [{
         binId: ObjectID(this.data.binId),
          collected: Boolean(this.data.collected)
        }],
        driver: ObjectID(this.data.driver),
        truckFillLevel:Number(this.data.truckFillLevel), // percentage value
        truckFillLevelInKg:Number(this.data.truckFillLevelInKg),
        truckCapacityInKg:Number(this.data.truckCapacityInKg),
        lastUpdated: new Date(this.data.lastUpdated),
        createdDate: new Date(),
    }
}
Truck.prototype.getAllTrucks = async function(){
    const trucks = await trucksCollection.find()
    return trucks
}
Truck.prototype.getTruckById = async function(truckId) {
        const truck = await trucksCollection.findOne({ _id: ObjectId(truckId) });
        return truck;
};
Truck.prototype.addWaste = async function(truckId, wasteAmount) {
    let truck = await trucksCollection.findOne({ _id: new ObjectId(truckId) });
    const currentFillLevelInKg = truck.truckFillLevelInKg;
    const truckCapacityInKg = truck.truckCapacityInKg;
    const newTruckFillLevelInKg = currentFillLevelInKg + parseFloat(wasteAmount);
    const newTruckFillLevel = (newTruckFillLevelInKg / truckCapacityInKg) * 100;
    await trucksCollection.updateOne(
        { _id: new ObjectId(truckId) },
        {
            $set: {
                truckFillLevelInKg: newTruckFillLevelInKg,
                truckFillLevel: newTruckFillLevel,
                lastUpdated: new Date()
            }
        }
    );

    return { 
        truckFillLevelInKg: newTruckFillLevelInKg,
        truckFillLevel: newTruckFillLevel 
    };

}

Truck.prototype.collectBin = async function(truckId, binId) {
        const truck = await trucksCollection.findOne({ _id: new ObjectId(truckId) });
        if (!truck) {
            throw new Error("Truck not found");
        }
        const todaysRoutes = truck.todaysRoutes;
        const index = todaysRoutes.findIndex(route => route.binId.equals(binId));
        if (index === -1) {
            throw new Error("Bin not found in todaysRoutes");
        }
        todaysRoutes[index].collected = true;
        newTruck= await trucksCollection.updateOne(
            { _id: new ObjectId(truckId) },
            { $set: { todaysRoutes: todaysRoutes } }
        );

        return newTruck;
}
Truck.prototype.pendingBins = async function(truckId) {
        const truck = await trucksCollection.findOne({ _id: new ObjectId(truckId) });
        if (!truck) {
            throw new Error("Truck not found");
        }
        const pendingBins = truck.todaysRoutes.filter(route => route.collected === false);
        const pendingBinIds = pendingBins.map(route => route.binId);
        return {pendingBinIds: pendingBinIds };
} 
Truck.prototype.resetBinsCollectedStatus = async function(truckId) {
        const truck = await trucksCollection.findOne({ _id: new ObjectId(truckId) });
        if (!truck) {
            throw new Error("Truck not found");
        }
        const updatedRoutes = truck.todaysRoutes.map(route => ({
            ...route,
            collected: false
        }));
        await trucksCollection.updateOne(
            { _id: new ObjectId(truckId) },
            { $set: { todaysRoutes: updatedRoutes } }
        );
};
Truck.prototype.getPendingBinsWithLocations = async function(truckId) {
        const truck = await trucksCollection.findOne({ _id: new ObjectId(truckId) });
        if (!truck) {
            throw new Error("Truck not found");
        }
        const pendingRoutes = truck.todaysRoutes.filter(route => !route.collected);
        const pendingBinIds = pendingRoutes.map(route => route.binId);
        const pendingBins = await binCollection.find({ _id: { $in: pendingBinIds } }).toArray();
        const pendingBinsWithLocations = pendingBins.map(bin => ({
            binId: bin._id,
            location: bin.binLocation
        }));
        return pendingBinsWithLocations;
};
module.exports= Truck;



  