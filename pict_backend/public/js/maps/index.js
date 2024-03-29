window.onload = async function () {
  console.log("Inside onload");
  let allRoutes = await fetch("http://localhost:4000/getRoutes");
  let colorCounter = 0;
  const polylineColors = [
    "#1f77b4", // dark blue
    "#ff7f0e", // orange
    "#2ca02c", // green
    "#d62728", // red
    "#9467bd", // purple
    "#8c564b", // brown
    "#e377c2", // pink
    "#7f7f7f", // gray
    "#bcbd22", // olive
    "#17becf", // light blue
    "#aec7e8", // light blue shade
    "#ffbb78", // light orange
    "#98df8a", // light green
    "#ff9896", // light red
    "#c5b0d5", // light purple
    "#c49c94", // light brown
    "#f7b6d2", // light pink
    "#c7c7c7", // light gray
    "#dbdb8d", // light olive
    "#9edae5", // light light blue
  ];

  //Initialize the Direction Service
  var service = new google.maps.DirectionsService();
  var routess = await allRoutes.json();
  console.log(routess);
  var mapOptions = {
    center: new google.maps.LatLng(
      routess.truck_routes[0][0].depotLocation.lat,
      routess.truck_routes[0][0].depotLocation.lon
    ),
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
  };

  var map = new google.maps.Map(document.getElementById("map"), mapOptions);
  let stroke_arr = [];
  var infoWindow = new google.maps.InfoWindow();
  routess.truck_routes.forEach(async (single_truck_route) => {
    colorCounter++;

    console.log("COlors counter" + colorCounter);
    let color = polylineColors[colorCounter % polylineColors.length];
    console.log(
      "Polyline Colors" + color + " single_truck_route: ",
      single_truck_route
    );

    // Changed color assignment
    // console.log("Single Truck Route: ", single_truck_route);
    var lat_lng = new Array();
    var latlngbounds = new google.maps.LatLngBounds();
    for (i = 0; i < single_truck_route.length; i++) {
      var data = single_truck_route[i];
      // console.log(data);
      var myLatlng;
      var marker;
      if (i == 0 || i == single_truck_route.length - 1) {
        myLatlng = new google.maps.LatLng(
          data.depotLocation.lat,
          data.depotLocation.lon
        );
        lat_lng.push(myLatlng);
        marker = new google.maps.Marker({
          position: myLatlng,
          map: map,
          title: data.timestamp,
          icon: "https://developers.google.com/maps/documentation/javascript/examples/full/images/library_maps.png",
        });
      } else {
        myLatlng = new google.maps.LatLng(
          data.binLocation.lat,
          data.binLocation.lon
        );
        lat_lng.push(myLatlng);
        marker = new google.maps.Marker({
          position: myLatlng,
          map: map,
          title: data.timestamp,
          icon: "/images/dustbin.png",
        });
        //Loop and Draw Path Route between the Points on MAP
      }
      latlngbounds.extend(marker.position);
      (function (marker, data) {
        google.maps.event.addListener(marker, "click", function (e) {
          infoWindow.setContent("Garbage Depot");
          infoWindow.open(map, marker);
        });
      })(marker, data);

      // console.log("Lat Lng: ", lat_lng);
      for (var j = 0; j < lat_lng.length; j++) {
        if (j + 1 < lat_lng.length) {
          var src = lat_lng[j];
          var des = lat_lng[j + 1];
          console.log("Source: " + src + " Destination: " + des);
          // path.push(src);

          service.route(
            {
              origin: src,
              destination: des,

              travelMode: google.maps.DirectionsTravelMode.WALKING,
            },
            function (result, status) {
              if (status == google.maps.DirectionsStatus.OK) {
                //Initialize the Path Array
                var path = new google.maps.MVCArray();
                //Set the Path Stroke Color
                stroke_arr.push(polylineColors[colorCounter]);
                var poly = new google.maps.Polyline({
                  map: map,
                  strokeColor: color,
                });
                poly.setPath(path);
                poly.setOptions({ strokeWeight: 7 });
                // console.log(result)

                for (
                  var k = 0, len = result.routes[0].overview_path.length;
                  k < len;
                  k++
                ) {
                  path.push(result.routes[0].overview_path[k]);
                }
              }
            }
          );

          // // Asynchronous route fetching
          // let result = await new Promise(resolve => {
          //     service.route({
          //         origin: src,
          //         destination: des,
          //         travelMode: google.maps.DirectionsTravelMode.WALKING
          //     }, function (result, status) {
          //         if (status == google.maps.DirectionsStatus.OK) {
          //             resolve(result);
          //         } else {
          //             resolve(null);
          //         }
          //     });
          // });

          // if (result) {
          //     let path = new google.maps.MVCArray();
          //     let poly = new google.maps.Polyline({
          //         map: map,
          //         strokeColor: color, // Set stroke color
          //     });
          //     poly.setPath(path);
          //     poly.setOptions({ strokeWeight: 5 });

          //     for (let k = 0; k < result.routes[0].overview_path.length; k++) {
          //         path.push(result.routes[0].overview_path[k]);
          //     }
          // }
        }
      }
    }
    map.setCenter(latlngbounds.getCenter());
    map.fitBounds(latlngbounds);
  });
  console.log(stroke_arr);
};
