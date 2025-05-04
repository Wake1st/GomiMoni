class_name PriceBoard
extends Node3D


const MONI_CAP: float = 999.99

@onready var hundredsDisplay: NumberDisplay = $HundredsDisplay
@onready var tensDisplay: NumberDisplay = $TensDisplay
@onready var onesDisplay: NumberDisplay = $OnesDisplay
@onready var tenthsDisplay: NumberDisplay = $TenthsDisplay
@onready var hundredthsDisplay: NumberDisplay = $HundredthsDisplay


func set_cost(cost: float) -> void:
	# Im not covering 4 digits
	if cost > MONI_CAP:
		cost = MONI_CAP
	
	# first, we must calculate each digit
	var hundreds: int = floori(cost / 100)
	var tens: int = floori((cost - 100 * hundreds) / 10)
	var ones: int = cost as int - 100 * hundreds - 10 * tens
	var tenths = 10 * cost as int - 1000 * hundreds - 100 * tens - 10 * ones
	var hundredths = 100 * cost as int - 10000 * hundreds - 1000 * tens - 100 * ones - 10 * tenths
	
	# set each number in it's place
	hundredsDisplay.set_number(hundreds)
	tensDisplay.set_number(tens)
	onesDisplay.set_number(ones)
	tenthsDisplay.set_number(tenths)
	hundredthsDisplay.set_number(hundredths)
