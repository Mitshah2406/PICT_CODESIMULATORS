# PICT_CODESIMULATORS
## PICT International Techfiesta Hackathon Winning Project

## ```EcoSaathi``` - A Waste Management Project

# Route Optimization Module using Capacitated Vehicle Routing Problem


## Showing Optimized Route For 4 trucks using 13 bins spread accross the city 
<img width="1257" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/4790a3f6-5079-4f6d-b0b7-db266df250e7">

## Each Icon also have a pin with details of the location such as depot or bin
<img width="1255" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/85c98f41-c4c4-4d8e-9534-43cb2ff87d68">

## The Route of each truck
<img width="1253" alt="image" src="https://github.com/Mitshah2406/PICT_CODESIMULATORS/assets/84562856/24c180e4-39d1-4a7d-803d-90015000f58f">




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
