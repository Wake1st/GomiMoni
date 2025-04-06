extends Node3D


@onready var shopOption: ShopOption = $ShopOption


func _ready():
	shopOption.selected.connect(handle_option_selected)
	


func handle_option_selected(option: ShopOption.OPTIONS) -> void:
	print("shop selection: %s" % option)
