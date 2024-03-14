const usersCollection = require("../db").db().collection("users");
const ObjectID = require("mongodb").ObjectID;
const bcrypt = require("bcrypt");

let User = function (data) {
  this.data = data;
  this.errors = [];
};

User.prototype.cleanUp = function () {
  this.data = {
    userFirstName: this.data.accountFirstName,
    userLastName: this.data.accountLastName,
    userEmail: this.data.accountEmail,
    userPassword: this.data.accountPassword,
    role: "user",
    // More fields will come later
    eventsRegisteredIn: [],
    certificates: [],
    taskCompleted: Number(0),
    certificateReceived: Number(0),
    reward: Number(0),
    createdDate: new Date(),
  };
};

User.prototype.signUp = async function () {
  this.cleanUp();
  let salt = bcrypt.genSaltSync(10);
  this.data.userPassword = bcrypt.hashSync(this.data.userPassword, salt);
  await usersCollection.insertOne(this.data);
  return "ok";
};

User.prototype.getUserByEmail = async function (email) {
  let data = await usersCollection.findOne({ userEmail: email });

  return data;
};

module.exports = User;
