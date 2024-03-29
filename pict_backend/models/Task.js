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
        taskDescription: this.data.taskDescription,
        taskPoints:Number(this.data.taskPoints),
        createdDate: new Date(),
    }
}
Task.prototype.getAllTasks = async function(){
    const taskCursor = await taskCollection.find()
    const tasks = await taskCursor.toArray();
    console.log(tasks)
    return tasks
}
Task.prototype.getRandomTask = async function() {
    const count = await taskCollection.countDocuments();
    const randomIndex = Math.floor(Math.random() * count);
    const taskCursor = await taskCollection.find()
    const tasks = await taskCursor.toArray();
    return tasks[randomIndex];
};
Task.prototype.addBulkTasks=async function(tasksToAdd){
    try {
        const insertedCount = await taskCollection.insertMany(tasksToAdd);
        return `${insertedCount} tasks inserted successfully.`
    } catch (error) {
        console.error("Error inserting bulk tasks:", error);
        return  "Error inserting bulk tasks."
    }

}
module.exports= Task;



  