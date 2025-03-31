extends Node3D


@onready var levelScene: PackedScene = preload("res://mechanics/goal.tscn")
@onready var staging_system: StagingSystem = $StagingSystem

var isAtShop: bool = false


func _ready():
	staging_system.setup()


func _input(_event):
	if Input.is_key_pressed(KEY_1):
		if isAtShop:
			staging_system.shopContainer.close()
			isAtShop = false
		else:
			staging_system.levelContainer.leave()
			isAtShop = true
