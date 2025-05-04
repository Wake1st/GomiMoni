class_name Button3D
extends MeshInstance3D


enum ANIMATION {
	FOCUS_GAIN,
	FOCUS_LOST,
	SELECT
}

signal focused(button: Button3D)

@export_category("Button")
@export var enabled: bool = true

@export_category("Animations")
@export_group("Focus", "")
@export var onFocusDepthChange: float
@export var gainedFocusAnimationDuration: float
@export var lostFocusAnimationDuration: float
@export_group("Selection", "")
@export var onSelectDepthChange: float
@export var onSelectDownAnimationDuration: float
@export var onSelectUpAnimationDuration: float

@export_category("Appearance")
@export var image: Texture2D

var hasFocus: bool = false
var isSelecting: bool = false

var basePosition: Vector3
var focusPosition: Vector3
var selectedPosition: Vector3
var tween: Tween


func _ready() -> void:
	# create a static body child
	create_trimesh_collision()
	
	# connect collision shape
	var staticBody: StaticBody3D = get_child(0)
	staticBody.mouse_entered.connect(_on_mouse_entered)
	staticBody.mouse_exited.connect(_on_mouse_exited)
	
	# set the level image
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = image
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	set_surface_override_material(0, material)
	
	# set animation values
	basePosition = position
	focusPosition = position + basis.z * onFocusDepthChange
	selectedPosition = position + basis.z * onSelectDepthChange


func setup(camera_position: Vector3 = Vector3.INF) -> void:
	# ensure the button is facing the camera
	if camera_position != Vector3.INF:
		look_at(camera_position)
	
	# reset the position
	position = basePosition


func select() -> void:
	send_select_signal()
	animate_button(ANIMATION.SELECT, true)


func send_select_signal() -> void:
	print("WARNING: non-implemented function 'send_select_signal' in class 'Button3D'")


func focus(value: bool = true) -> void:
	# try not to refocus
	if hasFocus && value:
		return
	
	hasFocus = value
	if hasFocus:
		animate_button(ANIMATION.FOCUS_GAIN)
		emit_signal("focused", self)
	else:
		animate_button(ANIMATION.FOCUS_LOST)


func animate_button(animation: ANIMATION, doesBounceBack: bool = false) -> void:
	match animation:
		ANIMATION.FOCUS_GAIN:
			# animate toward camera
			tween = create_tween()
			tween.tween_property(self, "position", focusPosition, gainedFocusAnimationDuration)
			tween.set_ease(Tween.EASE_OUT)
		ANIMATION.FOCUS_LOST:
			# animate away from camera
			tween = create_tween()
			tween.tween_property(self, "position", basePosition, lostFocusAnimationDuration)
			tween.set_ease(Tween.EASE_OUT)
		ANIMATION.SELECT:
			# animate away, then maybe toward the camera
			tween = create_tween()
			tween.tween_property(self, "position", selectedPosition, onSelectDownAnimationDuration)
			if doesBounceBack:
				tween.tween_property(self, "position", focusPosition, onSelectUpAnimationDuration)
			
			# ensure animation finished even if focus lost
			isSelecting = true
			tween.tween_callback(_handle_selection_animation_finished)


func _input(event) -> void:
	if enabled && hasFocus && event.is_action_pressed("ui_accept"):
		select()


func _on_mouse_entered():
	if enabled:
		hasFocus = true
		animate_button(ANIMATION.FOCUS_GAIN)
		emit_signal("focused", self)


func _on_mouse_exited():
	if enabled:
		hasFocus = false
		
		# only animate if selection is finished
		if !isSelecting:
			animate_button(ANIMATION.FOCUS_LOST)


func _handle_selection_animation_finished() -> void:
	# no longer need to flag
	isSelecting = false
	
	# ensure we return to normal
	if !hasFocus:
		animate_button(ANIMATION.FOCUS_LOST)
