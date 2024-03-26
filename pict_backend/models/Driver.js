const driverCollection = require("../db").db().collection("drivers");
const ObjectID = require("mongodb").ObjectID;


let Driver = function (data) {
    this.data = data;
    this.errors = [];
};

Driver.prototype.cleanUp = function () {
    this.data = {
      driverEmail: this.data.driverEmail,
      driverPassword: this.data.driverPassword,
      truckId: ObjectID(this.data.truckId),
  
      // More fields will be added later
      createdDate: new Date(),
    };
};
Driver.prototype.login = async function(driverEmail,driverPassword){
    let driver =  await driverCollection.findOne({
        driverEmail:driverEmail
    });
     if (!driver) {
      return "Invalid Credentials";
     }
     let  validPass=await bcrypt.compareSync(driverPassword,driver.driverPassword);
     if(!validPass){
      return "Invalid Credentials"
     }
     return driver; 
  }
Driver.prototype.getTruckId=async function(driverId){
    let driver = await driverCollection.findOne({ _id: new ObjectID(driverId) });
    const truckId = driver.truckId
    return truckId
}
Driver.prototype.setTruckId=async function(driverId,truckId){
    const updatedDriver = await driverCollection.updateOne(
        { _id: new ObjectId(driverId) },
        {
            $set: {
                truckId:truckId
            }
        }
    );
    return updatedDriver;
}
  
