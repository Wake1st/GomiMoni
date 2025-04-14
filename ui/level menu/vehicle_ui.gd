class_name VehicleUI
extends Node3D


const TWEEN_DURATION: float = 0.1
const FORWARD_LENGTH: float = 0.04

@onready var gomi: MeshInstance3D = $Gomi
@onready var heavy: MeshInstance3D = $Heavy
@onready var flyer: MeshInstance3D = $Flyer

var currentMesh: MeshInstance3D
var tween: Tween


func _ready():
	gomi.position.z = FORWARD_LENGTH
	currentMesh = gomi


func display(vehicle: Vehicle.VEHICLE_TYPE) -> void:
	# shift the current away
	tween = create_tween()
	tween.tween_property(currentMesh, "position:z", 0, TWEEN_DURATION)
	
	# set the new current vehicle
	match vehicle:
		Vehicle.VEHICLE_TYPE.GOMI:
			currentMesh = gomi
		Vehicle.VEHICLE_TYPE.HEAVY:
			currentMesh = heavy
		Vehicle.VEHICLE_TYPE.FLYER:
			currentMesh = flyer
	
	# bring the new into view
	tween.parallel()
	tween.tween_property(currentMesh, "position:z", FORWARD_LENGTH, TWEEN_DURATION)
