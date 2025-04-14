class_name VehiclesInLevel
extends Node


static var vehicles: Dictionary = {
	0: VehicleUI.VEHICLES.GOMI,
	1: VehicleUI.VEHICLES.GOMI,
	2: VehicleUI.VEHICLES.GOMI_HEAVY,
	3: VehicleUI.VEHICLES.GOMI_HEAVY,
	4: VehicleUI.VEHICLES.GOMI_FLYER,
	5: VehicleUI.VEHICLES.GOMI_FLYER,
}


static func get_vehicles(level: int) -> VehicleUI.VEHICLES:
	return vehicles[level]
