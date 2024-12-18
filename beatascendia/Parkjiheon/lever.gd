extends Area2D

var is_activated = false
var original_global_transform = Transform2D()

#lever for open doors
func _ready():
	original_global_transform = $Obstacle.global_transform


func _on_body_entered(body: Node2D) -> void:
	if not is_activated:
		rotation = rad_to_deg(-75.0)
		is_activated = true
		
		$Obstacle.global_transform = original_global_transform
		$Obstacle/AnimatedSprite2D.play("move_up")
		$Obstacle/CollisionShape2D.position.y -= 50
		
		
