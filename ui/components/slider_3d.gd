class_name Slider3D
extends Node3D


signal value_changed(value: float)

const RAY_LENGTH := 1000
const UI_COLLISION_LAYER: int = 0b00000000_00000000_00000000_00000111
const PROGRESS_SIZE: float = 2.0

@export_range(0,1) var initialValue = 0.5

@onready var shader: Shader = preload("res://ui/components/slider_3d.gdshader")
@onready var progressMesh: MeshInstance3D = $ProgressMesh
@onready var knob: StaticBody3D = $SliderKnob3D

var material: ShaderMaterial
var isSelectable: bool = false
var isSelected: bool = false
var progressStart: float
var progressEnd: float


func _ready() -> void:
	# store the slider values
	progressStart = position.x - PROGRESS_SIZE/2
	progressEnd = position.x + PROGRESS_SIZE/2
	
	# set the initial position
	material = progressMesh.get_active_material(0)
	material.set_shader_parameter("weight", initialValue)
	
	# notify listener
	emit_signal("value_changed", initialValue)


func _physics_process(_delta) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && isSelectable:
		# get the mouse position relative to the slider
		var mousePos: Vector3 = get_mouse_world_position()
		if mousePos == null:
			return
		else:
			# set the shader color relative to the mouse position
			var relativeMouse = mousePos * global_basis
			var clamped = clamp(relativeMouse.x, progressStart, progressEnd)
			var weight = inverse_lerp(progressStart, progressEnd, clamped)
			material.set_shader_parameter("weight", weight)
			
			# slide the knob
			knob.position.x = clamped
			
			# notify listener
			emit_signal("value_changed", weight)


#region MouseHover

func _on_slider_knob_3d_mouse_entered():
	isSelectable = true

func _on_slider_knob_3d_mouse_exited():
	isSelectable = false

func _on_static_background_mouse_entered():
	isSelectable = true

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
