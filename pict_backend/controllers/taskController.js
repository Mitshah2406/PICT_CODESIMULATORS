const Task = require("../models/Task");
const User = require("../models/User");
const path = require("path");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const genAI = new GoogleGenerativeAI("AIzaSyCH12f11jfOO7_E3GJnwVXzQb8hbiXTHlU");
const fs = require("fs");
function fileToGenerativePart(path, mimeType) {
  return {
    inlineData: {
      data: Buffer.from(fs.readFileSync(path)).toString("base64"),
      mimeType,
    },
  };
}
// Controller for handling tasks
exports.getAllTasks = async function (req, res) {
  try {
    let task = new Task();
    const tasks = await task.getAllTasks();
    res.status(200).json({ result: tasks });
  } catch (err) {
    console.log(err);
    res.status(400).json({ error: "Error in getting tasks" });
  }
};

exports.getRandomTask = async function (req, res) {
  try {
    let task = new Task();
    const randomTask = await task.getRandomTask();
    res.status(200).json({ result: randomTask });
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
    res
      .status(200)
      .json({ message: `${tasksToAdd.length} tasks inserted successfully.` });
  } catch (err) {
    console.error("Error inserting bulk tasks:", err);
    res.status(500).json({ error: "Error inserting bulk tasks." });
  }
};

exports.validateTask = async function (req, res) {
  try {
    const { title, userId, taskId } = req.body;
    console.log(req.body);

    if (req.files.imagePath) {
      const file = req.files.imagePath;
      // console.log(logoFile.name);
      const fileName1 = new Date().getTime().toString() + "-" + file.name;
      const savePath1 = path.join(
        __dirname,
        "../public/",
        "taskImages",
        fileName1
      );
      await file.mv(savePath1);
      const model = genAI.getGenerativeModel({ model: "gemini-pro-vision" });
      const prompt = `Is the image I have provided resembling with this task ${title}, reply in yes or no?`;

      const imageParts = [fileToGenerativePart(savePath1, "image/png")];

      const result = await model.generateContent([prompt, ...imageParts]);
      const response = await result.response;
      // console.log(text);
      const text = response.text().toLowerCase().trim(); // Convert text to lowercase for comparison
      console.log("Validation response:", text);
      if (text != "no.") {
        let user = new User();
        let task = new Task();
        const taskData = await task.getTaskById(taskId);
        const taskPoints = taskData.taskPoints;
        console.log(taskData);
        let userData = await user.getUserById(userId);
        console.log(userData.reward, "dtfgvhbj");
        userData.reward += taskPoints;
        let response = await user.updatePoints(userId, userData.reward);
        console.log(response);
        res.status(200).json({ result: true });
      } else {
        res.status(200).json({ result: false });
      }
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
