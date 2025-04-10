class_name PriceBoard
extends Node3D


@onready var tensMesh: NumberDisplay = $TensDisplay
@onready var onesMesh: NumberDisplay = $OnesDisplay
@onready var tenthsMesh: NumberDisplay = $TenthsDisplay
@onready var hundredthsMesh: NumberDisplay = $HundredthsDisplay


func set_cost(cost: float) -> void:
	# first, we must calculate each digit
	var tens: int = cost / 10
	var ones: int = cost as int - 10 * tens
	var tenths = 10 * cost as int - 100 * tens - 10 * ones
	var hundredths = 100 * cost as int - 1000 * tens - 100 * ones - 10 * tenths
	
	# set each number in it's place
	tensMesh.set_number(tens)
	onesMesh.set_number(ones)
	tenthsMesh.set_number(tenths)
	hundredthsMesh.set_number(hundredths)
