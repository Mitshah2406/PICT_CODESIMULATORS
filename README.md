# PICT_CODESIMULATORS
## PICT International Techfiesta Hackathon Winning Project

## ```EcoSaathi``` - A Waste Management Project

# Route Optimization Module using Capacitated Vehicle Routing Problem

Optimizing Garbage Collection Routes for the pickup trucks using Google Maps API, Capacitated Vehicle Routing Problem, Distance Matrix API, Directions API, Geocoding API

## Showing Optimized Route For 4 trucks using 13 bins spread accross the city 
<img width="1257" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/4790a3f6-5079-4f6d-b0b7-db266df250e7">

## Each Icon also have a pin with details of the location such as depot or bin
<img width="1253" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/24c180e4-39d1-4a7d-803d-90015000f58f">

## The Route of each truck
<img width="1255" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/85c98f41-c4c4-4d8e-9534-43cb2ff87d68">

# Events Module 

This module is for organizing social cause events and drives and motivate people towards waste disposal.
The public can register as
1) Participants
2) Volunteers
For which they get a certificate of contribution towards social cause that is generated dynamically.

The organizers scan the barcode of the user's registeration ticket to mark him present at the event. At the same time, the certificate is generated dynamically for the user and a whatsapp notification is sent to the user.

Some Screenshots from user side:
<img width="356" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/30176094-9ec7-436f-95d0-6706b25465ab">

<img width="360" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/c6a84203-2b55-4dbe-bdc3-6c5fa8e6a8bb">

<img width="355" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/47e3bbec-a408-43ae-b5ac-c0616c7638d9">


## Notification (Alert Module) 

Used Meta Developers Whatsapp API for sending timely ntofications and alerts on various events

<img width="581" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/1e3c3d27-c822-4050-81d8-376dae66c4ba">


# All these Node, flutter and django server need to be run simultaneously on same network.

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
