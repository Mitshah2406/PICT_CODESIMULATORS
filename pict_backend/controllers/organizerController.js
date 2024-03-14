let Organizer = require("../models/Organizer");

exports.getOrganizerByEmail = async (req, res) => {
  try {
    const { email } = req.body;
    let organizer = new Organizer();
    let response = await organizer.getOrganizerByEmail(email);

    return res.status(200).json({ response });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ response });
  }
};
