class_name Level
extends Node3D


signal active
signal completed(m: float)

@export_category("Values")
@export var moni: float = 1
@export var cameraSize: float = 16

@export_category("Systems")
@export var swapSystem: VehicleSwapSystem
@export var puzzleSystem: PuzzleSystem
@export var lightingSystem: LightingSystem
@export var goal: Goal


func _ready() -> void:
	goal.goal_entered.connect(handle_goal_entered)
	lightingSystem.all_open.connect(handle_lighting_finished)


func setup(vehicleActivationCallback: Callable) -> void:
	swapSystem.vehicle_activated.connect(vehicleActivationCallback)


func run() -> void:
	# spawn the vehicles
	swapSystem.spawn_all()
	
	# ensure puzzles are set to unlocked
	if puzzleSystem != null:
		puzzleSystem.reset()
	
	# start the lighting process
	lightingSystem.run()


func reset() -> void:
	# reset the lighting too
	lightingSystem.reset()
	
	# re-run
	run()


func handle_lighting_finished() -> void:
	# allow vehicle controls
	VehicleController.isActive = true
	
	# notify listeners
	emit_signal("active")


func handle_goal_entered() -> void:
	# disable vehicle controls
	VehicleController.isActive = false
	
	# notify container
	emit_signal("completed", moni)
