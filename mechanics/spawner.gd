class_name Spawner
extends Node3D


const GOMI_HEIGHT: float = 3.2
const HEAVY_HEIGHT: float = 2.8
const FLYER_HEIGHT: float = 0.8


@export var type: Vehicle.VEHICLE_TYPE


@onready var gomiScene: PackedScene = preload("res://vehicles/gomi.tscn")
@onready var heavyScene: PackedScene = preload("res://vehicles/heavy.tscn")
@onready var flyerScene: PackedScene = preload("res://vehicles/flyer.tscn")


var spawn_height: float = GOMI_HEIGHT
var vehicle: Vehicle


func spawn() -> void:
	if vehicle != null:
		remove_child(vehicle)
		vehicle = null
	
	match type:
		Vehicle.VEHICLE_TYPE.GOMI: 
			vehicle = gomiScene.instantiate()
			spawn_height = GOMI_HEIGHT
		Vehicle.VEHICLE_TYPE.HEAVY: 
			vehicle = heavyScene.instantiate()
			spawn_height = HEAVY_HEIGHT
		Vehicle.VEHICLE_TYPE.FLYER: 
			vehicle = flyerScene.instantiate()
			spawn_height = FLYER_HEIGHT
	
	add_child(vehicle)
	vehicle.position = Vector3(0.0, spawn_height, 0.0)
