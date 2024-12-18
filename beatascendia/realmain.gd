extends Node2D

@onready var start_scene = $StartScene
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if start_scene.button == 1:
		start_scene.process_mode = Node.PROCESS_MODE_DISABLED
		start_scene.hide()
		get_tree().change_scene_to_packed(preload("res://stage_1.tscn"))
		Player.stage = 1
	
	elif start_scene.button == 3:
		get_tree().quit()
