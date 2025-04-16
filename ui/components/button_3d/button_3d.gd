class_name Button3D
extends StaticBody3D


@export_category("Appearance")
@export var mesh: MeshInstance3D
@export var image: Texture2D

@export_category("Animations")
@export_group("Focus", "")
@export var onFocusDepthChange: float
@export var gainedFocusAnimationDuration: float
@export var lostFocusAnimationDuration: float
@export_group("Selection", "")
@export var onSelectDepthChange: float
@export var onSelectDownAnimationDuration: float
@export var onSelectUpAnimationDuration: float

@export_category("Button")
@export var enabled: bool = true

@onready var mesh_instance_3d = $MeshInstance3D

var hasFocus: bool = false
var isEnabled: bool = true

var basePosition: Vector3
var focusPosition: Vector3
var selectedPosition: Vector3
var tween: Tween


func _ready() -> void:
	# pass the mesh through
	mesh_instance_3d.mesh = mesh
	
	# set the level image
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = image
	mesh.set_surface_override_material(0, material)
	
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


func select_override() -> void:
	print("button is selected")


func _input(event) -> void:
	if event.is_action_pressed("ui_accept") && hasFocus:
		select_override()
		
		# animate selection
		tween = create_tween()
		tween.tween_property(self, "position", selectedPosition, onSelectDownAnimationDuration)
		tween.tween_property(self, "position", focusPosition, onSelectDownAnimationDuration)


func _on_mouse_entered():
	if isEnabled:
		hasFocus = true
		
		# animate toward camera
		tween = create_tween()
		tween.tween_property(self, "position", focusPosition, gainedFocusAnimationDuration)
		tween.set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	if isEnabled:
		hasFocus = false
		
		# animate away from camera
		tween = create_tween()
		tween.tween_property(self, "position", basePosition, lostFocusAnimationDuration)
		tween.set_ease(Tween.EASE_OUT)
