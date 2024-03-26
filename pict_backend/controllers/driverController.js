const Driver = require("../models/Driver")

exports.login = async (req, res) => {
    try {
        const { driverName, driverEmail, driverPassword } = req.body;
        let driver = new Driver();
        let response = await driver.login(driverEmail, driverPassword);
        
        if (response === "Invalid Credentials") {
            req.flash('error', 'Invalid credentials. Please try again.');
            return res.redirect('/driver/login-page'); // Redirect back to the sign-in page
        }
  
        req.session.driver = { driverEmail: response.driverEmail, driverName:response.driverName };
        req.session.save(function () {
            res.redirect('/');
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ message: "Internal Server Error" });
    }
  };
  exports.getTruckId = async(req,res)=>{
    try {
        let driver = new Driver();
        let truckId = await driver.getTruckId(req.params.driverId);
        res.status(200).json({ truckId });
      } catch (e) {
        return res.status(500).json({ message: "Internal Server Error" });
      }
  }
  exports.setTruckId = async(req,res)=>{
    try {
        let driver = new Driver();
        const {truckId} = req.body;
        let result = await driver.setTruckId(req.params.driverId, truckId);
        res.status(200).json({ result });
      } catch (e) {
        return res.status(500).json({ message: "Internal Server Error" });
        
      }
  }