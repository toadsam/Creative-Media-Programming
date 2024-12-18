extends Area2D

#Area2D for ladders

func _on_body_entered(body):
	if body is Player:
		Player.is_on_ladder = true
	elif body is Shadow:
		Shadow.is_on_ladder = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		Player.is_on_ladder = false
	elif body is Shadow:
		Shadow.is_on_ladder = false
