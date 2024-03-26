const Depot = require("../models/Depot")

// Backend routes for depot
exports.getAllDepots = async function(req,res){
    try{
        let depot = Depot()
        depots = await depot.getAllDepots
        res.status(200).json(depots);
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in getting depot info'});
    }
}
exports.addDepot= async function(req,res){
    try{
        let depot = new Depot(req.body)
        let result  = await depot.addDepot()
        res.status(201).json({'message':'Depot added successfully','data':result})
        
    }catch(err){
        console.log(err);
        res.status(400).json({'error':'Error in adding the Depot'});
    }
} 
exports.getDepotLocationById = async function(req, res) {
    const depotId = req.params.depotId;
    try {
        let depot = new Depot();
        const location = await depot.getDepotLocationById(depotId);
        res.status(200).json({ 'location': location });
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in fetching depot location'});
    }
};
exports.getDepotCapacityById = async function(req, res) {
    const depotId = req.params.depotId;
    try {
        let depot = new Depot();
        const capacity = await depot.getDepotCapacityById(depotId);
        res.status(200).json({ 'capacity': capacity });
    } catch(err) {
        console.log(err);
        res.status(400).json({'error':'Error in fetching depot capacity'});
    }
};