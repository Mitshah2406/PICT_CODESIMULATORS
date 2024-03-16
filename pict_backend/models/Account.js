const accountsCollection = require("../db").db().collection("accounts");

const ObjectID = require("mongodb").ObjectID;
const bcrypt = require("bcrypt");

let Account = function (data) {
  this.data = data;
  this.errors = [];
};

Account.prototype.cleanUp = function () {
  this.data = {
    accountFirstName: this.data.accountFirstName,
    accountLastName: this.data.accountLastName,
    accountEmail: this.data.accountEmail,
    accountMobileNo: this.data.accountMobileNo,
    accountPassword: this.data.accountPassword,
    role: this.data.role,
    createdDate: new Date(),
  };
};

Account.prototype.signUp = async function () {
  // We need to check if the account already exists, If account already exists, we will send an error message
  this.cleanUp();
  if (!this.errors.length) {
    let isExist = await accountsCollection.findOne({
      accountEmail: this.data.accountEmail,
    });

    if (isExist) {
      return "exist";
    }

    let salt = bcrypt.genSaltSync(10);
    this.data.accountPassword = bcrypt.hashSync(
      this.data.accountPassword,
      salt
    );
    let data = await accountsCollection.insertOne(this.data);

    if (data.acknowledged) {
      return "ok";
    }

    return "fail";
  }
};

Account.prototype.signIn = async function (accountEmail, accountPassword) {
  // Check if the account exists or not
  let account = await accountsCollection.findOne({
    accountEmail: accountEmail,
  });

  if (!account) {
    return "Invalid Credentials";
  }

  let checkPassword = bcrypt.compareSync(
    accountPassword,
    account.accountPassword
  );

  if (!checkPassword) {
    return "Invalid Credentials";
  }

  return account;
};

// Admin.prototype.login = function () {
//   return new Promise((resolve, reject) => {
//     this.cleanUp();
//     adminsCollection
//       .findOne({ adminEmail: this.data.adminEmail })
//       .then((attemptedUser) => {
//         if (
//           attemptedUser &&
//           bcrypt.compareSync(
//             this.data.adminPassword,
//             attemptedUser.adminPassword
//           )
//         ) {
//           this.data = attemptedUser;
//           resolve("Congrats!");
//         } else {
//           reject("Invalid username / password.");
//         }
//       })
//       .catch(function () {
//         reject("Please try again later.");
//       });
//   });
// };

module.exports = Account;
