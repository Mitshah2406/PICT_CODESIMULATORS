const router = require("express").Router();
const accountController = require("../controllers/accountController");
const userController = require("../controllers/userController");
const recyclerController = require("../controllers/recyclerController");
const organizerController = require("../controllers/organizerController");
const eventController = require("../controllers/eventController");
const itemlistingContoller = require("../controllers/itemListingController");
const reportController = require("../controllers/reportController");
const wastePickupScheduleController = require("../controllers/wastePickupScheduleController");
const authorityController = require("../controllers/authorityController");
const biowasteController = require("../controllers/biowasteController");
const binController = require("../controllers/binController");
const depotController = require("../controllers/depotController");
const driverController = require("../controllers/driverController");
const truckController = require("../controllers/truckController");
const taskController = require("../controllers/taskController");
const whatsappController = require("../controllers/whatsappController");
// ? Authentication module

// Check authorization
const requireAuth = (req, res, next) => {
  if (!req.session.authority) {
    return res.redirect("/authority/login-page");
  }

  next();
};

router.get("/user/getAllUserImages", userController.getAllUserImages);

// Create a new account, and segregating based on the roles
router.post("/account/signUp", accountController.signUp);

// User can signIn with email and password, no need to take role
router.post("/account/signIn", accountController.signIn);

// Edit Profile Route
router.post("/editProfile", userController.editProfile);

// ? User API's
router.post(
  "/user/getCountOfUserRewards",
  userController.getCountOfUserRewards
);

// ? Event Management Module

// Atharva's API
router.post("/user/getUserByEmail", userController.getUserByEmail);
router.post("/user/getUserById", userController.getUserById);
router.post(
  "/recycler/getRecyclerByEmail",
  recyclerController.getRecyclerByEmail
);
router.post(
  "/organizer/getOrganizerByEmail",
  organizerController.getOrganizerByEmail
);

// Flutter's API
router.get("/getAllEvents", eventController.getAllEvents);
router.post("/getSingleEventById", eventController.getSingleEventById);
router.get("/getAllUpcomingEvents", eventController.getAllUpcomingEvents);
router.get("/getAllCompletedEvents", eventController.getAllCompletedEvents);
router.get("/getAllOngoingEvents", eventController.getAllOngoingEvents);

// User can register in event, and then the user should be pushed in the registeredParticipants[] array
router.post("/registerEvent", eventController.registerEvent);
// Organizer can mark present, based on the eventId and userId.
router.post("/markPresent", eventController.markPresent);

// Get Count of user who has registered in the events
router.post(
  "/getUserEventRegistrationCountById",
  eventController.getUserEventRegistrationCountById
);

// Get Count of user who is present in the events
router.post(
  "/getUserEventCountById",
  eventController.getUserEventParticipationCountById
);

// Get their registered Events
router.post(
  "/getUserRegisteredEvents",
  eventController.getUserRegisteredEvents
);

// Get their completed as well as they were present in the events.
router.post("/getUserCompletedEvents", eventController.getUserCompletedEvents);

// To check whether user has already registered or not based on userId. If already, return true and show QR scanner on app
router.post(
  "/checkIfAlreadyRegistered",
  eventController.checkIfAlreadyRegistered
);

// Get Ongoing events of the organizer based on the email address.
router.post(
  "/getOngoingEventsByEmail",
  eventController.getOngoingEventsByEmail
);
router.post(
  "/getCompletedEventsByEmail",
  eventController.getCompletedEventsByEmail
);

// ? Reporting Module

//add report for unhygenic place with a attachment
router.post("/report/addReport", reportController.addReport);
//get all reports
router.get("/report/getAllReports", reportController.getAllReports);
// get single report by id
router.get("/report/getReportById/:reportId", reportController.getReportById);
// change report status accordingly to pending(by default), resolved, rejected(if fake report)
router.post("/report/changeReportStatus", reportController.changeReportStatus);
// get reports by status (pending, resolved, rejected)
router.get(
  "/report/getReportsByStatus/:reportStatus",
  reportController.getReportsByStatus
);
// get all users reports
router.post("/report/getAllUserReports", reportController.getAllUserReports);
// get all users pending reports
router.post(
  "/report/getAllUserPendingReports",
  reportController.getAllUserPendingReports
);
router.post(
  "/report/getAllUserResolvedReports",
  reportController.getAllUserResolvedReports
);
router.post(
  "/report/getAllUserRejectedReports",
  reportController.getAllUserRejectedReports
);

