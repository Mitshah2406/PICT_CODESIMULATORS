const e = require("connect-flash");
let Report = require("../models/Report");
let User = require("../models/User");
let path = require("path");
let moment= require('moment')
exports.addReport = async (req, res) => {
  try {
    console.log(req.body);

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
    }
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
    console.log(req.body);
    let report = new Report();
    let response = await report.changeReportStatus(reportId, reportStatus);
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
exports.viewAllReportsPage = async (req,res)=>{
  try {
    const report = new Report();
    const reportsData = await report.getAllReports();
    res.render("Reports/viewReports", { reports: reportsData,authority: req.session.authority, });
  } catch (error) {
    console.error("Error fetching resources:", error);
    res.status(500).send("Error fetching resources");
  }
}
exports.viewReportsByIdPage=async(req,res)=>{
  try{
    const reportId= req.params.reportId;
    const report = await new Report().getReportById(reportId);
    res.render('Reports/viewIndivitualReports',{result:report,authority: req.session.authority,moment:moment})
  }
  catch(err){
    console.error(err);
    res.status(500).send("Error fetching indivitual event")
  }
}

exports.viewAllRejetedReportsPage=async(req,res)=>{
  try{
    const report = await new Report().getReportsByStatus("rejected");
    res.render('Reports/viewRejectedReports',{rejectedReports:report,authority: req.session.authority,moment:moment})
  }
  catch(err){
    console.error(err);
    res.status(500).send("Error fetching indivitual event")
  }
}
exports.viewAllResolvedReportsPage=async(req,res)=>{
  try{
    const report = await new Report().getReportsByStatus("resolved");
    res.render('Reports/viewResolvedReports',{resolvedReports:report,authority: req.session.authority,moment:moment})
  }
  catch(err){
    console.error(err);
    res.status(500).send("Error fetching indivitual event")
  }
}
exports.viewAllPendingReportsPage=async(req,res)=>{
  try{
    const report = await new Report().getReportsByStatus("pending");
    res.render('Reports/viewPendingReports',{pendingReports:report,authority: req.session.authority,moment:moment})
  }
  catch(err){
    console.error(err);
    res.status(500).send("Error fetching indivitual event")
  }
}
exports.rejectReport=async(req,res)=>{
  const reportId= req.params.reportId;
  try{
    const status = await  new Report().changeReportStatus(reportId,"rejected")
    if(status == "updated"){
      req.flash("success", "Report status changed  to rejected successfully!");
      return res.redirect('/reports/view-pending-reports')
    }
    else{
      req.flash("error", "Server Error");
      return res.redirect("/reports/view-pending-reports");
    }
  }
  catch (err) {
    console.log(err);
    req.flash("error", "Server Error");
    return res.redirect("/reports/view-pending-reports");
  }
}
exports.resolveReport=async(req,res)=>{
  const reportId= req.params.reportId;
  try{
    const status = await  new Report().changeReportStatus(reportId,"resolved")
    if(status == "updated"){
      req.flash("success", "Report status changed  to resolved successfully!");
      return res.redirect('/reports/view-pending-reports')
    }
    else{
      req.flash("error", "Server Error");
      return res.redirect("/reports/view-pending-reports");
    }
  }
  catch (err) {
    console.log(err);
    req.flash("error", "Server Error");
    return res.redirect("/reports/view-pending-reports");
  }
}
