let Recycler = require("../models/Recycler");

exports.getRecyclerByEmail = async (req, res) => {
  try {
    const { email } = req.body;
    let recycler = new Recycler();
    let response = await recycler.getRecyclerByEmail(email);

    return res.status(200).json({ response });
  } catch (e) {
    console.log(e);
    return res.status(500).json({ response });
  }
};
