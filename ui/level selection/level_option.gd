class_name LevelOption
extends StaticBody3D


signal selected(number: int)

const HOVER_SHIFT: float = 0.4
const HOVER_DURATION: float = 0.1
const MASK_COLOR: Color = Color("#3054729c")

@export_range(0, 5) var number: int = 0
@export var image: Texture2D

@onready var mesh: MeshInstance3D = $Mesh

var isEnabled: bool = false

var hasFocus: bool = false
var basePosition: Vector3
var hoverPosition: Vector3
var tween: Tween


func _ready() -> void:
	# set the level image
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = image
	mesh.set_surface_override_material(0, material)
	
	# set up a disabled mask
	#var mask: StandardMaterial3D = StandardMaterial3D.new()
	#mask.albedo_color = MASK_COLOR
	#mask.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#mesh.material_override = mask
	
	# set animation values
	basePosition = position
	hoverPosition = position + basis.z * HOVER_SHIFT


func setup(camera_position: Vector3) -> void:
	look_at(camera_position)


func enable(value: bool) -> void:
	isEnabled = value
	
	#var mask: StandardMaterial3D = mesh.material_override
	#if isEnabled:
		## set a mask on
		#mask.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	#else:
		#mask.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#mesh.material_override = mask


func _input(event) -> void:
	if isEnabled && event.is_action_pressed("ui_accept") && hasFocus:
		emit_signal("selected", number)
		
		# animate selection
		tween = create_tween()
		tween.tween_property(self, "position", basePosition, HOVER_DURATION)
		tween.tween_property(self, "position", hoverPosition, HOVER_DURATION)


func _on_mouse_entered():
	# ensure level is clickable
	if isEnabled:
		hasFocus = true
		
		# animate toward camera
		tween = create_tween()
		tween.tween_property(self, "position", hoverPosition, HOVER_DURATION)
		tween.set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	# ensure level is clickable
	if isEnabled:
		hasFocus = false
		
		# animate away from camera
		tween = create_tween()
		tween.tween_property(self, "position", basePosition, HOVER_DURATION)
		tween.set_ease(Tween.EASE_OUT)
