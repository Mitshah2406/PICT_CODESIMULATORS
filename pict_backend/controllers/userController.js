let User = require("../models/User");

exports.getUserByEmail = async (req, res) => {
  try {
    const { email } = req.body;
    let user = new User();
    let response = await user.getUserByEmail(email);

    return res.status(200).json({ response });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ response });
  }
};
