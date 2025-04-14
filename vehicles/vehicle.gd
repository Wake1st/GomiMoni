class_name Vehicle
extends RigidBody3D


enum VEHICLE_TYPE {
	GOMI,
	HEAVY,
	FLYER
}

@export var strength: float = 80.0
@export var currentType: VEHICLE_TYPE

var isActive:bool = false


func _init():
	can_sleep = false


func _physics_process(delta):
	if !isActive:
		return
	
	var direction = VehicleController.get_movement()
	if direction != Vector2.ZERO:
		move(Extensions.into_vector3(direction) * delta)


func move(normal_force: Vector3) -> void:
		apply_force(normal_force * strength, Vector3.UP)
