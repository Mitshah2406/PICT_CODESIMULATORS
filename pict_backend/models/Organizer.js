const organizersCollection = require("../db").db().collection("organizers");
const ObjectID = require("mongodb").ObjectID;
const bcrypt = require("bcrypt");

let Organizer = function (data) {
  this.data = data;
  this.errors = [];
};

Organizer.prototype.cleanUp = function () {
  this.data = {
    organizerFirstName: this.data.accountFirstName,
    organizerLastName: this.data.accountLastName,
    organizerEmail: this.data.accountEmail,
    organizerMobileNo: this.data.accountMobileNo,
    organizerPassword: this.data.accountPassword,
    role: "organizer",
    // More fields will come later
    createdDate: new Date(),
  };
};

Organizer.prototype.signUp = async function () {
  this.cleanUp();
  let salt = bcrypt.genSaltSync(10);
  this.data.organizerPassword = bcrypt.hashSync(
    this.data.organizerPassword,
    salt
  );
  await organizersCollection.insertOne(this.data);
  return "ok";
};

Organizer.prototype.getOrganizerByEmail = async function (organizerEmail) {
  let data = await organizersCollection.findOne({
    organizerEmail: organizerEmail,
  });

  return {
    message: "ok",
    data: data,
  };
};

module.exports = Organizer;
