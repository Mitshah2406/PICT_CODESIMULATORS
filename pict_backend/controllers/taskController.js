const Task = require("../models/Task");

// Controller for handling tasks
exports.getAllTasks = async function (req, res) {
  try {
    let task = new Task();
    const tasks = await task.getAllTasks();
    res.status(200).json(tasks);
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in getting tasks" });
  }
};

exports.getRandomTask = async function (req, res) {
  try {
    let task = new Task();
    const randomTask = await task.getRandomTask();
    res.status(200).json(randomTask);
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in getting random task" });
  }
};

exports.addBulkTasks = async function (req, res) {
  const tasksToAdd = req.body.tasks; // Assuming tasks are sent in the request body
  try {
    console.log("Tasks to add:", tasksToAdd);
    let task = new Task();
    await task.addBulkTasks(tasksToAdd);
    res.status(200).json({ message: `${tasksToAdd.length} tasks inserted successfully.` });
  } catch (err) {
    console.error("Error inserting bulk tasks:", err);
    res.status(500).json({ error: "Error inserting bulk tasks." });
  }
};
