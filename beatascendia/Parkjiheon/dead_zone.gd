extends Area2D

@onready var lab = $"../CanvasLayer/GameEnd"

#Dead Zone when Player fall down 
func _on_body_exited(body: Node2D) -> void:
	lab.visible = true
	await get_tree().create_timer(3.0).timeout
	lab.visible = false	
	get_tree().reload_current_scene()
	
	
