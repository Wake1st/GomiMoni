class_name Slider3D
extends Node3D


signal focused(slider: Slider3D)
signal value_changed(value: float)

const RAY_LENGTH := 1000
const UI_COLLISION_LAYER: int = 0b00000000_00000000_00000000_00000111
const PROGRESS_SIZE: float = 2.0
const SHIFT_AMOUNT: float = 0.1

@export_range(0,1) var initialValue = 0.5

@onready var shader: Shader = preload("res://ui/components/slider_3d/slider_3d.gdshader")
@onready var progressMesh: MeshInstance3D = $ProgressMesh
@onready var knob: SliderKnob3D = $SliderKnob3D

#var material: ShaderMaterial
var isSelectable: bool = false
#var isSelected: bool = false
var progressStart: Vector3
var progressEnd: Vector3


func _ready() -> void:
	# store the slider values
	progressStart = -Vector3(PROGRESS_SIZE/2, 0, 0)
	progressEnd = +Vector3(PROGRESS_SIZE/2, 0, 0)
	
	# set the initial position
	knob.position.x = (initialValue - 0.5) * PROGRESS_SIZE
	progressMesh.set_instance_shader_parameter("weight", initialValue)


func _physics_process(_delta) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && isSelectable:
		# get the mouse position relative to the slider
		var mousePos = get_mouse_world_position()
		if mousePos == null:
			return
		else:
			# set the shader color relative to the mouse position
			var relativeMouse = (mousePos - global_position) * global_basis
			set_slider(relativeMouse.x)


func adjust(value: float) -> void:
	var adjustment = knob.position.x + value * SHIFT_AMOUNT
	set_slider(adjustment)


func focus(value: bool = true) -> void:
	knob.highlight(value)


func set_slider(value: float) -> void:
	# calculate visual information
	var clamped = clamp(value, progressStart.x, progressEnd.x)
	var weight = inverse_lerp(progressStart.x, progressEnd.x, clamped)
	
	# display changes
	progressMesh.set_instance_shader_parameter("weight", weight)
	knob.position.x = (weight - 0.5) * PROGRESS_SIZE
	
	# notify listener
	emit_signal("value_changed", weight)


#region MouseHover

func _on_slider_knob_3d_mouse_entered():
	isSelectable = true
	focus()
	emit_signal("focused", self)


func _on_slider_knob_3d_mouse_exited():
	isSelectable = false

func _on_static_background_mouse_entered():
	isSelectable = true
	focus()
	emit_signal("focused", self)


func _on_static_background_mouse_exited():
	isSelectable = false

#endregion

#region Raycasting

# Returns raycast result after it hits an object in the world.
# @return Dictionary or null
func _do_raycast_on_mouse_position(collision_mask: int = UI_COLLISION_LAYER):
	# Raycast related code
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()
	
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end, collision_mask)
	var result = space_state.intersect_ray(query) # raycast result
	return result


# Gets ray-cast hit position from camera to world.
# @return Vector3 or null
func get_mouse_world_position(collision_mask: int = UI_COLLISION_LAYER):
	var raycast_result = _do_raycast_on_mouse_position(collision_mask)
	if raycast_result:
		return raycast_result.position
	return null

#endregion
