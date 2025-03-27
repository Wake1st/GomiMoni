extends Node3D


@onready var vehicle_swap_system = $VehicleSwapSystem
@onready var gomi_spawner = $GomiSpawner
@onready var flyer_spawner = $FlyerSpawner
@onready var heavy_spawner = $HeavySpawner


func _ready():
	vehicle_swap_system.vehicle_activated.connect(handle_vehicle_activated)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		gomi_spawner.spawn()
		flyer_spawner.spawn()
		heavy_spawner.spawn()


func handle_vehicle_activated(vehicle: Vehicle) -> void:
	print("vehicle activated: %s" % vehicle.name)
