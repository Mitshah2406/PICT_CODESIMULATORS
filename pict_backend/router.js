const router = require("express").Router();
const accountController = require("./controllers/accountController");
const userController = require("./controllers/userController");
const recyclerController = require("./controllers/recyclerController");
const organizerController = require("./controllers/organizerController");

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

module.exports = router;
