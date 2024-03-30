window.onload = async function () {
  // let singleRoute = await fetch("http://localhost:4000/getSingleRoute/0");
  let allRoutes = await fetch("http://localhost:4000/getRoutes");
  let test_arr = [];
 
  //Initialize the Direction Service
  var routess = await allRoutes.json();
  var service = new google.maps.DirectionsService();
  const url = window.location.href;
  const parts = url.split("/");
  const value = parts[parts.length - 1];
  let single_truck_route = routess.truck_routes[value];
  //   initMap(single_truck_route);

  var mapOptions = {
    center: new google.maps.LatLng(
      single_truck_route[0].depotLocation.lat,
      single_truck_route[0].depotLocation.lon
    ),
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
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
    console.log("Mit Shah", data);
    // console.log("Each MaRKER"+ (JSON.stringify(single_truck_route[i].binLocation)|| JSON.stringify(single_truck_route[i].depotLocation)));
    var myLatlng;
    var marker;
    console.log("I is ", i);
    if (i == 0 || i == single_truck_route.length - 1) {
      console.log("Inside Depot ", i);
      myLatlng = new google.maps.LatLng(
        data.depotLocation.lat,
        data.depotLocation.lon
      );
      // console.log(data.depotLocation.lat, data.depotLocation.lon, data.depotLocation.formattedAddress);
      test_arr.push(data.depotLocation.formattedAddress);
      lat_lng.push(myLatlng);
      marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: "Garbage Depot",
        icon: "https://developers.google.com/maps/documentation/javascript/examples/full/images/library_maps.png",
      });
    } else {
      console.log("Inside Bins ", i);

      myLatlng = new google.maps.LatLng(
        data.binLocation.lat,
        data.binLocation.lon
      );
      lat_lng.push(myLatlng);
      test_arr.push(data.binLocation.fotmattedAddress);
      marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: data._id,
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
    for (var j = 0; j < lat_lng.length; j++) {
      if (j + 1 < lat_lng.length) {
        var src = lat_lng[j];
        var des = lat_lng[j + 1];
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
              var poly = new google.maps.Polyline({
                map: map,
                strokeColor: "#AA4A44",
              });
              poly.setPath(path);
              poly.setOptions({ strokeWeight: 2 });

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
      }
    }
  }
  map.setCenter(latlngbounds.getCenter());
  map.fitBounds(latlngbounds);

  console.log(test_arr);
  let waypoints = ""
  for (let i = 1; i < single_truck_route.length-1; i++) {
    const element = single_truck_route[i];
    waypoints += `${element.binLocation.lat},${element.binLocation.lon}|`
    
  }
  let link = `https://www.google.com/maps/dir/?api=1&origin=${single_truck_route[0].depotLocation.lat},${single_truck_route[0].depotLocation.lon}&destination=${single_truck_route[0].depotLocation.lat},${single_truck_route[0].depotLocation.lon}&waypoints=${waypoints}`
  directionLink = document.getElementById("directionLink")
  directionLink.innerHTML = `<a href=${link} target='_blank'>Directions </a>`
// `
};



