extends Node3D


@onready var spawner_gomi = $SpawnerGomi
@onready var spawner_heavy = $SpawnerHeavy
@onready var spawner_flyer = $SpawnerFlyer


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		spawner_gomi.spawn()
		spawner_heavy.spawn()
		spawner_flyer.spawn()
