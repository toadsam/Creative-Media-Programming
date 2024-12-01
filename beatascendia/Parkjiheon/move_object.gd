extends CharacterBody2D

var direction = 1

func _physics_process(delta: float) -> void:
	velocity.y = 0
	
	if $RayCast2D.is_colliding():
		direction = direction * -1
		$RayCast2D.target_position.x = abs($RayCast2D.target_position.x) * direction
		
	velocity.x = 100 * direction
	
	move_and_slide()
