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
exports.getUserById = async (req, res) => {
  try {
    const { userId } = req.body;
    let user = new User();
    let response = await user.getUserById(userId);

    return res.status(200).json(response);
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

    console.log(response);

    if (response.message) {
      return res
        .status(200)
        .json({ result: response.message, imagePath: response.userImage });
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: "Internal Sever Error" });
  }
};

exports.getCountOfUserRewards = async (req, res) => {
  try {
    let user = new User();
    let userId = req.body.userId;

    let count = await user.getCountOfUserRewards(userId);
    res.status(200).json({ result: count });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
exports.getAllUserImages = async (req, res) => {
  try {
    let user = new User();
    const userImages = await user.getAllUserImages();
    if (userImages.length === 0) {
      return res.status(404).json({ error: "No user images found" });
    }
    return res.status(200).json({ userImages });
  } catch (error) {
    console.error("Error getting user images:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getCompletedTaskOfUsers = async (req, res) => {
  try {
    const { userId } = req.body;
    let user = new User();

    let data = await user.getCompletedTaskOfUsers(userId);
    return res.status(200).json({ result: data });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
