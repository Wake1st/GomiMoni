extends Node3D


@onready var cinema_graph = $CinemaGraph

@onready var rootCamera = $CinemaGraph/RootCamera
@onready var creditsCamera = $CinemaGraph/CreditsCamera
@onready var settingsCamera = $CinemaGraph/SettingsCamera
@onready var selectionCamera = $CinemaGraph/SelectionCamera

@onready var rootCreditPath = $CinemaGraph/RootCreditPath
@onready var rootSettingsPath = $CinemaGraph/RootSettingsPath
@onready var rootSelectionPath = $CinemaGraph/RootSelectionPath

var isForward: bool = false


func _input(_event):
	if Input.is_key_pressed(KEY_1) and !isForward:
		cinema_graph.traverse(creditsCamera, true, rootCreditPath)
		isForward = true
	
	if Input.is_key_pressed(KEY_2) and !isForward:
		cinema_graph.traverse(settingsCamera, true, rootSettingsPath)
		isForward = true
		
	if Input.is_key_pressed(KEY_3) and !isForward:
		cinema_graph.traverse(selectionCamera, true, rootSelectionPath)
		isForward = true
	
	if Input.is_action_just_pressed("ui_accept") and isForward:
		cinema_graph.traverse(rootCamera, false)
		isForward = false
