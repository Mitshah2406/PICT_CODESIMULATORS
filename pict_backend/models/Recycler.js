const recyclersCollection = require("../db").db().collection("recyclers");
const ObjectID = require("mongodb").ObjectID;
const bcrypt = require("bcrypt");

let Recycler = function (data) {
  this.data = data;
  this.errors = [];
};

Recycler.prototype.cleanUp = function () {
  this.data = {
    recyclerFirstName: this.data.accountFirstName,
    recyclerLastName: this.data.accountLastName,
    recyclerEmail: this.data.accountEmail,
    recyclerPassword: this.data.accountPassword,
    role: "recycler",
    // More fields will come later
    createdDate: new Date(),
  };
};

Recycler.prototype.signUp = async function () {
  this.cleanUp();
  let salt = bcrypt.genSaltSync(10);
  this.data.recyclerPassword = bcrypt.hashSync(
    this.data.recyclerPassword,
    salt
  );
  await recyclersCollection.insertOne(this.data);
  return "ok";
};

Recycler.prototype.getRecyclerByEmail = async function (email) {
  let data = await recyclersCollection.findOne({
    recyclerEmail: email,
  });

  return data;
};

module.exports = Recycler;
