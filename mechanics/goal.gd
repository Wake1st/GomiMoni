class_name Goal
extends Node3D


signal goal_entered

@onready var trigger = $Trigger


func _on_trigger_body_entered(body):
	if typeof(body) == typeof(Vehicle):
		var vehicle = body as Vehicle
		if vehicle.currentType == Vehicle.VEHICLE_TYPE.GOMI:
			emit_signal("goal_entered")
