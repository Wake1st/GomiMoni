extends Node3D


@onready var goal: Goal = $Goal
@onready var spawner: Spawner = $Spawner


func _ready():
	goal.goal_entered.connect(handle_goal_entered)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		spawner.spawn()


func handle_goal_entered() -> void:
	print("Goal Entered!")
