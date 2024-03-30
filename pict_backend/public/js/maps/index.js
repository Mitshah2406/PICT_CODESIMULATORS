window.onload = async function () {
  // console.log("Inside onload");
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

    // console.log("COlors counter" + colorCounter);
    let color = polylineColors[colorCounter % polylineColors.length];
    // console.log("Polyline Colors"+color+" single_truck_route: ", single_truck_route);

    // Changed color assignment
    // console.log("Single Truck Route: ", single_truck_route);
    var lat_lng = new Array();
    var latlngbounds = new google.maps.LatLngBounds();
    for (i = 0; i < single_truck_route.length; i++) {
      var data = single_truck_route[i];
      // console.log(data);
      var myLatlng;
      var marker;
      // var binMarker;
      if (i == 0 || i == single_truck_route.length - 1) {
        const contentString = `<div>
                      <h2>Garbage Depot</h2>
                      <ul>
                      <li><b>Depot Name</b>: ${data.depotName}</li>
                      <li><b>Depot Address</b>: ${data.depotLocation.formattedAddress}</li>
                      <li><b>Depot Location</b>: ${data.depotLocation.lat}, ${data.depotLocation.lon}</li>
                      </ul>
                     </div>`;
        const infowindow = new google.maps.InfoWindow({
          content: contentString,
          ariaLabel: "Depot",
        });
        myLatlng = new google.maps.LatLng(
          data.depotLocation.lat,
          data.depotLocation.lon
        );
        lat_lng.push(myLatlng);
        marker = new google.maps.Marker({
          position: myLatlng,
          map: map,

          icon: "https://developers.google.com/maps/documentation/javascript/examples/full/images/library_maps.png",
        });
        marker.addListener("click", () => {
          infowindow.open({
            anchor: marker,
            map,
          });
        });
      } else {
        const contentString = `<div>
                      <h2>Trash Bin</h2>
                      <ul>
                     <li> <b>Bin Address </b>: ${data.binLocation.fotmattedAddress}</li>
                     <li> <b>Bin Location </b>: ${data.binLocation.lat}, ${data.binLocation.lon}</li>
                     <li> <b>Bin Fill Level </b>: ${data.binFillLevel}</li>
                      </ul>
                     </div>`;
        const infowindow = new google.maps.InfoWindow({
          content: contentString,
          ariaLabel: "Uluru",
        });

        myLatlng = new google.maps.LatLng(
          data.binLocation.lat,
          data.binLocation.lon
        );
        lat_lng.push(myLatlng);
        const tempMarker = new google.maps.Marker({
          position: myLatlng,
          map: map,
          icon: "/images/dustbin.png",
        });

        marker = new google.maps.Marker({
          position: myLatlng,
          map: map,
          icon: "/images/dustbin.png",
        });
        console.log(marker);
        marker.addListener("click", () => {
          infowindow.open({
            anchor: tempMarker,
            map,
          });
        });
      }

      latlngbounds.extend(marker.position);
      // latlngbounds.extend(binMarker.position);
      // (function (depotMarker, data) {

      //     google.maps.event.addListener(depotMarker, "click", function (e) {
      //         infoWindow.setContent("Clicked depot");
      //         infoWindow.open(map, depotMarker);
      //     });
      // })(depotMarker, data);
      // (function (binMarker, data) {

      //     google.maps.event.addListener(binMarker, "click", function (e) {
      //         infoWindow.setContent("Clicked bin");
      //         infoWindow.open(map, binMarker);
      //     });
      // })(binMarker, data);

      // console.log("Lat Lng: ", lat_lng);
      for (var j = 0; j < lat_lng.length; j++) {
        if (j + 1 < lat_lng.length) {
          var src = lat_lng[j];
          var des = lat_lng[j + 1];
          // console.log("Source: "+ src + " Destination: "+ des);
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

  // Time Line Logic

  // Assuming 'timelineData' is an array containing the timeline data objects

  // Get the container element where you want to append the timeline

  const container = document.getElementById("timelineContainer");

  // Variable to store the HTML markup
  let html = "";
  let timelineData = routess.truck_routes;
  // Loop through the timeline data in pairs of two
  let count = 1;
  for (let i = 0; i < timelineData.length; i += 2) {
    // Open a row div
    html += '<div class="row">';

    // Add the first timeline item
    html += '<div class="col-md-6">';
    html += getTimelineItemHtml(timelineData[i]);
    html += "</div>";

    // Check if there's a second item available
    if (timelineData[i + 1]) {
      // Add the second timeline item
      html += '<div class="col-md-6">';
      html += getTimelineItemHtml(timelineData[i + 1]);
      html += "</div>";
    }

    // Close the row div
    html += "</div>";
  }

  // Set the HTML content of the container
  container.innerHTML = html;

  // Function to generate HTML markup for a timeline item
  function getTimelineItemHtml(item) {
    if(item.length==2){
      // return `<li>
      //                 <div class="timeline-dots timeline-dot1 border-primary text-primary"></div>
      //                 <h6 class="float-left mb-1">${item[0].depotName}</h6>
      //                 <small class="float-right mt-1">${item[0].depotLocation.lat}, ${item[0].depotLocation.lon}</small>
      //                 <div class="d-inline-block w-100">
      //                    <p>${item[0].depotLocation.formattedAddress}</p>
      //                    <p>Truck will not depart.</p>
      //                 </div>
      //              </li>`;
     return `<div class="card">
        <div class="card-header d-flex justify-content-between">
          <div div class="header-title" >
            <h4 class="card-title">Truck</h4>
          </div>
        </div>
        <div class="card-body">
          <div class="iq-timeline0 m-0 d-flex align-items-center justify-content-between position-relative">
            <ul class="list-inline p-0 m-0">
              <li>
                              <div class="timeline-dots timeline-dot1 border-primary text-primary"></div>
                              <h6 class="float-left mb-1">${item[0].depotName}</h6>
                              <small class="float-right mt-1">${item[0].depotLocation.lat}, ${item[0].depotLocation.lon}</small>
                              <div class="d-inline-block w-100">
                                 <p>${item[0].depotLocation.formattedAddress}</p>
                                 <p>Truck will not depart.</p>
                              </div>
                           </li>
            </ul>
          </div>
        </div>
      </div>`
    }else{
    const data = item
      .map((e, index) => {

    
        if (index == 0 || index == item.length - 1) {
          return `<li>
                          <div class="timeline-dots timeline-dot1 border-primary text-primary"></div>
                          <h6 class="float-left mb-1">${e.depotName}</h6>
                          <small class="float-right mt-1">${e.depotLocation.lat}, ${e.depotLocation.lon}</small>
                          <div class="d-inline-block w-100">
                             <p>${e.depotLocation.formattedAddress}</p>
                          </div>
                       </li>`;
                       
        } else {
          return `<li>
                              <div class="timeline-dots timeline-dot1 border-primary text-primary"></div>
                              <h6 class="float-left mb-1">${e._id}</h6>
                              <small class="float-right mt-1">${e.binLocation.lat}, ${e.binLocation.lon}</small>
                              <div class="d-inline-block w-100">
                                 <p>${e.binLocation.fotmattedAddress}</p>
                              </div>
                           </li>`;
          }
        })
        .join("");
    return `
          <div class="card">
              <div class="card-header d-flex justify-content-between">
                 <div div class="header-title" >
              <h4 class="card-title">Truck</h4>
                  </div>
              </div>
              <div class="card-body">
                  <div class="iq-timeline0 m-0 d-flex align-items-center justify-content-between position-relative">
                      <ul class="list-inline p-0 m-0">
                         ${data}
                      </ul>
                  </div>
              </div>
          </div>
      `;
    }

  
}
}