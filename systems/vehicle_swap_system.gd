class_name VehicleSwapSystem
extends Node


signal vehicle_activated(vehicle: Vehicle.VEHICLE_TYPE)

@export var spawners: Array[Spawner]

var spawnedVehicles: Dictionary = {}
var vehicles: Array[Vehicle] = []
var currentVehicle: Vehicle
var currentIndex: int = 0
var lastIndex


func spawn_all() -> void:
	for spawner in spawners:
		spawner.spawn()


func _ready():
	lastIndex = vehicles.size() - 1
	
	for spawner in spawners:
		spawner.vehicle_spawned.connect(handle_vehicle_spawned)


func _process(_delta) -> void:
	if vehicles.size() == 0:
		return
	
	var swap: int = VehicleController.get_character_swap()
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
			# set new current
			currentIndex = nextIndex
			
			# swap vehicle controls
			currentVehicle.isActive = false
			currentVehicle = vehicles[currentIndex]
			currentVehicle.isActive = true
			
			# notify change and pass the direction
			emit_signal("vehicle_activated", currentVehicle.currentType)


func handle_vehicle_spawned(spawner: Spawner) -> void:
	# if we have a vehicle, then swap it
	var vehicle = spawner.vehicle
	if spawnedVehicles.has(spawner):
		var index = spawnedVehicles.get(spawner)
		vehicles[index] = vehicle
	else:
		lastIndex += 1
		spawnedVehicles[spawner] = lastIndex
		vehicles.push_back(vehicle)
	
	if currentVehicle == null or !vehicles.has(currentVehicle):
		currentIndex = spawnedVehicles[spawner]
		currentVehicle = vehicle
		currentVehicle.isActive = true
