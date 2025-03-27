extends Node3D


@onready var flyer = $Flyer


func _ready() -> void:
	flyer.isActive = true
