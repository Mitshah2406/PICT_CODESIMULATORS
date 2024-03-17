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

Authority.prototype.login = async function(authorityEmail,authorityPassword){
  let authority =  await authoritiesCollection.findOne({
    authorityEmail:authorityEmail
  });
   if (!authority) {
    return "Invalid Credentials";
   }
   let  validPass=await bcrypt.compareSync(authorityPassword,authority.authorityPassword);
   if(!validPass){
    return "Invalid Credentials"
   }
   return authority;

}

module.exports = Authority;
