class_name Level
extends Node3D


signal completed(moni: float)

@export var moni: float = 1
@export var spawners: Array[Spawner] = []
@export var goal: Goal

var isActive: bool = false


func _ready() -> void:
	goal.goal_entered.connect(handle_goal_entered)


func run() -> void:
	# allow vehicle controls
	VehicleController.isActive = true
	
	# spawn the vehicles
	for spawner in spawners:
		spawner.spawn()


func reset() -> void:
	# cleanup
	
	# re-run
	run()


func handle_goal_entered() -> void:
	# disable vehicle controls
	VehicleController.isActive = false
	
	# notify container
	emit_signal("completed", moni)
