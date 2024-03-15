const router = require("express").Router();
const accountController = require("../controllers/accountController");
const userController = require("../controllers/userController");
const recyclerController = require("../controllers/recyclerController");
const organizerController = require("../controllers/organizerController");
const eventController = require("../controllers/eventController");

// Create a new account, and segregating based on the roles
router.post("/account/signUp", accountController.signUp);

// User can signIn with email and password, no need to take role
router.post("/account/signIn", accountController.signIn);

// Atharva's API
router.post("/user/getUserByEmail", userController.getUserByEmail);
router.post(
  "/recycler/getRecyclerByEmail",
  recyclerController.getRecyclerByEmail
);
router.post(
  "/organizer/getOrganizerByEmail",
  organizerController.getOrganizerByEmail
);

// Event's Routes (WebApp Side)
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
  "/getUserEventParticipationCountById",
  eventController.getUserEventParticipationCountById
);

// To check whether user has already registered or not based on userId. If already, return true and show QR scanner on app
router.post(
  "/checkIfAlreadyRegistered",
  eventController.checkIfAlreadyRegistered
);

// ! Pending API's
// Based on userId, get all the certificates of the user of any events and display in the app
// Add some fields and one array of volunteers,
// Volunteers module and their api's
// Certificate generation (pending volunteer)

module.exports = router;
