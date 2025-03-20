extends Node3D


@onready var spawner_gomi: Spawner = $SpawnerGomi
@onready var spawner_heavy: Spawner = $SpawnerHeavy
@onready var spawner_flyer: Spawner = $SpawnerFlyer


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		spawner_gomi.spawn()
		spawner_heavy.spawn()
		spawner_flyer.spawn()
