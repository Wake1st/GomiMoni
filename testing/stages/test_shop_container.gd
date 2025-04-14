extends Node3D

@onready var shopContainer = $ShopContainer


func _ready() -> void:
	TrashData.moni = 152.41
	shopContainer.shop_closed.connect(handle_shop_closed)
	shopContainer.open()


func _input(_event) -> void:
	if Input.is_key_pressed(KEY_R):
		shopContainer.open()


func handle_shop_closed(option: ShopOption.OPTIONS) -> void:
	print("shop closed! option: %s" % option)
