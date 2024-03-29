from django.shortcuts import render
from rest_framework.response import Response
import requests
from rest_framework.decorators import (
    api_view,
    renderer_classes,
    permission_classes,
    parser_classes,
)
import json
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser

# Create your views here.

total_all_truck_routes_details = []
resultant_data = {}
@api_view(("GET", "POST"))
def getRouteData(request):
    
    try:
    #  print(request.data)
     total_all_truck_routes_details.clear()
     resultant_data.clear()
     data=request.data
     distance_matrix_data={}
     address=[]
     fill_levels=[]
     distance_matrix_data['API_key'] = 'AIzaSyBw7fIXJz5sA9IEcczMJ9FIzK91jvFIsno'
     firstOBJ= requests.get("http://192.168.131.208:4000/depot/getAllDepots")
     print("helloo djn")
     print(firstOBJ.json())
     address.append(firstOBJ.json()[0]['depotLocation']['formattedAddress'].replace(", ","+"))
     fill_levels.append(0
                        )
    
     
     for x in data:
         
         address.append(x['binLocation']['fotmattedAddress'].replace(", ","+"))
         fill_levels.append(x['binFillLevel'])
    #  print(fill_levels)
     distance_matrix_data['addresses']=address
     data={}
     data['fill_levels']= fill_levels
     data['distance_matrix']=create_distance_matrix(distance_matrix_data)
     
     data["truck_capacities"] = [10, 10, 10,10]
     data["num_trucks"] = 4
     data["garbage_depot"] = 0
     print("niche")
     getFinalResult(data, firstOBJ.json(),request.data, )
     
     return Response(resultant_data)
    except Exception as e:
        print(e)
        return Response(data)
 

     
  
  
@api_view(("GET","POST"))
def getFirstOBJ(request):
    return Response([
    {
        "_id": "660454e69ffb0d49a41574de",
        "depotName": "Pune Garbage Depot",
        "depotLocation": {
            "lat": 18.525003,
            "lon": 73.855504,
            "formattedAddress": "GVG4+26C, Tophakhana, Shivajinagar, Pune, Maharashtra 411005, India"
        },
        "depotCapacity": None,
        "createdDate": "2024-03-27T17:18:30.939Z"
    }
])    
    
import requests
import json
import urllib.request




def create_distance_matrix(data):
  addresses = data["addresses"]
  API_key = data["API_key"]
  # Distance Matrix API only accepts 100 elements per request, so get rows in multiple requests.
  max_elements = 100
  num_addresses = len(addresses) # 16 in this example.
  # Maximum number of rows that can be computed per request (6 in this example).
  max_rows = max_elements // num_addresses
  # num_addresses = q * max_rows + r (q = 2 and r = 4 in this example).
  q, r = divmod(num_addresses, max_rows)
  dest_addresses = addresses
  distance_matrix = []
  # Send q requests, returning max_rows rows per request.
  for i in range(q):
    origin_addresses = addresses[i * max_rows: (i + 1) * max_rows]
    response = send_request(origin_addresses, dest_addresses, API_key)
    distance_matrix += build_distance_matrix(response)

  # Get the remaining remaining r rows, if necessary.
  if r > 0:
    origin_addresses = addresses[q * max_rows: q * max_rows + r]
    response = send_request(origin_addresses, dest_addresses, API_key)
    distance_matrix += build_distance_matrix(response)
  return distance_matrix

def send_request(origin_addresses, dest_addresses, API_key):
  """ Build and send request for the given origin and destination addresses."""
  def build_address_str(addresses):
    # Build a pipe-separated string of addresses
    address_str = ''
    for i in range(len(addresses) - 1):
      address_str += addresses[i] + '|'
    address_str += addresses[-1]
    return address_str

  request = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial'
  origin_address_str = build_address_str(origin_addresses)
  dest_address_str = build_address_str(dest_addresses)
  request = request + '&origins=' + origin_address_str + '&destinations=' + \
                       dest_address_str + '&key=' + API_key
  # jsonResult = urllib.urlopen(request).read()
  response = requests.get(request)

  # response = json.loads(jsonResult)
  response = requests.get(request)

  return response

def build_distance_matrix(response):
    response_data = response.json()  # Extract JSON data from the response
    distance_matrix = []
    for row in response_data['rows']:
        row_list = [row['elements'][j]['distance']['value'] for j in range(len(row['elements']))]
        distance_matrix.append(row_list)
    return distance_matrix
        


