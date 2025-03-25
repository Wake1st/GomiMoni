class_name CinemaGraph
extends Node


enum STILLS {
	ROOT,
	CREDITS,
	SETTINGS,
	SELECTION
}


@export var rootShot: Camera3D
@export var creditShot: Camera3D
@export var settingShot: Camera3D
@export var selectionShot: Camera3D
