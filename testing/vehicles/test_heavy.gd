extends Node3D


@onready var heavy = $Heavy


func _ready() -> void:
	VehicleController.isActive = true
	heavy.isActive = true
