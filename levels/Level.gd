class_name Level
extends Node3D


signal completed(moni: float)

@export var moni: float = 1
@export var swapSystem: VehicleSwapSystem
@export var goal: Goal

var isActive: bool = false


func _ready() -> void:
	goal.goal_entered.connect(handle_goal_entered)
	swapSystem.vehicle_activated.connect(handle_vehicle_activated)


func run() -> void:
	# allow vehicle controls
	VehicleController.isActive = true
	
	# spawn the vehicles
	swapSystem.spawn_all()


func reset() -> void:
	# re-run
	run()


func handle_vehicle_activated(vehicle: Vehicle) -> void:
	print("vehicle activated: %s" % vehicle.name)


func handle_goal_entered() -> void:
	# disable vehicle controls
	VehicleController.isActive = false
	
	# notify container
	emit_signal("completed", moni)
