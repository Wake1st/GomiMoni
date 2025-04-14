class_name Main
extends Node3D


@onready var stagingSystem: StagingSystem = $StagingSystem


func _ready():
	stagingSystem.setup()
