const depotCollection = require("../db").db().collection("depot")
const ObjectID = require("mongodb").ObjectID;

let Depot = function(data){
    this.data = data;
    this.errors = [];
}

Depot.prototype.cleanUp = function (){
    this.data={
        depotName: this.data.depotName,
        depotLocation: {
            lat: this.data.lat,
            lon: this.data.lon,
            fotmattedAddress:this.data.formattedAddress
          },
        capacity: this.data.capacity,
        createdDate: new Date(),
    }
}
Depot.prototype.reverseGeocode = async function(lat, lon) {
    const apiKey = 'AIzaSyBw7fIXJz5sA9IEcczMJ9FIzK91jvFIsno';
    const apiUrl = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lon}
&location_type=ROOFTOP&result_type=street_address&key=${apiKey}`
    const response = await axios.get(apiUrl);
    console.log(response)

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
Depot.prototype.getAllDepots = async function(){
    const depots = await depotCollection.find()
    return depots
}
Depot.prototype.addDepot=async function (){
    let formattedAddress = await this.reverseGeocode(this.data.depotLocation.lat, this.data.depotLocation.lon);
        this.data.depotLocation = {
            lat: this.data.depotLocation.lat,
            lon: this.data.depotLocation.lon,
            formattedAddress: formattedAddress
        };
    this.cleanUp();
    let depot = await depotCollection.insertOne(this.data);
    return{
        id: depot.insertedId,
        status: "ok"
    }
}
Depot.prototype.getDepotLocationById=async function (depotId){
    let depot = await depotCollection.findOne({ _id: new ObjectID(depotId) });
    const depotLocation = depot.depotLocation
      return depotLocation;
  }
Depot.prototype.getDepotCapacityById=async function (depotId){
    let depot = await depotCollection.findOne({ _id: new ObjectID(depotId) });
    const depotCapacity = depot.depotCapacity
      return depotCapacity;
  }