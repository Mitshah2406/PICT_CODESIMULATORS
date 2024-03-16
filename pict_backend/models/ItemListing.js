const itemlistingsCollection = require("../db").db().collection("items");
const usersCollection = require("../db").db().collection("users");

const ObjectID = require("mongodb").ObjectID;
// const bcrypt = require("bcrypt");
// const validator = require("validator");
// const md5 = require("md5");
// const { ReturnDocument } = require("mongodb");

let ItemListing = function (data) {
  this.data = data;
  this.errors = [];
};

ItemListing.prototype.cleanUp = function () {
  this.data = {
    title: this.data.title,
    description: this.data.description,
    category: this.data.category, // ['Electronics', 'Clothes', 'Furniture']
    images: this.data.images, // Multiple images
    price: this.data.price, // Get Price estimation based on image
    condition: this.data.condition, // ['new', 'used', 'refurbished']
    address: this.data.address, // Get user current address
    city: this.data.city,

    // Some Personal Information of Seller, Automatically fetched from sharedPreferences in flutter
    userId: new ObjectID(this.data.userId),
    name: this.data.name,
    email: this.data.email,
    mobileNo: this.data.mobileNo,
    createdDate: new Date(),
  };
};

ItemListing.prototype.addItem = async function () {
  this.cleanUp();

  let data = await itemlistingsCollection.insertOne(this.data);

  if (data.acknowledged) {
    return "ok";
  }
  return "fail";
};

ItemListing.prototype.getItemById = async function (itemId) {
  let data = await itemlistingsCollection.findOne({
    _id: new ObjectID(itemId),
  });
  return data;
};

ItemListing.prototype.getAllItems = async function () {
  let data = await itemlistingsCollection.find({}).sort({ _id: -1 }).toArray();
  return data;
};

ItemListing.prototype.getAllItemsPostedByUser = async function (userId) {
  let data = await itemlistingsCollection
    .find({ userId: new ObjectID(userId) })
    .sort({ _id: -1 })
    .toArray();
  return data;
};

ItemListing.prototype.getItemCountPostedByUser = async function (userId) {
  let data = await itemlistingsCollection.countDocuments({
    userId: new ObjectID(userId),
  });

  return data;
};

ItemListing.prototype.searchItemByTitle = async function (title) {
  if (title.length > 0) {
    let data = await itemlistingsCollection
      .aggregate([
        {
          $search: {
            index: "searchByTitle",
            text: {
              query: title,
              path: {
                wildcard: "title*",
              },
              fuzzy: {
                maxEdits: 2,
                prefixLength: 0,
                maxExpansions: 50,
              },
            },
          },
        },
      ])
      .toArray();

    return data;
  }

  return null;
};

ItemListing.prototype.filterByCategory = async function (category) {
  let data = await itemlistingsCollection
    .find({ category: category })
    .sort({ _id: -1 })
    .toArray();

  return data;
};

ItemListing.prototype.filterByLocation = async function (city) {
  let data = await itemlistingsCollection
    .find({ city: city })
    .sort({ _id: -1 })
    .toArray();

  return data;
};

ItemListing.prototype.addItemToFav = async function (userId, itemId) {
  await usersCollection.findOneAndUpdate(
    { _id: new ObjectID(userId) },
    {
      $push: {
        favoriteItems: {
          itemId: new ObjectID(itemId),
          addedDate: new Date(),
        },
      },
    }
  );

  return "ok";
};

ItemListing.prototype.removeItemFromFav = async function (userId, itemId) {
  await usersCollection.findOneAndUpdate(
    { _id: new ObjectID(userId) },
    {
      $pull: {
        favoriteItems: {
          itemId: new ObjectID(itemId),
        },
      },
    }
  );

  return "ok";
};

ItemListing.prototype.checkIfItemAlreadyExist = async function (
  userId,
  itemId
) {
  let user = await usersCollection.findOne({ _id: new ObjectID(userId) });

  let isItemInFavorites = user.favoriteItems.some((item) =>
    item.itemId.equals(new ObjectID(itemId))
  );

  return isItemInFavorites;
};

module.exports = ItemListing;
