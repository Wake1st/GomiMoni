class_name Flyer
extends Vehicle


@export var updraft_strength: float = 2
@export var updraft_rate: float = 5

var draft_time: float


func move(normal_force: Vector3) -> void:
	var upward_force = Vector3.UP * updraft_strength * sin(updraft_rate * draft_time)
	apply_force(normal_force * strength + upward_force)