router.post(
  "/report/getCountOfAllUserReports",
  reportController.getCountOfAllUserReports
);

router.post("/report/searchReport", reportController.searchReport);

//waste pickup schedule module
router.post(
  "/pickup/addWastePickupSchedule",
  wastePickupScheduleController.addWastePickupSchedule
);

// ---------Routes for govt. authority-----------

//          ---- Backend routes -----

// login route
router.post("/login", authorityController.login);
router.get("/logout", authorityController.logout);
// -- Bio Waste Resources --
// add bio resource
router.post("/biowaste/addResources", biowasteController.addResources);
router.get("/biowaste/getResources", biowasteController.getBiowasteResources);

// Event's Routes
router.post("/addEvent", eventController.addEvent);
router.post("/deleteEventById/:eventId", eventController.deleteEventById);
router.get("/getEvents", eventController.getEvents);
router.get("/getEventById/:eventId", eventController.getEventById);
router.get("/getUpcomingEvents", eventController.getUpcomingEvents);
router.get("/getCompletedEvents", eventController.getCompletedEvents);
router.get("/getOngoingEvents", eventController.getOngoingEvents);
router.get("/getTotalEventsCount", eventController.getTotalEventsCount);
router.get(
  "/getAllUpcomingEventsCount",
  eventController.getAllUpcomingEventsCount
);
router.get(
  "/getAllCompletedEventsCount",
  eventController.getAllCompletedEventsCount
);
router.get(
  "/getAllOngoingEventsCount",
  eventController.getAllOngoingEventsCount
);

// Get latest 3 registered events of users
router.post(
  "/getLatest3UserRegisteredEvents",
  eventController.getLatest3UserRegisteredEvents
);

// Getting upcoming events of this month
router.get(
  "/getUpcomingEventsOfMonth",
  eventController.getUpcomingEventsOfMonth
);

// Get All registered participants in the specific event, which will be shown on the webApp
router.post(
  "/getRegisteredParticipants",
  eventController.getRegisteredParticipants
);

// Get All present participants in the specific event, and there will be the generate certificate button when clicked the certificate will be generated for that user.
router.post("/getPresentParticipants", eventController.getPresentParticipants);

// Certificate generation
router.post("/generateCertificate", eventController.generateCertificate);

// ? BioWaste Module
router.get("/getVideoResources", biowasteController.getVideoResource);
router.get("/getBlogResources", biowasteController.getBlogResources);

//          ------ Frontend  routes ------

// login route
router.get("/authority/login-page", authorityController.loginPage);
// Home page route
router.get("/", requireAuth, authorityController.homePage);
// Bio waste routes
router.get("/biowaste/add-resources-page", biowasteController.addResourcesPage);
router.get("/biowaste/get-resources-page", biowasteController.getResourcesPage);

// Events Routes
router.get("/events/view-all-events", eventController.viewAllEventsPage);
router.get(
  "/events/view-upcoming-events",
  eventController.viewUpcomingEventsPage
);
router.get(
  "/events/view-ongoing-events",
  eventController.viewOngoingEventsPage
);
router.get(
  "/events/view-completed-events",
  eventController.viewCompletedEventsPage
);
router.get(
  "/events/view-event-by-id/:eventId",
  eventController.viewEventsByIdPage
);
router.get("/events/add-events-page", eventController.addEventsPage);

// ? Item Listing Module (Buy & Sell)
router.post("/addItem", itemlistingContoller.addItem);
router.post("/getItemById", itemlistingContoller.getItemById);
router.get("/getAllItems", itemlistingContoller.getAllItems);
router.post(
  "/getAllItemsPostedByUser",
  itemlistingContoller.getAllItemsPostedByUser
);
router.post(
  "/getItemCountPostedByUser",
  itemlistingContoller.getItemCountPostedByUser
);

