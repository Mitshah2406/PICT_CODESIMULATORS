# Import necessary libraries
from flask import Flask, request, jsonify, render_template
from PIL import Image
import google.generativeai as genai
import os

# Configure Google API key
os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

app = Flask(__name__)

def get_gemini_response(image):
    model = genai.GenerativeModel('gemini-pro-vision')
    fixed_question = "Is this an unhygenic dumpsite?"
    response = model.generate_content([fixed_question, image])
    yes_no_answer = response.text.lower() in ["yes", "no"]
    return yes_no_answer

@app.route('/')
def home():
    return render_template('index.html')

# Route to handle image processing
@app.route('/process_image', methods=['POST'])
def process_image():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'})
    if file:
        image = Image.open(file)
        response = get_gemini_response(image)
        return jsonify({'response': response})

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)
