extends CharacterBody2D


var direction = 1

func _physics_process(delta: float) -> void:
	velocity.x = 0
	
	if $RayCast2D.is_colliding():
		direction = direction * -1
		$RayCast2D.target_position.y = abs($RayCast2D.target_position.y) * direction
		
	velocity.y = 100 * direction
	
	move_and_slide()
