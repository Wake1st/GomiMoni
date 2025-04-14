class_name Switch
extends Key


@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var switchSFX = $SwitchSFX

var isThrown: bool = false
var isSwitching: bool = false
var sensedFlyer: Flyer


func check() -> bool:
	return isThrown


func reset() -> void:
	if isThrown:
		animation_player.stop()
		isThrown = false


func throw() -> void:
	# do not interfere when switching
	if isSwitching:
		return
	
	if isThrown:
		animation_player.play_backwards("flip-switch")
	else:
		animation_player.play("flip-switch")
	
	# ensures no interferance
	isSwitching = true
	
	# play sound for feedback
	switchSFX.play()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "flip-switch":
		isThrown = !isThrown
		isSwitching = false
		emit_signal("triggered")


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
