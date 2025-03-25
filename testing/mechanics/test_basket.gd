extends Node3D


@onready var spawner: Spawner = $Spawner
@onready var basket: Basket = $Basket


func _ready():
	basket.triggered.connect(handle_basket_triggered)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		basket.reset()
		spawner.spawn()


func handle_basket_triggered() -> void:
	print("basket triggered!")
