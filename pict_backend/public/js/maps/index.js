
window.onload = async function () {
    let allRoutes = await fetch("http://localhost:4000/getRoutes");
   


    //Initialize the Direction Service
    var service = new google.maps.DirectionsService();
    var routess = await allRoutes.json();
    routess.truck_routes.forEach(single_truck_route => {
        console.log("Single Truck Route: ", single_truck_route);
        var mapOptions = {
            center: new google.maps.LatLng(single_truck_route[0].depotLocation.lat, single_truck_route[0].depotLocation.lon),
            zoom: 10,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);
        var infoWindow = new google.maps.InfoWindow();
        var lat_lng = new Array();
        var latlngbounds = new google.maps.LatLngBounds();
        for (i = 0; i < single_truck_route.length; i++) {
            var data = single_truck_route[i];
            console.log(data);
var myLatlng;
var marker;
            if(i==0 || i==single_truck_route.length-1){
                 myLatlng = new google.maps.LatLng(data.depotLocation.lat, data.depotLocation.lon);
                lat_lng.push(myLatlng);
                 marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: data.timestamp,
                     icon: "https://developers.google.com/maps/documentation/javascript/examples/full/images/library_maps.png"
                });
            }else{
                 myLatlng = new google.maps.LatLng(data.binLocation.lat, data.binLocation.lon);
                lat_lng.push(myLatlng);
                 marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: data.timestamp,
                    icon: "https://developers.google.com/maps/documentation/javascript/examples/full/images/parking_lot_maps.png"
                });
                //Loop and Draw Path Route between the Points on MAP
             
            }
         
            // console.log(i)

            latlngbounds.extend(marker.position);
            (function (marker, data) {
                google.maps.event.addListener(marker, "click", function (e) {
                    infoWindow.setContent(data.timestamp);
                    infoWindow.open(map, marker);
                });
            })(marker, data);

            console.log("Lat Lng: ", lat_lng);
            for (var i = 0; i < lat_lng.length; i++) {
                if ((i + 1) < lat_lng.length) {
                    var src = lat_lng[i];
                    var des = lat_lng[i + 1];
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
                            // console.log(result)

                            for (var i = 0, len = result.routes[0].overview_path.length; i < len; i++) {
                                path.push(result.routes[0].overview_path[i]);
                            }
                        }
                    });
                }
            }
        }
        map.setCenter(latlngbounds.getCenter());
        map.fitBounds(latlngbounds);


      
    });
    
}