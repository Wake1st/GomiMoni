extends Node3D

@onready var shopContainer = $ShopContainer


func _ready() -> void:
	shopContainer.shop_closed.connect(handle_shop_closed)


func _input(_event) -> void:
	if Input.is_key_pressed(KEY_R):
		shopContainer.open()


func handle_shop_closed(option: ShopOption.OPTIONS) -> void:
	print("shop closed! option: %s" % option)
