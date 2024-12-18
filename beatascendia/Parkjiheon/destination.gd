extends Area2D


@onready var fin = $"../CanvasLayer/Finish"

func _on_body_entered(body: Node2D) -> void:
	fin.visible = true
	await get_tree().create_timer(4.0).timeout
	fin.visible = false
	get_tree().quit()
