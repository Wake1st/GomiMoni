extends Node3D


@onready var gomi = $Gomi


func _ready() -> void:
	gomi.isActive = true
