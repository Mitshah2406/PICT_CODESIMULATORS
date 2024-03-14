const authoritiesCollection = require("../db").db().collection("authorities");

const ObjectID = require("mongodb").ObjectID;
const bcrypt = require("bcrypt");

let Authority = function (data) {
  this.data = data;
  this.errors = [];
};

Authority.prototype.cleanUp = function () {
  this.data = {
    authorityEmail: this.data.authorityEmail,
    authorityPassword: this.data.authorityPassword,

    // More fields will be added later
    createdDate: new Date(),
  };
};

module.exports = Authority;
