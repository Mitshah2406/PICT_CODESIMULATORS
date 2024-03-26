const Biowaste = require("../models/Biowaste");
const path = require("path");

// Backend Controllers
// Add resources
exports.addResources = async (req, res) => {
  try {
    let multipleNames = [];
    if (req.files) {
      if (req.files.resources) {
        console.log(req.files);
        if (Array.isArray(req.files.resources)) {
          let files = req.files.resources;
          // console.log(files);
          const promises = files.map((file) => {
            const fileName = new Date().getTime().toString() + "-" + file.name;
            const savePath = path.join(
              __dirname,
              "../public/",
              "biowaste",
              fileName
            );
            multipleNames.push(fileName);
            return file.mv(savePath);
          });
          await Promise.all(promises);
          req.body.resources = multipleNames;
        } else if (!Array.isArray(req.files)) {
          let file = req.files.resources;
          const fileName = new Date().getTime().toString() + "-" + file.name;
          const savePath = path.join(
            __dirname,
            "../public/",
            "biowaste",
            fileName
          );
          await file.mv(savePath);
          req.body.resources = fileName;
        }
      }
    }

    const resources = new Biowaste(req.body);
    let data = await resources.addResources();
    console.log(data);
    req.flash("success", "Data added  successfully");
    return res.redirect("/biowaste/add-resources-page");
  } catch (err) {
    console.log(err);
    req.flash("error", "Server Error");
    return res.redirect("/biowaste/add-resources-page");
  }
};

// Get resources
exports.getBiowasteResources = async (req, res) => {
  try {
    const biowaste = new Biowaste(); // Assuming you need to create an instance
    const resources = await biowaste.getBiowasteResources();
    res.status(200).json({ resources });
  } catch (error) {
    console.error("Error getting biowaste resources:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Frontend Controllers
// Add resources
exports.addResourcesPage = function (req, res) {
  if (req.session.authority) {
    res.render("Biowaste/addResources",{authority:req.session.authority});
  } else {
    res.redirect("/authority/login-page");
  }
};
// Get resources
exports.getResourcesPage = async (req, res) => {
  if (!req.session.authority) {
    return res.redirect("/authority/login-page");
  }

  try {
    const resources = new Biowaste();
    const resourceData = await resources.getBiowasteResources();
    res.render("Biowaste/viewResources", { resources: resourceData,authority: req.session.authority, });
  } catch (error) {
    console.error("Error fetching resources:", error);
    res.status(500).send("Error fetching resources");
  }
};
