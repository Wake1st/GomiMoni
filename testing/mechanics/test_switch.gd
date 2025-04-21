extends Node3D


@export var flyer_strength: float = 10

@onready var switch: Switch = $Switch
@onready var on_spawner = $OnSpawner
@onready var off_spawner = $OffSpawner

var flyer: Flyer
var switchThrown: bool = false


func _ready():
	switch.triggered.connect(handle_switch_thrown)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if switchThrown:
			flyer = off_spawner.spawn() as Flyer
			
			# move the flyer toward the switch
			flyer.apply_impulse(Vector3.LEFT * flyer_strength)
		else:
			flyer = on_spawner.spawn() as Flyer
			
			# move the flyer toward the switch
			flyer.apply_impulse(Vector3.RIGHT * flyer_strength)


func handle_switch_thrown() -> void:
	switchThrown = !switchThrown
	
	var switch_position: String = "on" if switchThrown else "off"
	print("Switch is %s" % switch_position)
