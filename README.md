# PICT_CODESIMULATORS
## PICT International Techfiesta Hackathon Winning Project

## ```EcoSaathi``` - A Waste Management Project

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
