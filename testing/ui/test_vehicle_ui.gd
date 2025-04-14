extends Node3D


@onready var vehicleUI: VehicleUI = $VehicleUI

var currentVehicle: Vehicle.VEHICLE_TYPE


func _input(_event):
	if Input.is_key_label_pressed(KEY_1):
		vehicleUI.display(Vehicle.VEHICLE_TYPE.GOMI)
	elif Input.is_key_label_pressed(KEY_2):
		vehicleUI.display(Vehicle.VEHICLE_TYPE.HEAVY)
	elif Input.is_key_label_pressed(KEY_3):
		vehicleUI.display(Vehicle.VEHICLE_TYPE.FLYER)