// Search API by title (You can also check count of items based on search)
router.post("/searchItemByTitle", itemlistingContoller.searchItemByTitle);

// Filters API (You can also check count of items based on filter)
router.post("/filterByCategory", itemlistingContoller.filterByCategory);
router.post("/filterByLocation", itemlistingContoller.filterByLocation);

// Their favorite items
router.post("/addItemToFav", itemlistingContoller.addItemToFav);
router.post("/removeItemFromFav", itemlistingContoller.removeItemFromFav);

// Check if the item is already present in the list or not
router.post(
  "/checkIfItemAlreadyExist",
  itemlistingContoller.checkIfItemAlreadyExist
);

// Predict Item price
router.post("/predictItemPrice", itemlistingContoller.predictItemPrice);

// Reporting Module

//add report for unhygenic place with a attachment
router.post("/report/addReport", reportController.addReport);
//get all reports
router.get("/report/getAllReports", reportController.getAllReports);
// get single report by id
router.get("/report/getReportById/:reportId", reportController.getReportById);
// change report status accordingly to pending(by default), resolved, rejected(if fake report)
router.post("/report/changeReportStatus", reportController.changeReportStatus);
// get reports by status (pending, resolved, rejected)
router.get(
  "/report/getReportsByStatus/:reportStatus",
  reportController.getReportsByStatus
);

//waste pickup schedule module
router.post(
  "/pickup/addWastePickupSchedule",
  wastePickupScheduleController.addWastePickupSchedule
);

// router.post(
//   "/pickup/addWastePickupSchedule",
//   wastePickupScheduleController.addWastePickupSchedule
// );

// ---------Routes for govt. authority-----------

//          ---- Backend routes -----

// login route
router.post("/login", authorityController.login);
router.get("/logout", authorityController.logout);
// -- Bio Waste Resources --
// add bio resource
router.post("/biowaste/addResources", biowasteController.addResources);
router.get("/biowaste/getResources", biowasteController.getBiowasteResources);

// Event's Routes
router.post("/addEvent", eventController.addEvent);
router.post("/deleteEventById/:eventId", eventController.deleteEventById);
router.get("/getEvents", eventController.getEvents);
router.get("/getEventById/:eventId", eventController.getEventById);
router.get("/getUpcomingEvents", eventController.getUpcomingEvents);
router.get("/getCompletedEvents", eventController.getCompletedEvents);
router.get("/getOngoingEvents", eventController.getOngoingEvents);
router.get("/getTotalEventsCount", eventController.getTotalEventsCount);
router.get(
  "/getAllUpcomingEventsCount",
  eventController.getAllUpcomingEventsCount
);
router.get(
  "/getAllCompletedEventsCount",
  eventController.getAllCompletedEventsCount
);
router.get(
  "/getAllOngoingEventsCount",
  eventController.getAllOngoingEventsCount
);

// Get All registered participants in the specific event, which will be shown on the webApp
router.post(
  "/getRegisteredParticipants",
  eventController.getRegisteredParticipants
);

// Get All present participants in the specific event, and there will be the generate certificate button when clicked the certificate will be generated for that user.
router.post("/getPresentParticipants", eventController.getPresentParticipants);

// Certificate generation
router.post("/generateCertificate", eventController.generateCertificate);

//          ------ Frontend  routes ------

