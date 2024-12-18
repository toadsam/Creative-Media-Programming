extends Node2D

@onready var show = $CanvasLayer/Stage2
@onready var show2 = $CanvasLayer/Description

#Stage 2
func _ready() -> void:
	show.visible = true
	show2.visible = true
	await get_tree().create_timer(3.0).timeout
	show.visible = false
	show2.visible = false