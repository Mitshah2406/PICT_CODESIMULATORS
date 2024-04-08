const Truck = require("../models/Truck");
const Bin = require("../models/Bin");
const axios = require("axios");
require("dotenv").config();
// Backend Routes for trucks
exports.getAllTrucks = async function (req, res) {
  try {
    let truck = new Truck();
    const trucks = await truck.getAllTrucks();
    res.status(200).json(trucks);
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in getting truck info" });
  }
};

exports.getTruckById = async function (req, res) {
  const truckId = req.params.truckId;
  try {
    let truck = new Truck();
    const truckInfo = await truck.getTruckById(truckId);
    res.status(200).json(truckInfo);
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in fetching truck information" });
  }
};

exports.addWaste = async function (req, res) {
  const truckId = req.params.truckId;
  const wasteAmount = req.body.wasteAmount;
  try {
    let truck = new Truck();
    const updatedFillLevelInfo = await truck.addWaste(truckId, wasteAmount);
    res.status(200).json(updatedFillLevelInfo);
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in adding waste to the truck" });
  }
};

exports.collectBin = async function (req, res) {
  const truckId = req.params.truckId;
  const binId = req.body.binId;
  try {
    let truck = new Truck();
    await truck.collectBin(truckId, binId);
    let bin = new Bin();
    await bin.collectWaste(binId);
    res.status(200).json({ message: "Bin collected successfully" });
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in collecting bin" });
  }
};

exports.pendingBins = async function (req, res) {
  const truckId = req.params.truckId;
  try {
    let truck = new Truck();
    const pendingBinIds = await truck.pendingBins(truckId);
    res.status(200).json(pendingBinIds);
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in fetching pending bins" });
  }
};

exports.resetBinsCollectedStatus = async function (req, res) {
  const truckId = req.params.truckId;
  try {
    let truck = new Truck();
    await truck.resetBinsCollectedStatus(truckId);
    res
      .status(200)
      .json({ message: "Bins collected status reset successfully" });
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in resetting bins collected status" });
  }
};

exports.getPendingBinsWithLocations = async function (req, res) {
  const truckId = req.params.truckId;
  try {
    let truck = new Truck();
    const pendingBinsWithLocations = await truck.getPendingBinsWithLocations(
      truckId
    );
    res.status(200).json(pendingBinsWithLocations);
  } catch (err) {
    console.log(err);
    res
      .status(400)
      .json({ error: "Error in fetching pending bins with locations" });
  }
};
exports.getRoutesJson = async function (req, res) {
  try {
    let bin = new Bin();
    let binData = await bin.getAllBins();
    let dataa = await axios.post(
      `${process.env.DJANGO_SERVER}/getRouteData`,
      binData
    );

    res.status(200).json(dataa.data);
  } catch (error) {
    console.log(error);
  }
};

exports.getRoutes = async function () {
  try {
    let bin = new Bin();
    let binData = await bin.getAllBins();
    let dataa = await axios.post(
      `${process.env.DJANGO_SERVER}/getRouteData`,
      binData
    );

    // console.log(dataa.data);
    return dataa.data;
  } catch (error) {
    console.log(error);
  }
};

exports.viewMap = async function (req, res) {
  try {
    const url = 'https://graph.facebook.com/v18.0/144528362069356/messages';
    const accessToken = '<YOUR_WHATSAPP_TOKEN'; // Replace with your actual Facebook access token

    const data = {
      messaging_product: 'whatsapp',
      to: '919653288604',
      type: 'text',
      text: {
        body: `Hi Mit, The Garbage Pickup Truck 🚛 has departed from the Garbage Collection Center. It will reach your location in *20 minutes*. Please keep your garbage bin  🗑️ ready for collection. \nThank you!`,

      },
    };

    const headers = {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    };

    axios.post(url, data, { headers })
      .then(response => {
        console.log(response.data);
      })
      .catch(error => {
        console.error(error.response.data);
      });

    res.render("RouteOptimization/map", { authority: req.session.authority });
  } catch (error) {
    console.log(error);
  }
};

exports.getSingleRoute = async function (req, res) {
  try {
    res.render("RouteOptimization/singleRouteMap", {
      authority: req.session.authority,
    });
  } catch (error) {
    console.log(error);
  }
};
