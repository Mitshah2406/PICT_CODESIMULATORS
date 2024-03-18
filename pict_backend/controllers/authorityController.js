const Authority = require('../models/Authority')


// Backend Controller

// Authority login
exports.login = async (req, res) => {
  try {
      const { authorityEmail, authorityPassword } = req.body;
      let authority = new Authority();
      let response = await authority.login(authorityEmail, authorityPassword);
      
      if (response === "Invalid Credentials") {
          req.flash('error', 'Invalid credentials. Please try again.');
          return res.redirect('/authority/login-page'); // Redirect back to the sign-in page
      }

      req.session.authority = { authorityEmail: response.authorityEmail };
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
exports.homePage = function (req,res){
  if(req.session.authority){
    res.render('home')
  }
  else{
    res.redirect('/authority/login-page')
  }
}
