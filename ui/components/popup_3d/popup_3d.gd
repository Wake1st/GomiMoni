class_name PopUp3D
extends MeshInstance3D


@export var position_shift: Vector3
@export var tween_duration: float

@onready var timer: Timer = $Timer

var closedPosition: Vector3
var openedPosition: Vector3
var tween: Tween


func _ready():
	closedPosition = position
	openedPosition = closedPosition + position_shift


func on(duration: float = -1) -> void:
	# animate the pause menu
	tween = create_tween()
	tween.tween_property(self, "position", openedPosition, tween_duration)
	
	# if a duration is given, set the time of display
	if duration > 0:
		tween.tween_callback(_on_open_tween_finished.bind(duration))


func off() -> void:
	# animate the pause menu
	tween = create_tween()
	tween.tween_property(self, "position", closedPosition, tween_duration)


func _on_open_tween_finished(duration: float) -> void:
	timer.start(duration)


func _on_timer_timeout():
	timer.stop()
	off()
