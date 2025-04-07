class_name Basket
extends Key


const BASKET_HEIGHT: float = -.571
const DROP_DISTANCE: float = 0.8

@export var drop_duration: float = 0.6

@onready var trigger: Area3D = $trigger
@onready var basket = $basket

var tween: Tween
var isTriggered: bool = false


func check() -> bool:
	return isTriggered


func reset() -> void:
	isTriggered = false
	tween = null
	basket.position.y = BASKET_HEIGHT


func toggleOn() -> void:
	isTriggered = true
	tween = create_tween()
	tween.tween_property(basket, "position:y", -DROP_DISTANCE, drop_duration)
	tween.tween_callback(handle_drop_callback)


func handle_drop_callback() -> void:
	emit_signal("triggered")


func _on_trigger_body_entered(_body):
	# only the heavy layer is checked
	toggleOn()
