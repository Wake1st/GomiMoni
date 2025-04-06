extends Node3D


@onready var heavy = $Heavy


func _ready() -> void:
	heavy.isActive = true
