class_name Vehicle
extends RigidBody3D

enum VEHICLE_TYPE {
	GOMI,
	HEAVY,
	FLYER
}


@export var strength: float = 1.0


var currentType: VEHICLE_TYPE


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
				var force = Extensions.into_vector3(direction) * strength * delta
				apply_force(force, Vector3.UP)