"""Capacited Vehicles Routing Problem (CVRP)."""

from ortools.constraint_solver import routing_enums_pb2
from ortools.constraint_solver import pywrapcp








def print_solution(data, manager, routing, solution, depot_data, all_bin_data):
    """Prints solution on console."""
    print(f"Objective: {solution.ObjectiveValue()}")
    total_distance = 0
    total_load = 0
    all_truck_nodes = []

    for vehicle_id in range(data["num_trucks"]):
        index = routing.Start(vehicle_id)
        plan_output = f"Route for vehicle {vehicle_id}:\n"
        route = []
        route_array = []
        route_distance = 0
        route_load = 0
        while not routing.IsEnd(index):
            node_index = manager.IndexToNode(index)
            route_load += data["fill_levels"][node_index]
            if(node_index==0):
                route_array.append(depot_data[0]) 
            else:
               if(data['fill_levels'][node_index]>0):  
                route_array.append(all_bin_data[node_index-1])
               
            route.append(node_index)
            plan_output += f" {node_index} Load({route_load}) -> "
            previous_index = index
            index = solution.Value(routing.NextVar(index))
            route_distance += routing.GetArcCostForVehicle(
                previous_index, index, vehicle_id
            )
            
        route.append(0)
        route_array.append(depot_data[0])
        total_all_truck_routes_details.append(route_array)
        all_truck_nodes.append(route)
        plan_output += f" {manager.IndexToNode(index)} Load({route_load})\n"
        plan_output += f"Distance of the route: {route_distance}m\n"
        plan_output += f"Load of the route: {route_load}\n"
        print(plan_output)
        total_distance += route_distance
        total_load += route_load
    # print("Mit Shah\n\n\n")
    # print(total_all_truck_routes_details)
    # resultant_data = {
        # "total_distance": total_distance,
        # "total_garbage_picked": total_load,
        # "truck_routes": total_all_truck_routes_details,
        
    # }
    resultant_data.update({    "total_distance": total_distance,
        "total_garbage_picked": total_load,
        "truck_routes": total_all_truck_routes_details})
    print(f"Total distance of all routes: {total_distance}m")
    print(f"Total load of all routes: {total_load}")


def getFinalResult(data, depot_data, all_bin_data):
   
    
    # Create the routing index manager.
    manager = pywrapcp.RoutingIndexManager(
        len(data["distance_matrix"]), data["num_trucks"], data["garbage_depot"]
    )

    # Create Routing Model.
    routing = pywrapcp.RoutingModel(manager)

    # Create and register a transit callback.
    def distance_callback(from_index, to_index):
        """Returns the distance between the two nodes."""
        # Convert from routing variable Index to distance matrix NodeIndex.
        from_node = manager.IndexToNode(from_index)
        to_node = manager.IndexToNode(to_index)
        return data["distance_matrix"][from_node][to_node]

    transit_callback_index = routing.RegisterTransitCallback(distance_callback)

    # Define cost of each arc.
    routing.SetArcCostEvaluatorOfAllVehicles(transit_callback_index)

    # Add Capacity constraint.
    def demand_callback(from_index):
        """Returns the demand of the node."""
        # Convert from routing variable Index to fill_levels NodeIndex.
        from_node = manager.IndexToNode(from_index)
        return data["fill_levels"][from_node]

    demand_callback_index = routing.RegisterUnaryTransitCallback(demand_callback)
    routing.AddDimensionWithVehicleCapacity(
        demand_callback_index,
        0,  # null capacity slack
        data["truck_capacities"],  # vehicle maximum capacities
        True,  # start cumul to zero
        "Capacity",
    )

    # Setting first solution heuristic.
    search_parameters = pywrapcp.DefaultRoutingSearchParameters()
    search_parameters.first_solution_strategy = (
        routing_enums_pb2.FirstSolutionStrategy.PATH_CHEAPEST_ARC
    )
    search_parameters.local_search_metaheuristic = (
        routing_enums_pb2.LocalSearchMetaheuristic.GUIDED_LOCAL_SEARCH
    )
    search_parameters.time_limit.FromSeconds(1)

    # Solve the problem.
    solution = routing.SolveWithParameters(search_parameters)
    
    # Print solution on console.
    if solution:
        print_solution(data, manager, routing, solution, depot_data, all_bin_data)


