const { ObjectId } = require("mongodb");
const taskCollection = require("../db").db().collection("tasks");
const userCollection = require("../db").db().collection("users");
const ObjectID = require("mongodb").ObjectID;

let Task = function (data) {
    this.data = data;
    this.errors = [];
  };

  Task.prototype.cleanUp=function(){
    this.data={
        taskTitle: this.data.taskTitle,
        taskPoints:Number(this.data.taskPoints),
        createdDate: new Date(),
    }
}
Task.prototype.getAllTasks = async function(){
    const taskCursor = await taskCollection.find()
    const tasks = await taskCursor.toArray();
    return tasks
}
Task.prototype.getRandomTask = async function() {
    const count = await taskCollection.countDocuments();
    const randomIndex = Math.floor(Math.random() * count);
    
    const randomTask = await taskCollection.aggregate([
        { $sample: { size: 1 } },
        { $skip: randomIndex }
    ]).toArray();

    return randomTask[0];
};
Task.prototype.addBulkTasks=async function(tasksToAdd){
    try {
        const insertedCount = await taskCollection.insertMany(tasksToAdd);
        res.status(200).json({ message: `${insertedCount} tasks inserted successfully.` });
    } catch (error) {
        console.error("Error inserting bulk tasks:", error);
        res.status(500).json({ error: "Error inserting bulk tasks." });
    }

}
module.exports= Task;



  