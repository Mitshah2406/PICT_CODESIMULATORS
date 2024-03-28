const ItemListing = require("../models/ItemListing");
const path = require("path");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const genAI = new GoogleGenerativeAI("AIzaSyCH12f11jfOO7_E3GJnwVXzQb8hbiXTHlU");
let fs = require('fs')
function fileToGenerativePart(path, mimeType) {
  return {
    inlineData: {
      data: Buffer.from(fs.readFileSync(path)).toString("base64"),
      mimeType,
    },
  };
}
exports.addItem = async (req, res) => {
  try {
    // We need to hit the GEN AI API to get the price estimation based on images
    console.log(req.body);

    // Storing Item Images
    let multipleNames = [];
    if (req.files) {
      if (req.files.images) {
        console.log(req.files);
        if (Array.isArray(req.files.images)) {
          let files = req.files.images;
          // console.log(files);
          const promises = files.map((file) => {
            const fileName = new Date().getTime().toString() + "-" + file.name;
            const savePath = path.join(
              __dirname,
              "../public/",
              "items",
              fileName
            );
            multipleNames.push(fileName);
            return file.mv(savePath);
          });
          await Promise.all(promises);
          req.body.images = multipleNames;
        } else if (!Array.isArray(req.files)) {
          let file = req.files.images;
          const fileName = new Date().getTime().toString() + "-" + file.name;
          const savePath = path.join(
            __dirname,
            "../public/",
            "items",
            fileName
          );
          await file.mv(savePath);
          req.body.images = fileName;
        }
      }
    }

    const item = new ItemListing(req.body);
    let data = await item.addItem();

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getItemById = async (req, res) => {
  try {
    const { itemId } = req.body;

    const item = new ItemListing();
    let data = await item.getItemById(itemId);

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getAllItems = async (req, res) => {
  try {
    const item = new ItemListing();
    let data = await item.getAllItems();

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getAllItemsPostedByUser = async (req, res) => {
  try {
    const { userId } = req.body;

    const item = new ItemListing();
    let data = await item.getAllItemsPostedByUser(userId);

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getItemCountPostedByUser = async (req, res) => {
  try {
    const { userId } = req.body;

    const item = new ItemListing();
    let count = await item.getItemCountPostedByUser(userId);

    return res.status(200).json({ count });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.searchItemByTitle = async (req, res) => {
  try {
    const { title } = req.body;

    const item = new ItemListing();
    let data = await item.searchItemByTitle(title);

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.filterByCategory = async (req, res) => {
  try {
    const { category } = req.body;

    const item = new ItemListing();
    let data = await item.filterByCategory(category);

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.filterByLocation = async (req, res) => {
  try {
    const { city } = req.body;

    const item = new ItemListing();
    let data = await item.filterByLocation(city);

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.addItemToFav = async (req, res) => {
  try {
    const { userId, itemId } = req.body;

    const item = new ItemListing();
    let data = await item.addItemToFav(userId, itemId);

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.removeItemFromFav = async (req, res) => {
  try {
    const { userId, itemId } = req.body;

    const item = new ItemListing();
    let data = await item.removeItemFromFav(userId, itemId);

    return res.status(200).json({ data });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.checkIfItemAlreadyExist = async (req, res) => {
  try {
    const { userId, itemId } = req.body;

    const item = new ItemListing();
    let isExist = await item.checkIfItemAlreadyExist(userId, itemId);

    return res.status(200).json({ isExist });
  } catch (e) {
    console.log(e);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.predictItemPrice = async (req,res)=>{
  try{

    const itemAttachment = req.files.itemAttachment;
    // console.log(logoFile.name);
    const fileName1 =
    new Date().getTime().toString() + "-" + itemAttachment.name;
    const savePath1 = path.join(
      __dirname,
      "../public/",
      "itemAttachments",
      fileName1
      );
      await itemAttachment.mv(savePath1);
      req.body.itemAttachment = fileName1;
      const model = genAI.getGenerativeModel({ model: "gemini-pro-vision" });
      
      const prompt = "predict the second hand used price of this item give me one word answer as a number in rupees or dollars:";
      
      const imageParts = [
        fileToGenerativePart(savePath1, "image/png"), 
      ];
      
      const result = await model.generateContent([prompt, ...imageParts]);
      const response = await result.response;
      const text = response.text().toLowerCase(); 
      console.log("Validation response:", text);
      res.status(200).json({ result: text });
    }
    catch (error) {
      console.log(error);
      res.status(500).json({ error: "Internal Server Error" });
    }
}
