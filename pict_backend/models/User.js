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
    userMobileNo: this.data.accountMobileNo,
    userPassword: this.data.accountPassword,
    role: "user",
    // More fields will come later
    userImage: null,
    eventsRegisteredIn: [],
    certificates: [],
    favoriteItems: [],
    tasks: [],
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
  let data = await usersCollection.insertOne(this.data);

  let userDoc = await usersCollection.findOne({
    _id: new ObjectID(data.insertedId),
  });

  return {
    message: "ok",
    data: userDoc,
  };
};

User.prototype.getUserByEmail = async function (email) {
  let data = await usersCollection.findOne({ userEmail: email });

  return {
    message: "ok",
    data: data,
  };
};

User.prototype.getUserById = async function (userId) {
  let data = await usersCollection.findOne({ _id: new ObjectID(userId) });
  return data;
};

User.prototype.editProfile = async function ({
  userFirstName,
  userLastName,
  userEmail,
  userImage,
}) {
  let data = await usersCollection.findOneAndUpdate(
    {
      userEmail: userEmail,
    },
    {
      $set: {
        userFirstName: userFirstName,
        userLastName: userLastName,
        userEmail: userEmail,
        userImage: userImage,
      },
    },
    {
      returnDocument: "after",
    }
  );

  console.log(data);

  return {
    message: true,
    userImage: data.value.userImage,
  };
};
User.prototype.updatePoints = async function (userId, newData) {
  try {
    let updatedUser = await usersCollection.findOneAndUpdate(
      { _id: new ObjectID(userId) }, // Filter
      { $set: { reward: newData } }
    );
    return updatedUser;
  } catch (error) {
    console.error("Error updating user:", error);
    throw error;
  }
};

User.prototype.getCountOfUserRewards = async function (userId) {
  let data = await usersCollection.findOne({ _id: new ObjectID(userId) });

  return data.reward;
};
User.prototype.getAllUserImages = async function () {
  try {
    const users = await usersCollection.find().toArray();
    const userImages = users.map((user) => user.userImage);
    const filteredImages = userImages.filter((image) => image);
    return filteredImages;
  } catch (error) {
    console.error("Error retrieving user images:", error);
    throw error;
  }
};

User.prototype.completedTask = async function (userId, taskId) {
  try {
    let data = await usersCollection.findOneAndUpdate(
      { _id: new ObjectID(userId) },
      {
        $push: {
          tasks: {
            taskId: new ObjectID(taskId),
            registeredDate: new Date(),
          },
        },
      }
    );

    return "ok";
  } catch (error) {
    console.error("Error retrieving user images:", error);
    throw error;
  }
};

User.prototype.getCompletedTaskOfUsers = async function (userId) {
  let data = await usersCollection
    .aggregate([
      {
        $match: {
          _id: new ObjectID(userId),
        },
      },
      {
        $unwind: "$tasks",
      },
      {
        $lookup: {
          from: "tasks",
          localField: "tasks.taskId",
          foreignField: "_id",
          as: "taskData",
        },
      },
      {
        $unwind: "$taskData",
      },
      {
        $group: {
          _id: new ObjectID(userId),
          tasks: {
            $addToSet: "$taskData",
          },
        },
      },
    ])
    .toArray();

  return data;
};

module.exports = User;
