const Truck = require("../models/Truck");

// Backend Routes for trucks
exports.getAllTrucks = async function(req, res) {
    try {
        let truck = new Truck();
        const trucks = await truck.getAllTrucks();
        res.status(200).json(trucks);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in getting truck info'});
    }
};

exports.getTruckById = async function(req, res) {
    const truckId = req.params.truckId;
    try {
        let truck = new Truck();
        const truckInfo = await truck.getTruckById(truckId);
        res.status(200).json(truckInfo);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in fetching truck information'});
    }
};

exports.addWaste = async function(req, res) {
    const truckId = req.params.truckId;
    const wasteAmount = req.body.wasteAmount;
    try {
        let truck = new Truck();
        const updatedFillLevelInfo = await truck.addWaste(truckId, wasteAmount);
        res.status(200).json(updatedFillLevelInfo);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in adding waste to the truck'});
    }
};

exports.collectBin = async function(req, res) {
    const truckId = req.params.truckId;
    const binId = req.body.binId;
    try {
        let truck = new Truck();
        await truck.collectBin(truckId, binId);
        let bin = new Bin();
        await bin.collectWaste(binId);
        res.status(200).json({'message':'Bin collected successfully'});
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in collecting bin'});
    }
};

exports.pendingBins = async function(req, res) {
    const truckId = req.params.truckId;
    try {
        let truck = new Truck();
        const pendingBinIds = await truck.pendingBins(truckId);
        res.status(200).json(pendingBinIds);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in fetching pending bins'});
    }
};

exports.resetBinsCollectedStatus = async function(req, res) {
    const truckId = req.params.truckId;
    try {
        let truck = new Truck();
        await truck.resetBinsCollectedStatus(truckId);
        res.status(200).json({'message':'Bins collected status reset successfully'});
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in resetting bins collected status'});
    }
};

exports.getPendingBinsWithLocations = async function(req, res) {
    const truckId = req.params.truckId;
    try {
        let truck = new Truck();
        const pendingBinsWithLocations = await truck.getPendingBinsWithLocations(truckId);
        res.status(200).json(pendingBinsWithLocations);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in fetching pending bins with locations'});
    }
};
