# PICT CODESIMULATORS
## PICT International Techfiesta Hackathon Winning Project 🥇

## ```EcoSaathi``` - A Waste Management Project

# Bin Fill Level Detection using Computer Vision

The system is also capable of identifying whether a garbage bin is full or not. This information is gathered through IoT-based sensors installed in the bins. Once detected, the data is promptly transmitted to the authorities. With this real-time data, authorities can efficiently manage waste collection by dispatching trucks accordingly, optimizing their routes based on the status of the bins.

<img width="1257" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/117341727/671921ba-0726-4b86-83ee-866488c0ba7c">

# Route Optimization using Capacitated Vehicle Routing Problem

Optimizing Garbage Collection Routes for the pickup trucks using Google Maps API, Capacitated Vehicle Routing Problem, Distance Matrix API, Directions API, Geocoding API

## Showing Optimized Route For 4 trucks using 13 bins spread across the city 
<img width="1257" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/4790a3f6-5079-4f6d-b0b7-db266df250e7">

## Each icon also has a pin with details of the location such as garbage depot or bin
<img width="1253" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/24c180e4-39d1-4a7d-803d-90015000f58f">

## The Route of each truck
<img width="1255" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/85c98f41-c4c4-4d8e-9534-43cb2ff87d68">

# Events Module 

This module aims to coordinate social cause events and initiatives, inspiring individuals to engage actively in waste disposal efforts.
The user can register as
1) Participants
2) Volunteers
Participants receive dynamically generated certificates recognizing their contributions to the social cause initiative.

Organizers scan the barcode on the user's registration ticket to confirm attendance at the event. Simultaneously, a dynamic certificate is generated for the user, and a WhatsApp notification is promptly dispatched to inform them.

Some Screenshots from the user's side:

<img width="250" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/30176094-9ec7-436f-95d0-6706b25465ab">
<img width="250" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/c6a84203-2b55-4dbe-bdc3-6c5fa8e6a8bb">
<img width="250" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/47e3bbec-a408-43ae-b5ac-c0616c7638d9">

# Litterbug Detector using Computer Vision

This module is designed to detect any individual littering on the streets using CCTV footage. For demonstration purposes, we have created a sample dataset and operated it. When a person is observed littering, the model promptly detects the act, identifies the individual, and sends them a WhatsApp notification informing them that they have been caught littering and are being fined X amount.

Additionally, we utilized a YOLOv8 model trained on the Taco Trash dataset, which enables the detection of the specific type of litter. We intend to impose fines on individuals based on the type of litter discarded. For instance, if a cigarette butt is thrown, the user will receive a fine of 10k,etc

Demonstration Link: https://youtu.be/bjuEkIFkxkw


# Notification (Alert Module) 

Used Meta Developers' Whatsapp API for sending timely notfications and alerts for various activities

<img width="581" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/1e3c3d27-c822-4050-81d8-376dae66c4ba">


# The Node, flutter and django servers need to be run simultaneously on the same network!

## Backend

```bash
cd ./pict_backend
npm i
npm start
```

## Frontend

## update IP address in utils/constants/app_constants.dart and also relevant API Keys

```bash
cd ./pict_frontend
flutter pub get
flutter run
```

## Django Server For Route Optimization

```bash
cd ./route_optimization
```
## Make a virtual environment
```bash
pip install -r requirements.txt
```
## Enter Google Maps API Key in your operating system's env

## For MAC
```bash
export VARIABLE='something'
```

## For Windows

```bash
setx [variable_name] "[variable_value]"
```

## Now Run

```bash
python manage.py runserver <IP_ADDRESS_OF_NODE_SERVER>:8080
```
