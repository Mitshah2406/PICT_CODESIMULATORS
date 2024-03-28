
window.onload = async function () {
    // let allRoutes = await fetch("http://localhost:4000/getRoutes");
    let test_arr=[]
    let routess = {
        "total_distance": 72127,
        "total_garbage_picked": 40,
        "truck_routes": [
            [
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                },
                {
                    "_id": "660455329ffb0d49a41574e0",
                    "binLocation": {
                        "lat": 18.514326,
                        "lon": 73.847709,
                        "fotmattedAddress": "350/1, Laxmi Rd, Narayan Peth, Pune, Maharashtra 411030, India"
                    },
                    "binFillLevel": 8,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:19:46.577Z"
                },
                {
                    "_id": "660455a49ffb0d49a41574e4",
                    "binLocation": {
                        "lat": 18.503786,
                        "lon": 73.85738,
                        "fotmattedAddress": "1115, Thorale Madhavarao Peshve Path, Subhash Nagar, Shukrawar Peth, Pune, Maharashtra 411002, India"
                    },
                    "binFillLevel": 2,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:21:40.540Z"
                },
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                }
            ],
            [
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                },
                {
                    "_id": "6604551c9ffb0d49a41574df",
                    "binLocation": {
                        "lat": 18.556753,
                        "lon": 73.851751,
                        "fotmattedAddress": "HV42+QQ6, Khadki Railway Station Rd, Opp. Khadki Court, Khadki, Pune, Maharashtra 411003, India"
                    },
                    "binFillLevel": 8,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:19:24.443Z"
                },
                {
                    "_id": "660454a79ffb0d49a41574dc",
                    "binLocation": {
                        "lat": 18.554043,
                        "lon": 73.852183,
                        "fotmattedAddress": "HV32+FVG, Adarsh Nagar Bhaiya Wadi, Bhaiya Wadi, Khadki, Pune, Maharashtra 411003, India"
                    },
                    "binFillLevel": 2,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:17:27.569Z"
                },
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                }
            ],
            [
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                },
                {
                    "_id": "6604540e9ffb0d49a41574d8",
                    "binLocation": {
                        "lat": 18.498052,
                        "lon": 73.884455,
                        "fotmattedAddress": "FVXM+2M4, Pune Cantonment, Pune, Maharashtra 411001, India"
                    },
                    "binFillLevel": 1,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:14:54.181Z"
                },
                {
                    "_id": "660454c09ffb0d49a41574dd",
                    "binLocation": {
                        "lat": 18.459429,
                        "lon": 73.85305,
                        "fotmattedAddress": "FV53+W9X, Bharati Vidyapeeth Campus, Dhankawadi, Pune, Maharashtra 411043, India"
                    },
                    "binFillLevel": 4,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:17:52.506Z"
                },
                {
                    "_id": "6604543d9ffb0d49a41574d9",
                    "binLocation": {
                        "lat": 18.498052,
                        "lon": 73.812529,
                        "fotmattedAddress": "FRX7+523, Lane Number 17, Dahanukar Colony, Kothrud, Pune, Maharashtra 411038, India"
                    },
                    "binFillLevel": 1,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:15:41.251Z"
                },
                {
                    "_id": "660455739ffb0d49a41574e2",
                    "binLocation": {
                        "lat": 18.544163,
                        "lon": 73.862144,
                        "fotmattedAddress": "163, Lane, 11, Mahatma Society, Kothrud, Pune, Maharashtra 411029, India"
                    },
                    "binFillLevel": 2,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:20:51.332Z"
                },
                {
                    "_id": "660454639ffb0d49a41574da",
                    "binLocation": {
                        "lat": 18.515633,
                        "lon": 73.803431,
                        "fotmattedAddress": "Mahtoba Nagar, Lane No 1, Matoba Nagar, Kothrud, Pune, Maharashtra 411038, India"
                    },
                    "binFillLevel": 2,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:16:19.214Z"
                },
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                }
            ],
            [
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                },
                {
                    "_id": "6604554e9ffb0d49a41574e1",
                    "binLocation": {
                        "lat": 18.525687,
                        "lon": 73.842368,
                        "fotmattedAddress": "GRGR+7XW, Sud Nagar, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "binFillLevel": 1,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:20:14.924Z"
                },
                {
                    "_id": "660455bd9ffb0d49a41574e5",
                    "binLocation": {
                        "lat": 18.54942,
                        "lon": 73.887893,
                        "fotmattedAddress": "GVXQ+Q4C, Kamraj Nagar Rd, Janta Nagar, Yerwada Village, Yerawada, Pune, Maharashtra 411006, India"
                    },
                    "binFillLevel": 4,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:22:05.343Z"
                },
                {
                    "_id": "6604548a9ffb0d49a41574db",
                    "binLocation": {
                        "lat": 18.558112,
                        "lon": 73.878791,
                        "fotmattedAddress": "120/205, Rto Office Area, Yerawada, Pune, Maharashtra 411006, India"
                    },
                    "binFillLevel": 4,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:16:58.948Z"
                },
                {
                    "_id": "6604558a9ffb0d49a41574e3",
                    "binLocation": {
                        "lat": 18.53951,
                        "lon": 73.852328,
                        "fotmattedAddress": "B/4, Sphurti Society, Wakadewadi, Shivajinagar, Pune, Maharashtra 411003, India"
                    },
                    "binFillLevel": 1,
                    "binFillLevelInKg": 10,
                    "binCapacityInKg": 40,
                    "lastCollection": "2024-03-18T00:00:00.000Z",
                    "lastUpdated": "2024-03-18T00:00:00.000Z",
                    "createdDate": "2024-03-27T17:21:14.508Z"
                },
                {
                    "_id": "660454e69ffb0d49a41574de",
                    "depotName": "Pune Garbage Depot",
                    "depotLocation": {
                        "lat": 18.525003,
                        "lon": 73.855504,
                        "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
                    },
                    "depotCapacity": null,
                    "createdDate": "2024-03-27T17:18:30.939Z"
                }
            ]
        ]
    }

    //Initialize the Direction Service
    var service = new google.maps.DirectionsService();
    let single_truck_route = routess.truck_routes[0];
    var mapOptions = {
        center: new google.maps.LatLng(single_truck_route[0].depotLocation.lat, single_truck_route[0].depotLocation.lon),
        zoom: 10,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map"), mapOptions);
    var infoWindow = new google.maps.InfoWindow();
    // var routess = await allRoutes.json();
    // routess.truck_routes.forEach(single_truck_route => {
        // console.log("Single Truck Route: ", single_truck_route);
        var lat_lng = new Array();
        var latlngbounds = new google.maps.LatLngBounds();
        for (i = 0; i < single_truck_route.length; i++) {
         
            var data = single_truck_route[i];
            // console.log("Each MaRKER"+ (JSON.stringify(single_truck_route[i].binLocation)|| JSON.stringify(single_truck_route[i].depotLocation)));
            var myLatlng;
            var marker;
            console.log("I is " ,i);
            if (i == 0 || i == single_truck_route.length - 1) {
            console.log("Inside Depot ", i);
                myLatlng = new google.maps.LatLng(data.depotLocation.lat, data.depotLocation.lon);
                // console.log(data.depotLocation.lat, data.depotLocation.lon, data.depotLocation.formattedAddress);
                test_arr.push(data.depotLocation.formattedAddress)
                lat_lng.push(myLatlng);
                marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: data.timestamp,
                    icon: "https://developers.google.com/maps/documentation/javascript/examples/full/images/library_maps.png"
                });
            } else {
                console.log("Inside Bins ", i);

                myLatlng = new google.maps.LatLng(data.binLocation.lat, data.binLocation.lon);
                lat_lng.push(myLatlng);
                test_arr.push( data.binLocation.fotmattedAddress)
                marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: data._id,
                    icon: "/images/dustbin.png"
                });
                //Loop and Draw Path Route between the Points on MAP

            }


            latlngbounds.extend(marker.position);
            (function (marker, data) {
                google.maps.event.addListener(marker, "click", function (e) {
                    infoWindow.setContent(data.timestamp);
                    infoWindow.open(map, marker);
                });
            })(marker, data);
            for (var j = 0; j < lat_lng.length; j++) {
                if ((j + 1) < lat_lng.length) {
                    var src = lat_lng[j];
                    var des = lat_lng[j + 1];
                    // path.push(src);

                    service.route({
                        origin: src,
                        destination: des,
                        travelMode: google.maps.DirectionsTravelMode.WALKING
                    }, function (result, status) {
                        if (status == google.maps.DirectionsStatus.OK) {

                            //Initialize the Path Array
                            var path = new google.maps.MVCArray();
                            //Set the Path Stroke Color
                            var poly = new google.maps.Polyline({
                                map: map,
                                strokeColor: '#AA4A44',

                            });
                            poly.setPath(path);
                            poly.setOptions({ strokeWeight: 5 });

                            for (var k = 0, len = result.routes[0].overview_path.length; k < len; k++) {
                                path.push(result.routes[0].overview_path[k]);
                            }
                        }
                    });
                }
            }
        }
        map.setCenter(latlngbounds.getCenter());
        map.fitBounds(latlngbounds);



  console.log(test_arr);
}