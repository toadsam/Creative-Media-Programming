extends Area2D

@onready var fin = $"../CanvasLayer/Gotonextstage"




func _on_body_entered(body: Node2D) -> void:
	fin.visible = true
	await get_tree().create_timer(3.0).timeout
	fin.visible = false
	#get_tree().change_scene_to_file("res://Parkjiheon/Background2.tscn")
	get_tree().change_scene_to_packed(preload("res://Parkjiheon/Background2.tscn"))
