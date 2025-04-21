class_name Light
extends Node3D


const HEAVY = preload("res://assets/materials/heavy.tres")
const OFF_COLOR: Color = Color("#895c35")
const ON_COLOR: Color = Color("#b78f43")

@onready var bulb: MeshInstance3D = $light/model/bulb

var material: StandardMaterial3D
var isOn: bool = false


func _ready():
	material = HEAVY.duplicate()
	bulb.set_surface_override_material(0, material)


func flip(on: bool) -> void:
	if on:
		material.albedo_color = ON_COLOR
		material.emission_enabled = true
	else:
		material.albedo_color = OFF_COLOR
		material.emission_enabled = false
	
	bulb.set_surface_override_material(0, material)
	isOn = on


func toggle() -> void:
	if isOn:
		material.albedo_color = OFF_COLOR
		material.emission_enabled = false
	else:
		material.albedo_color = ON_COLOR
		material.emission_enabled = true
	
	bulb.set_surface_override_material(0, material)
	isOn = !isOn
