class_name LevelContainer
extends Node3D


signal level_finished
signal main_selected

var highestLevelFinished: int = 0


func run(levelNumber: int = -1) -> void:
	print("run level: %s" % levelNumber)
	
	# if no number is given, play the next level
	if levelNumber < 0:
		print("setup highest level: ", highestLevelFinished + 1)
	else:
		print("setup given level: ", levelNumber)


func finished() -> void:
	print("finished level")
	
	highestLevelFinished += 1
	emit_signal("level_finished")
