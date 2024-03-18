const Account = require("../models/Account");
const Organizer = require("../models/Organizer");
const Recycler = require("../models/Recycler");
const User = require("../models/User");

exports.signUp = async (req, res) => {
  try {
    let account = new Account(req.body);
    let response = await account.signUp();

    if (response == "ok") {
      if (req.body.role === "user") {
        let user = new User(req.body);
        let result = await user.signUp();

        return res.status(200).json({ result });
      } else if (req.body.role === "recycler") {
        let recycler = new Recycler(req.body);
        let result = await recycler.signUp();
        return res.status(200).json({ result });
      }
      // else if (req.body.role === "organizer") {
      //   let organizer = new Organizer(req.body);
      //   await organizer.signUp();
      // }
    } else {
      return res.status(200).json({ result: response });
    }
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Sever Error" });
  }
};

exports.signIn = async (req, res) => {
  try {
    const { accountEmail, accountPassword } = req.body;
    console.log(accountEmail, accountPassword);
    let account = new Account();
    let response = await account.signIn(accountEmail, accountPassword);

    if (response == "Invalid Credentials") {
      return res.status(200).json({ result: response });
    }

    if (response != null && response.role === "user") {
      let user = new User();
      let result = await user.getUserByEmail(response.accountEmail);

      return res.status(200).json({ result });
    } else if (response.role === "organizer") {
      let organizer = new Organizer();
      let result = await organizer.getOrganizerByEmail(response.accountEmail);

      return res.status(200).json({ result });
    } else if (response.role === "recycler") {
      let recycler = new Recycler();
      let result = await recycler.getRecyclerByEmail(response.accountEmail);

      return res.status(200).json({ result });
    }
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Internal Sever Error" });
  }
};

// exports.signIn = async (req, res) => {
//     try {
//         let admin = new Admin(req.body)
//         admin.login().then(function(result) {
//             req.session.user = {username: admin.data.adminUsername, _id: admin.data._id, role: "admin"}
//             req.session.save(function() {
//                 res.redirect('/home')
//             })
//         }).catch(function(e) {
//             req.flash('errors', e)
//             req.session.save(function() {
//                 res.redirect('/signIn')
//             })
//         })
//     } catch (e) {
//         console.log(e);
//     }
// }

// // exports.home = async (req, res)=>{
// //     try {
// //         res.render('home')
// //     } catch (e) {
// //         console.log(e);
// //     }
// // }

// exports.logout = async (req, res)=>{
//     try {
//         req.session.destroy(()=>{
//             res.redirect('/signIn')
//         })
//     } catch (e) {
//         console.log(e);
//     }
// }
