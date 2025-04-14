class_name Goal
extends Node3D


signal goal_entered

@onready var trigger = $Trigger


func _on_trigger_body_entered(_body):
	# only the Gomi's collision layer is checked
	emit_signal("goal_entered")
