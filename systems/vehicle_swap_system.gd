class_name VehicleSwapSystem
extends Node


@export var spawners: Array[Spawner]

var spawnedVehicles: Dictionary = {}
var vehicles: Array[Vehicle] = []
var currentVehicle: Vehicle
var currentIndex: int = 0
var lastIndex


func _ready():
	lastIndex = vehicles.size() - 1
	
	for spawner in spawners:
		spawner.vehicle_spawned.connect(handle_vehicle_spawned)


func _process(_delta) -> void:
	if vehicles.size() == 0:
		return
	
	var swap = VehicleController.get_character_swap()
	if swap != 0:
		var nextIndex = currentIndex + swap
		
		if nextIndex < 0:
			nextIndex = lastIndex
		elif nextIndex > lastIndex:
			nextIndex = 0
		
		# if the current index is empty, bail
		if vehicles[nextIndex] == null:
			return
		else:
			currentIndex = nextIndex
		
		# swap vehicle controls
		currentVehicle.isActive = false
		currentVehicle = vehicles[currentIndex]
		currentVehicle.isActive = true
		
		print("vehicle swaped: %s", currentVehicle.name)


func handle_vehicle_spawned(spawner: Spawner) -> void:
	# if we have a vehicle, then swap it
	if spawnedVehicles.has(spawner):
		var index = spawnedVehicles.get(spawner)
		vehicles[index] = spawner.vehicle
	else:
		lastIndex += 1
		spawnedVehicles[spawner] = lastIndex
		vehicles.push_back(spawner.vehicle)
	
	if currentVehicle == null:
		currentVehicle = spawner.vehicle
		currentVehicle.isActive
