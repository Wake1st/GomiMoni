class_name Basket
extends Node3D


signal basket_triggered

const BASKET_HEIGHT: float = -.571
const DROP_DISTANCE: float = 0.8

@export var drop_duration: float = 0.6

@onready var trigger = $trigger
@onready var basket = $basket

var tween: Tween
var isTriggered: bool = false


func _on_trigger_body_entered(body):
	if body is Vehicle:
		var vehicle = body as Vehicle
		if vehicle.currentType == Vehicle.VEHICLE_TYPE.HEAVY:
			emit_signal("basket_triggered")
			toggleOn()


func reset() -> void:
	isTriggered = false
	tween = null
	basket.position.y = BASKET_HEIGHT


func toggleOn() -> void:
	isTriggered = true
	tween = create_tween()
	tween.tween_property(basket, "position:y", -DROP_DISTANCE, drop_duration)
