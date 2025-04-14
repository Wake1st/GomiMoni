extends Node3D


@onready var flyer = $Flyer


func _ready() -> void:
	VehicleController.isActive = true
	flyer.isActive = true
