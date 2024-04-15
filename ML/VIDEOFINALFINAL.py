import face_recognition
import cv2
import os
import time
import requests



urlForWhatsappBot = 'http://192.168.154.85:4000/whatsapp/littered'
# accessTokenForWhatsappBot = ''
# headersForWhatsappBot = {
#   'Authorization': f'Bearer {accessTokenForWhatsappBot}',
#   'Content-Type': 'application/json',
# }
# API endpoint and headers
#Add ultralytics url below after training your model! We used the yolov8 on the tacotrash dataset
url = ""
headers = {"x-api-key": ""}
data = {"size": 640, "confidence": 0.5, "iou": 0.5}

# Load known faces and their encodings
known_faces = []
labels = []

def load_face_image(image_path):
    image = face_recognition.load_image_file(image_path)
    face_encoding = face_recognition.face_encodings(image)[0]
    return face_encoding

known_faces.append(load_face_image("rajat.png"))
labels.append("Rajat")

known_faces.append(load_face_image("mit.png"))
labels.append("Mit")

known_faces.append(load_face_image("taher.png"))
labels.append("Taher")

prev_label=None
# Initialize video capture
video_capture = cv2.VideoCapture(1)
time.sleep(5)

# Variables for saving frames
output_directory = "output_images"
os.makedirs(output_directory, exist_ok=True)
save_interval = 10  # in seconds
start_time = time.time()
prev_frame = None

# Create a new window for displaying littered information
cv2.namedWindow("Littered", cv2.WINDOW_NORMAL)
cv2.resizeWindow("Littered", 640, 480)

while True:
    # Capture frame-by-frame
    ret, frame = video_capture.read()
    
    # Resize frame for faster processing
    small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

    # Find face locations and encodings
    face_locations = face_recognition.face_locations(small_frame)
    face_encodings = face_recognition.face_encodings(small_frame, face_locations)

    if len(face_locations) == 0:
        prev_frame = frame.copy()
    else:
        # for face_encoding, face_location in zip(face_encodings, face_locations):
        #     results = face_recognition.compare_faces(known_faces, face_encoding)
        #     for i, result in enumerate(results):
        #         if result:
        #             prev_label = labels[i]
        #             break
        for face_encoding, face_location in zip(face_encodings, face_locations):
        # Compare face encoding with known faces
            results = face_recognition.compare_faces(known_faces, face_encoding)

            for i, result in enumerate(results):
                if result:
                    # Scale back up face locations since the frame we detected in was scaled to 1/4 size
                    top, right, bottom, left = face_location
                    top *= 4
                    right *= 4
                    bottom *= 4
                    left *= 4
                    prev_label = labels[i]
                    # Draw a box around the face
                    cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)

                    # Draw a label with a name below the face
                    cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 255, 0), cv2.FILLED)
                    font = cv2.FONT_HERSHEY_DUPLEX
                    cv2.putText(frame, labels[i], (left + 6, bottom - 6), font, 1.0, (255, 255, 255), 1)

    # Save frame and send to API after specified interval
    if time.time() - start_time >= save_interval:
        cv2.imwrite(os.path.join(output_directory, "afterimg.png"), frame)
        start_time = time.time()
        
        # Read saved image and resize
        image = cv2.imread(os.path.join(output_directory, "afterimg.png"))
        resized_image = cv2.resize(image, (640, 480))
        _, img_encoded = cv2.imencode('.png', resized_image)
        image_data = img_encoded.tobytes()

        # Send image to API
        response = requests.post(url, headers=headers, data=data, files={"image": image_data})
        response.raise_for_status()  
        cv2.imwrite(os.path.join(output_directory, "afterimg_detect.png"), frame)
        p = len(response.json()["data"]) 
        
        if p > 0:
            if prev_label is not None:
                trashCount = str(p)
                tx=f'Dear {prev_label}, you have been caught littering {trashCount}. As a result, you are being fined a penalty of 100 rupees in accordance with our regulations.'
                print(prev_label + " Littered P= "+str(p))
                response = requests.post(urlForWhatsappBot, json={'message': tx})
                response.raise_for_status()
                break
            else:
                trashCount = str(p)
                tx=f'you have been caught littering {trashCount}. As a result, you are being fined a penalty of 100 rupees in accordance with our regulations.'
                print("Someone Littered P= "+str(p))
                response = requests.post(urlForWhatsappBot, json={'message': tx})
                response.raise_for_status()
                break

    cv2.imshow('Video', frame)
    # Check for exit key
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release video capture and close windows
video_capture.release()
cv2.destroyAllWindows()
