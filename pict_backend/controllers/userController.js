let User = require("../models/User");
const path = require("path");

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

exports.editProfile = async (req, res) => {
  try {
    if (req.files) {
      if (req.files.userImage) {
        const image = req.files.userImage;
        // console.log(logoFile.name);
        const fileName1 = new Date().getTime().toString() + "-" + image.name;
        const savePath1 = path.join(
          __dirname,
          "../public/",
          "userImages",
          fileName1
        );
        await image.mv(savePath1);
        req.body.userImage = fileName1;
      }
    }

    let user = new User();
    let response = await user.editProfile(req.body);

    return res
      .status(200)
      .json({ result: response, imagePath: req.body.userImage });
  } catch (error) {
    console.log(e);
    return res.status(500).json({ message: "Internal Sever Error" });
  }
};
