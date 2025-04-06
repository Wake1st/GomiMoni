extends Node3D


@onready var vehicle_swap_system: VehicleSwapSystem = $VehicleSwapSystem
@onready var gomi_spawner: Spawner = $GomiSpawner
@onready var flyer_spawner: Spawner = $FlyerSpawner
@onready var heavy_spawner: Spawner = $HeavySpawner


func _ready():
	vehicle_swap_system.vehicle_activated.connect(handle_vehicle_activated)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		vehicle_swap_system.spawn_all()


func handle_vehicle_activated(vehicle: Vehicle) -> void:
	print("vehicle activated: %s" % vehicle.name)
