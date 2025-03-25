class_name Flyer
extends Vehicle


@export var updraft_strength: float = 100
@export var updraft_rate: float = 0.2

var draft_time: float


func _physics_process(delta):
	draft_time += delta
	
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
	var upward_force = Vector3.UP * updraft_strength * sin(updraft_rate * draft_time)
	apply_force(normal_force * strength + upward_force)
