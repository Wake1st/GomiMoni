class_name LevelOption
extends StaticBody3D


signal selected(number: int)

const HOVER_SHIFT: float = 0.4
const HOVER_DURATION: float = 0.1

@export_range(0, 5) var number: int = 0
@export var image: Texture2D

@onready var mesh = $Mesh

var hasFocus: bool = false
var basePosition: Vector3
var hoverPosition: Vector3
var tween: Tween


func _ready() -> void:
	# set the level image
	mesh.get_active_material(0).albedo_texture = image
	
	# set animation values
	basePosition = position
	hoverPosition = position + basis.z * HOVER_SHIFT


func setup(camera_position: Vector3) -> void:
	look_at(camera_position)


func _input(event) -> void:
	if event.is_action_pressed("ui_accept") && hasFocus:
		emit_signal("selected", number)
		
		# animate selection
		tween = create_tween()
		tween.tween_property(self, "position", basePosition, HOVER_DURATION)
		tween.tween_property(self, "position", hoverPosition, HOVER_DURATION)


func _on_mouse_entered():
	hasFocus = true
	
	# animate toward camera
	tween = create_tween()
	tween.tween_property(self, "position", hoverPosition, HOVER_DURATION)
	tween.set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	hasFocus = false
	
	# animate away from camera
	tween = create_tween()
	tween.tween_property(self, "position", basePosition, HOVER_DURATION)
	tween.set_ease(Tween.EASE_OUT)
