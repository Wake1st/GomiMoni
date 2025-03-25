class_name Vehicle
extends RigidBody3D

enum VEHICLE_TYPE {
	GOMI,
	HEAVY,
	FLYER
}


@export var strength: float = 80.0
@export var currentType: VEHICLE_TYPE


func _init():
	can_sleep = false


func _physics_process(delta):
	if VehicleController.get_menu_select():
		get_tree().paused = true
		
		# open the pause menu
		
	else:
		var swap = VehicleController.get_character_swap()
		if swap != 0:
			currentType = (currentType + swap) as VEHICLE_TYPE
			
			# must swap the scene itself
			
		else:
			var direction = VehicleController.get_movement()
			if direction != Vector2.ZERO:
				move(Extensions.into_vector3(direction) * delta)


func move(normal_force: Vector3) -> void:
		apply_force(normal_force * strength, Vector3.UP)
