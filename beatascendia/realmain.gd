extends Node2D

@onready var start_scene = $StartScene
@onready var stage1_scene = $Main
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage1_scene.process_mode = PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if start_scene.button == 1:
		start_scene.process_mode = Node.PROCESS_MODE_DISABLED
		start_scene.hide()
		stage1_scene.process_mode = PROCESS_MODE_ALWAYS
	
	
	elif start_scene.button == 3:
		get_tree().quit()
