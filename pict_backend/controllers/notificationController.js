
const axios = require('axios');
require('dotenv').config();
exports.sendNotifcation = async (req, res) => {
    const { title, body, url, dl } = req.body;
    try {
        headers = {
            'Authorization': `key=${process.env.FIREBASE_API_KEY}`,
            'Content-Type': 'application/json',
        };

        await axios.post('https://fcm.googleapis.com/fcm/send', {
            "to": "e0lLkFlaRAK3mhtIb2m2Op:APA91bGnoXS3jIWJQWbryb5P3gdwk-QCtiayX7PISeJ0zs8jXLikO1lgBBhi9c_ecx5WZ5UAEPElkH1m_b0DlKpm0D4HH87y5RL248tG8zXF1__ZS4nogwfbTxxethzoYkeL7a5Zy5fe",
            "notification": {
                "title": `ALERT!!`,
                "body": `Hello atharva`,
                "mutable_content": true,
                "sound": "Tri-tone",
                "url": "https://i.stack.imgur.com/lXio9.jpg?s=256&g=1"
            },
            "data": { "dl": "/notification-screen" }
        }, { headers })
        res.status(200).send("Notification sent successfully");
    } catch (e) {
        console.log(e);
        return res.status(500).send(error)
    }
};
