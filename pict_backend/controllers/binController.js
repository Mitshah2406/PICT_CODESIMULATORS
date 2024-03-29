const Bin = require("../models/Bin");
const Depot = require("../models/Depot");


// Backend Routes for bin
exports.getAllBins = async function(req,res){
    try{
        let bin = new Bin()
        bins = await bin.getAllBins()
        res.status(200).json(bins);
    } catch(err) {
        console.log(err);
        res.status(400).json({error:'Error in getting bin info'});
    }
}
exports.addBin= async function(req,res){
    try{
        let bin = new Bin(req.body)
        let result  = await bin.addBin()
        res.status(201).json({'message':'Bin added successfully','data':result})
        
    }catch(err){
        console.log(err);
        res.status(400).json({'error':'Error in adding the bin'});
    }
} 
exports.getBinLocationById = async function(req, res) {
    const binId = req.params.binId;
    try {
        let bin = new Bin();
        const location = await bin.getBinLocationById(binId);
        res.status(200).json({ 'location': location });
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in fetching bin location'});
    }
};

exports.getBinFillLevelById = async function(req, res) {
    const binId = req.params.binId;
    try {
        let bin = new Bin();
        const fillLevelInfo = await bin.getBinFillLevelById(binId);
        res.status(200).json(fillLevelInfo);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in fetching bin fill level'});
    }
};

exports.addWaste = async function(req, res) {
    const binId = req.params.binId;
    const wasteAmount = req.body.wasteAmount;
    try {
        let bin = new Bin();
        const updatedFillLevelInfo = await bin.addWaste(binId, wasteAmount);
        res.status(200).json(updatedFillLevelInfo);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in adding waste to the bin'});
    }
};

exports.collectWaste = async function(req, res) {
    const binId = req.params.binId;
    try {
        let bin = new Bin();
        await bin.collectWaste(binId);
        res.status(200).json({'message':'Waste collected successfully'});
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in collecting waste from the bin'});
    }
};

exports.getReverseGeoCodedLocationsOfAllBins = async function(req, res) {
    try {
        let bin = new Bin();
        let depot = new Depot();
        let locations = await bin.getReverseGeoCodedLocationsOfAllBins();
        let depotLoc = await depot.getAllDepots();
        let newArr = depotLoc.concat(locations);
        console.log(newArr);
        res.status(200).json(locations);
    } catch (error) {
        console.log(err);
        res.status(400).json({ 'error': 'Error in collecting waste from the bin' });
    }
}
exports.updateBinFillLevel = async function(req, res) {
    console.log("HITTT")
    const binId = req.params.binId;
    const input = parseInt(req.body.binFillLevel);
    
    try {
        let bin = new Bin();
        const updatedFillLevelInfo = await bin.updateBinFillLevel(binId, input);
        res.status(200).json(updatedFillLevelInfo);
    } catch(err) {
        console.log(err);
        res.status(400).json({ 'error': 'Error in updating bin fill level' });
    }
};