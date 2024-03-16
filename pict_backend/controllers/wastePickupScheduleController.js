let WastePickupSchedule = require("../models/WastePickupSchedule");
exports.addWastePickupSchedule = async (req, res) => {
    try {
        let wastePickupSchedule = new WastePickupSchedule(req.body);
        let response = await wastePickupSchedule.addWastePickupSchedule();
        res.status(200).json({ id: response });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error: "Internal Server Error" });
    }
}
