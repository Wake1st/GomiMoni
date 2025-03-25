class_name Switch
extends Node3D


signal switch_thrown(isOn: bool)

@onready var animation_player = $model/AnimationPlayer

var isThrown: bool = false
var isSwitching: bool = false
var sensedFlyer: Flyer


func throw() -> void:
	# do not interfere when switching
	if isSwitching:
		return
	
	if isThrown:
		animation_player.play_backwards("flip-switch")
	else:
		animation_player.play("flip-switch")
	
	isSwitching = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "flip-switch":
		isThrown = !isThrown
		isSwitching = false
		emit_signal("switch_thrown", isThrown)


## Used to connect the flyer to this switch
## in preparation for turning on the switch
func _on_turn_on_area_body_entered(body):
	# do not interfere when switching
	if isSwitching:
		return
	
	# only sense a flyer when turned off
	if !isThrown and body is Flyer:
		throw()


## Used to connect the flyer to this switch
## in preparation for turning off the switch
func _on_turn_off_area_body_entered(body):
	# do not interfere when switching
	if isSwitching:
		return
	
	# only sense a flyer when turned on
	if isThrown and body is Flyer:
		throw()
