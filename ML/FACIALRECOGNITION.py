import face_recognition
import cv2

# Load the jpg files into numpy arrays
biden_image = face_recognition.load_image_file("rajat.png")
obama_image = face_recognition.load_image_file("mit.png")
taher_image=face_recognition.load_image_file("taher.png")

# Get the face encodings for each face in each image file
biden_face_encoding = face_recognition.face_encodings(biden_image)[0]
obama_face_encoding = face_recognition.face_encodings(obama_image)[0]
taher_face_encoding = face_recognition.face_encodings(taher_image)[0]

known_faces = [biden_face_encoding, obama_face_encoding,taher_face_encoding]
labels = ["Rajat", "Mit","Taher"]

# Get a reference to webcam #0 (the default one)
video_capture = cv2.VideoCapture(0)

while True:
    # Capture frame-by-frame
    ret, frame = video_capture.read()

    # Resize frame of video to 1/4 size for faster face recognition processing
    small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

    # Find all face locations and encodings in the current frame
    face_locations = face_recognition.face_locations(small_frame)
    face_encodings = face_recognition.face_encodings(small_frame, face_locations)

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

                # Draw a box around the face
                cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)

                # Draw a label with a name below the face
                cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 255, 0), cv2.FILLED)
                font = cv2.FONT_HERSHEY_DUPLEX
                cv2.putText(frame, labels[i], (left + 6, bottom - 6), font, 1.0, (255, 255, 255), 1)

    # Display the resulting frame
    cv2.imshow('Video', frame)

    # Break the loop if 'q' is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the video capture object
video_capture.release()
cv2.destroyAllWindows()
