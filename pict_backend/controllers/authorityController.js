const Authority = require('../models/Authority')
const Event = require("../models/Event");
var moment = require('moment');
// Backend Controller

// Authority login
exports.login = async (req, res) => {
  try {
      const { authorityName, authorityEmail, authorityPassword } = req.body;
      let authority = new Authority();
      let response = await authority.login(authorityEmail, authorityPassword);
      
      if (response === "Invalid Credentials") {
          req.flash('error', 'Invalid credentials. Please try again.');
          return res.redirect('/authority/login-page'); // Redirect back to the sign-in page
      }

      req.session.authority = { authorityEmail: response.authorityEmail, authorityName:response.authorityName };
      req.session.save(function () {
          res.redirect('/');
      });
  } catch (err) {
      console.log(err);
      return res.status(500).json({ message: "Internal Server Error" });
  }
};
// Authority Logout
exports.logout = (req, res) => {
  // Destroy the session
  req.session.destroy((err) => {
      if (err) {
          console.log(err);
          return res.status(500).json({ message: "Internal Server Error" });
      }
      // Redirect the user to the login page or any desired page after logout
      res.redirect('/authority/login-page');
  });
};


// Frontend Controller
// login page
exports.loginPage = function (req,res){
  const errors = req.flash('error');
  const success = req.flash('success');
  res.render('Authorization/signIn', { errors, success });
}
// Home page
exports.homePage = async (req,res)=>{
  console.log(req.session.authority)
  try{
    const upcomingEvents = await new Event().getAllUpcomingEvents();
    const top3UpcomingEvents = upcomingEvents.slice(0, 3);
    const ongoingEvents = await new Event().getAllOngoingEvents();
    const top3OngoingEvents = ongoingEvents.slice(0, 3);
    const totalEventsCounts = await new Event().getTotalEventsCount()
    const upcomingEventsCount =  await new Event().getAllUpcomingEventsCount()
    const ongoingEventsCount =await new Event().getAllOngoingEventsCount()
    const completedEventsCount =await new Event().getAllCompletedEventsCount()
    const eventCount = {
      totalEventsCounts,
      ongoingEventsCount,
      upcomingEventsCount,
      completedEventsCount
    }
    console.log(eventCount)
    res.render('home',{authority:req.session.authority,upcomingEvents: top3UpcomingEvents,ongoingEvents:top3OngoingEvents,eventCount,moment:moment})
  }catch(err){
    console.error(err);
    res.status(500).send("Error fetching events");
  }
  
}