// login route
router.get("/authority/login-page", authorityController.loginPage);
// Home page route
router.get("/", requireAuth, authorityController.homePage);
// Bio waste routes
router.get(
  "/biowaste/add-resources-page",
  requireAuth,
  biowasteController.addResourcesPage
);
router.get(
  "/biowaste/get-resources-page",
  requireAuth,
  biowasteController.getResourcesPage
);
// Events Routes
router.get(
  "/events/view-all-events",
  requireAuth,
  eventController.viewAllEventsPage
);
router.get(
  "/events/view-upcoming-events",
  requireAuth,
  eventController.viewUpcomingEventsPage
);
router.get(
  "/events/view-ongoing-events",
  requireAuth,
  eventController.viewOngoingEventsPage
);
router.get(
  "/events/view-completed-events",
  requireAuth,
  eventController.viewCompletedEventsPage
);
router.get(
  "/events/view-event-by-id/:eventId",
  requireAuth,
  eventController.viewEventsByIdPage
);
router.get(
  "/events/add-events-page",
  requireAuth,
  eventController.addEventsPage
);
// Report Routes
router.get(
  "/reports/view-all-reports",
  requireAuth,
  reportController.viewAllReportsPage
);
router.get(
  "/reports/view-report-by-id/:reportId",
  requireAuth,
  reportController.viewReportsByIdPage
);
router.get(
  "/reports/view-rejected-reports",
  requireAuth,
  reportController.viewAllRejetedReportsPage
);
router.get(
  "/reports/view-resolved-reports",
  requireAuth,
  reportController.viewAllResolvedReportsPage
);
router.get(
  "/reports/view-pending-reports",
  requireAuth,
  reportController.viewAllPendingReportsPage
);
router.post(
  "/reports/reject-report/:reportId",
  requireAuth,
  reportController.rejectReport
);
router.post(
  "/reports/resolve-report/:reportId",
  requireAuth,
  reportController.resolveReport
);

// Bin Module
router.get("/bin/getAllBins", binController.getAllBins);
router.post("/bin/addBin", binController.addBin);
router.get("/bin/getBinLocationById/:binId", binController.getBinLocationById);
router.get(
  "/bin/getBinFillLevelById/:binId",
  binController.getBinFillLevelById
);
router.post("/bin/addWaste/:binId", binController.addWaste);
router.get("/bin/collectWaste/:binId", binController.collectWaste);
router.get(
  "/bin/getReverseGeoCodedLocationsOfAllBins",
  binController.getReverseGeoCodedLocationsOfAllBins
);
router.put("/bin/updateBinFillLevel/:binId", binController.updateBinFillLevel);
// Depot Module
router.get("/depot/getAllDepots", depotController.getAllDepots);
router.post("/depot/addDepot", depotController.addDepot);
router.get(
  "/depot/getDepotLocationById/:depotId",
  depotController.getDepotLocationById
);
router.get(
  "/depot/getDepotCapacityById/:depotId",
  depotController.getDepotCapacityById
);
// Driver Module
router.post("/driver/login", driverController.login);
router.get("/driver/getTruckId/:driverId", driverController.getTruckId);
router.post("/driver/setTruckId/:driverId", driverController.setTruckId);
// Truck Module
router.get("/truck/getAllTrucks", truckController.getAllTrucks);
router.get("/truck/getTruckById/:truckId", truckController.getTruckById);
router.post("/truck/addWaste/:truckId", truckController.addWaste);
router.post("/truck/collectBin/:truckId", truckController.collectBin);
router.get("/truck/pendingBins/:truckId", truckController.pendingBins);
router.get(
  "/truck/resetBinsCollectedStatus/:truckId",
  truckController.resetBinsCollectedStatus
);
router.get(
  "/truck/getPendingBinsWithLocations/:truckId",
  truckController.getPendingBinsWithLocations
);

// Task routes

router.get("/task/getAllTasks", taskController.getAllTasks);
router.get("/task/getRandomTask", taskController.getRandomTask);
router.post("/task/addBulkTasks", taskController.addBulkTasks);
router.post("/task/validateTask", taskController.validateTask);
router.post(
  "/task/getCompletedTaskOfUsers",
  userController.getCompletedTaskOfUsers
);

// Whatsapp Bot
router.post("/whatsapp/littered",whatsappController.sendLittered)

//route optimization
router.get("/viewMap", truckController.viewMap);
router.get("/getRoutes", truckController.getRoutesJson);
router.get("/getSingleRoute/:index", truckController.getSingleRoute);
//
// router.get("/map", async (req, res) => {
//   let data = await truckController.getRoutes();
//   res.render("RouteOptimization/map");
// });


//404

router.get("*", (req, res) => {
  res.status(404).send("404: Page not found");
});

module.exports = router;
