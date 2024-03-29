const e = require("connect-flash");
const { GoogleGenerativeAI } = require("@google/generative-ai");
let Report = require("../models/Report");
let User = require("../models/User");
let path = require("path");
let moment = require("moment");
const genAI = new GoogleGenerativeAI("AIzaSyCH12f11jfOO7_E3GJnwVXzQb8hbiXTHlU");
let fs = require("fs");
function fileToGenerativePart(path, mimeType) {
  return {
    inlineData: {
      data: Buffer.from(fs.readFileSync(path)).toString("base64"),
      mimeType,
    },
  };
}
exports.addReport = async (req, res) => {
  try {
    // console.log(req.body);

    if (req.files.reportAttachment) {
      const reportAttachment = req.files.reportAttachment;
      // console.log(logoFile.name);
      const fileName1 =
        new Date().getTime().toString() + "-" + reportAttachment.name;
      const savePath1 = path.join(
        __dirname,
        "../public/",
        "reportAttachments",
        fileName1
      );
      await reportAttachment.mv(savePath1);
      req.body.reportAttachment = fileName1;

      // For text-and-image input (multimodal), use the gemini-pro-vision model
      const model = genAI.getGenerativeModel({ model: "gemini-pro-vision" });
      // model.safetySettings(
      //   Collections.singletonList(
      //     SafetySetting.newBuilder()
      //       .setCategory(HarmCategory.HARM_CATEGORY_YOUR_CATEGORY)
      //       .setThreshold(SafetySetting.HarmBlockThreshold.BLOCK_NONE)
      //       .build()
      //   )
      // );
      // const prompt = "Is this an unhygenic dumpsite? reply it in a yes or no";
      const prompt =
        "is this something which should be put in a dustbin? reply it in a yes or no";

      const imageParts = [fileToGenerativePart(savePath1, "image/png")];

      const result = await model.generateContent([prompt, ...imageParts]);
      const response = await result.response;
      // console.log(text);

      const text = response.text().toLowerCase().trim(); // Convert text to lowercase for comparison
      console.log("Validation response:", text);
      console.log(text);

      // Check the validation response
      if (text == "yes") {
        let user = new User();
        let userData = await user.getUserById(req.body.uploaderId);
        req.body.uploaderEmail = userData.userEmail;
        req.body.uploaderName =
          userData.userFirstName + " " + userData.userLastName;
        let data = req.body;
        console.log("Report Data");
        console.log(data);
        let report = new Report(data);
        let response = await report.addReport();
        res.status(200).json({ result: response });
      } else {
        let user = new User();
        let userData = await user.getUserById(req.body.uploaderId);
        req.body.uploaderEmail = userData.userEmail;
        req.body.uploaderName =
          userData.userFirstName + " " + userData.userLastName;
        req.body.reportStatus = "rejected";
        req.body.message = "rejected by ml";
        let report = new Report(req.body);
        let response = await report.addReport();
        res.status(200).json({ result: response });
      }
    } else {
      res.status(400).json({ error: "No report attachment provided" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
exports.getAllReports = async (req, res) => {
  try {
    let report = new Report();
    let reports = await report.getAllReports();
    res.status(200).json(reports);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getReportById = async (req, res) => {
  try {
    let reportId = req.params.reportId;
    let report = new Report();
    let response = await report.getReportById(reportId);
    res.status(200).json(response);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.changeReportStatus = async (req, res) => {
  try {
    let { reportId, reportStatus } = req.body;
    let report = new Report();
    if (reportStatus === "resolved") {
      let reportData = await report.getReportById(reportId);
      let user = new User();
      let userData = await user.getUserById(reportData.uploaderId);
      console.log(userData.reward, "dtfgvhbj");
      userData.reward += 10;
      await user.updatePoints(userData._id, userData.reward);
      response = await report.changeReportStatus(reportId, reportStatus);
    } else {
      if (reportStatus === "rejected") {
        req.body.message = "rejected by Authority";
      }
      response = await report.changeReportStatus(reportId, reportStatus);
    }

    res.status(200).json(response);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getReportsByStatus = async (req, res) => {
  try {
    let report = new Report();
    let reportStatus = req.params.reportStatus;
    let fetchedReports = await report.getReportsByStatus(reportStatus);
    res.status(200).json(fetchedReports);
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getAllUserReports = async (req, res) => {
  try {
    let report = new Report();
    let userId = req.body.userId;
    let filter = req.body.filter;
    console.log("Data");
    console.log(userId, filter);

    let reports = await report.getAllUserReports(userId, filter);
    res.status(200).json({ result: reports });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getAllUserPendingReports = async (req, res) => {
  try {
    let report = new Report();
    let userId = req.body.userId;

    let reports = await report.getAllUserPendingReports(userId);
    res.status(200).json({ result: reports });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getAllUserResolvedReports = async (req, res) => {
  try {
    let report = new Report();
    let userId = req.body.userId;

    let reports = await report.getAllUserResolvedReports(userId);
    res.status(200).json({ result: reports });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getAllUserRejectedReports = async (req, res) => {
  try {
    let report = new Report();
    let userId = req.body.userId;

    let reports = await report.getAllUserRejectedReports(userId);
    res.status(200).json({ result: reports });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

exports.getCountOfAllUserReports = async (req, res) => {
  try {
    let report = new Report();
    let userId = req.body.userId;

    let count = await report.getCountOfAllUserReports(userId);
    res.status(200).json({ result: count });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
exports.searchReport = async (req, res) => {
  try {
    let report = new Report();

    let result = await report.searchReport(req.body.searchTerm);
    res.status(200).json({ result: result });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Frontend Controller
exports.viewAllReportsPage = async (req, res) => {
  try {
    const report = new Report();
    const reportsData = await report.getAllReports();
    res.render("Reports/viewReports", {
      reports: reportsData,
      authority: req.session.authority,
    });
  } catch (error) {
    console.error("Error fetching resources:", error);
    res.status(500).send("Error fetching resources");
  }
};
exports.viewReportsByIdPage = async (req, res) => {
  try {
    const reportId = req.params.reportId;
    const report = await new Report().getReportById(reportId);
    res.render("Reports/viewIndivitualReports", {
      result: report,
      authority: req.session.authority,
      moment: moment,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching indivitual event");
  }
};

exports.viewAllRejetedReportsPage = async (req, res) => {
  try {
    const report = await new Report().getReportsByStatus("rejected");
    res.render("Reports/viewRejectedReports", {
      rejectedReports: report,
      authority: req.session.authority,
      moment: moment,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching indivitual event");
  }
};
exports.viewAllResolvedReportsPage = async (req, res) => {
  try {
    const report = await new Report().getReportsByStatus("resolved");
    res.render("Reports/viewResolvedReports", {
      resolvedReports: report,
      authority: req.session.authority,
      moment: moment,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching indivitual event");
  }
};
exports.viewAllPendingReportsPage = async (req, res) => {
  try {
    const report = await new Report().getReportsByStatus("pending");
    res.render("Reports/viewPendingReports", {
      pendingReports: report,
      authority: req.session.authority,
      moment: moment,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching indivitual event");
  }
};
exports.rejectReport = async (req, res) => {
  const reportId = req.params.reportId;
  try {
    const status = await new Report().changeReportStatus(reportId, "rejected");
    if (status == "updated") {
      req.flash("success", "Report status changed  to rejected successfully!");
      return res.redirect("/reports/view-pending-reports");
    } else {
      req.flash("error", "Server Error");
      return res.redirect("/reports/view-pending-reports");
    }
  } catch (err) {
    console.log(err);
    req.flash("error", "Server Error");
    return res.redirect("/reports/view-pending-reports");
  }
};
exports.resolveReport = async (req, res) => {
  console.log("Yahoo");
  const reportId = req.params.reportId;
  try {
    let report = new Report();
    let reportData = await report.getReportById(reportId);
    let user = new User();
    let userData = await user.getUserById(reportData.uploaderId);
    console.log(userData.reward, "dtfgvhbj");
    userData.reward += 10;
    await user.updatePoints(userData._id, userData.reward);
    const status = await report.changeReportStatus(reportId, "resolved");
    if (status == "updated") {
      req.flash("success", "Report status changed  to resolved successfully!");
      return res.redirect("/reports/view-pending-reports");
    } else {
      req.flash("error", "Server Error");
      return res.redirect("/reports/view-pending-reports");
    }
  } catch (err) {
    console.log(err);
    req.flash("error", "Server Error");
    return res.redirect("/reports/view-pending-reports");
  }
};
