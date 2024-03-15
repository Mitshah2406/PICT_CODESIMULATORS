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

// Flutter's API
router.get("/getAllEvents", eventController.getAllEvents);
router.post("/getSingleEventById", eventController.getSingleEventById);
router.get("/getAllUpcomingEvents", eventController.getAllUpcomingEvents);
router.get("/getAllCompletedEvents", eventController.getAllCompletedEvents);
router.get("/getAllOngoingEvents", eventController.getAllOngoingEvents);

// User can register in event, and then the user should be pushed in the registeredParticipants[] array
router.post("/registerEvent", eventController.registerEvent);

// Get Count of user who has registered in the events
router.post(
  "/getUserEventRegistrationCountById",
  eventController.getUserEventRegistrationCountById
);

// Pending API's
// If they registered, and they are present in the event, isCertificate field in the user will be true as well as user will be added in the presentParticipants[] array
// Get Count of user who is present in the events
// Certificate generation (Different for volunteer and users)

module.exports = router;
