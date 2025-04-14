extends Node3D


@onready var gomi = $Gomi


func _ready() -> void:
	VehicleController.isActive = true
	gomi.isActive = true
