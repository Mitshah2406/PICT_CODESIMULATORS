const binCollection = require("../db").db().collection("bins");
const { ObjectID } = require('mongodb');
const axios = require('axios')
let Bin = function(data){
    this.data=data
    this.errors=[];
}
Bin.prototype.cleanUp=function(){
    this.data={
        binLocation: {
          lat: this.data.binLocation.lat,
          lon: this.data.binLocation.lon,
          fotmattedAddress:this.data.binLocation.formattedAddress
        },
        binFillLevel:Number(this.data.binLevel), // percentage value
        binFillLevelInKg:Number(this.data.binLevelInKg),
        binCapacityInKg:Number(this.data.binCapacityInKg),
        lastCollection: new Date(this.data.lastCollection),
        lastUpdated: new Date(this.data.lastUpdated),
        createdDate: new Date(),
    }
}
Bin.prototype.reverseGeocode = async function(lat,lon) {
    const apiKey = 'AIzaSyBw7fIXJz5sA9IEcczMJ9FIzK91jvFIsno';
    const apiUrl = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lon}&key=${apiKey}`
  
    const response = await axios.get(apiUrl);
    try {
        if (response.data && response.data.results && response.data.results.length > 0) {
            return response.data.results[0].formatted_address;
        } else {
            throw new Error('No results found');
        }
    } catch (error) {
        throw new Error('Reverse geocoding failed');
    }
}
Bin.prototype.getAllBins = async function(){
    const binsCursor = await binCollection.find()
    const bins = await binsCursor.toArray();
    return bins;
}
Bin.prototype.addBin=async function (){
    let formattedAddress = await this.reverseGeocode(this.data.binLocation.lat,this.data.binLocation.lon);
    this.data.binLocation.formattedAddress = formattedAddress; // Corrected typo here
    this.cleanUp();
    let bin = await binCollection.insertOne(this.data);
    return{
        id: bin.insertedId,
        status: "ok"
    }
}
Bin.prototype.getBinLocationById=async function (binId){
  let bin = await binCollection.findOne({ _id: new ObjectID(binId) });
  const binLocation = bin.binLocation
    return binLocation;
}
Bin.prototype.getBinFillLevelById=async function (binId,wasteAmount){
  let bin = await binCollection.findOne({ _id: new ObjectID(binId) });
  const binFillLevel = bin.binFillLevel;
  const binFillLevelInKg = bin.binFillLevelInKg
  return {binFillLevel,binFillLevelInKg};
}
Bin.prototype.addWaste = async function(binId, wasteAmount) {
        let bin = await binCollection.findOne({ _id: new ObjectID(binId) });
        const currentFillLevelInKg = bin.binFillLevelInKg;
        const binCapacityInKg = bin.binCapacityInKg;
        const newBinFillLevelInKg = currentFillLevelInKg + parseFloat(wasteAmount);
        const newBinFillLevel = (newBinFillLevelInKg / binCapacityInKg) * 100;
        await binCollection.updateOne(
            { _id: new ObjectID(binId) },
            {
                $set: {
                    binFillLevelInKg: newBinFillLevelInKg,
                    binFillLevel: newBinFillLevel,
                    lastUpdated: new Date()
                }
            }
        );

        return { 
            binFillLevelInKg: newBinFillLevelInKg,
            binFillLevel: newBinFillLevel 
        };

}
Bin.prototype.collectWaste = async function(binId) {
        const updatedBin = await binCollection.updateOne(
            { _id: new ObjectID(binId) },
            {
                $set: {
                    binFillLevelInKg: 0,
                    binFillLevel: 0,
                    lastUpdated: new Date(),
                    lastCollection: new Date()
                }
            }
        );
        return updatedBin;
}
Bin.prototype.getReverseGeoCodedLocationsOfAllBins = async function(){
    const bins = await binCollection.find().toArray();
    return bins
}
Bin.prototype.updateBinFillLevel = async function(binId, input) {
    let bin = await binCollection.findOne({ _id: new ObjectID(binId) });
    let newBinFillLevel;
    if (input === 0) {
        newBinFillLevel = 0;
    } else if (input === 1) {
        newBinFillLevel = 0;
    } else {
        throw new Error('Invalid input. Input must be either 0 or 1.');
    }
    await binCollection.updateOne(
        { _id: new ObjectID(binId) },
        {
            $set: {
                binFillLevel: newBinFillLevel,
                lastUpdated: new Date()
            }
        }
    );

    return { 
        binFillLevel: newBinFillLevel
    };
};

module.exports = Bin;
