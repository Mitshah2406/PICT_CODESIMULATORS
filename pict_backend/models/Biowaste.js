const biowasteCollection = require("../db").db().collection("biowaste");
const ObjectID = require("mongodb").ObjectID;

let Biowaste = function (data) {
    this.data = data;
    this.errors = [];
  };

  Biowaste.prototype.cleanUp = function () {
    this.data = {
        title: this.data.title,
        description: this.data.description,
        type: this.data.type, // Resource Type
        images: this.data.images, // Multiple images
        link: this.data.link, // URL/Link
        author: this.data.author, // Author/Publisher
        datePublished: this.data.datePublished, // Date Published
        language: this.data.language, // Language
        keywords: this.data.keywords, // Keywords/Tags
        duration: this.data.duration, // Duration
        createdDate: new Date()
    };
};

Biowaste.prototype.addResources = async function () {
   
    this.cleanUp();

    let data = await biowasteCollection.insertOne(this.data);

    if (data.acknowledged) {
        return "ok";
    }
    return "fail";
};

Biowaste.prototype.getBiowasteResources = async function () {
    let data = await biowasteCollection.find({}).sort({ _id: -1 }).toArray();
    return data;
  };


module.exports = Biowaste;

