extends Area2D

class_name fountain

@onready var fin = $"../CanvasLayer/Gotonextstage"
static var isStage2 = false

func _on_body_entered(body: Node2D) -> void:
	fin.visible = true
	await get_tree().create_timer(3.0).timeout
	fin.visible = false
	#get_tree().change_scene_to_file("res://Parkjiheon/Background2.tscn")
	get_tree().change_scene_to_packed(preload("res://stage_2.tscn"))
	Player.stage = 2
