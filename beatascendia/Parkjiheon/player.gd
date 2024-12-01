extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const Climpspeed = 100
var is_on_ladder = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_ladder:
			velocity.y = JUMP_VELOCITY
			is_on_ladder = false
		
		
	if is_on_wall() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		velocity.x = -sign(velocity.x)*SPEED
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	
	if is_on_ladder:
		velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			velocity.y = -Climpspeed
		if Input.is_action_pressed("ui_down"):
			velocity.y = Climpspeed			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false		
	elif Input.is_action_pressed("ui_left"):
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("stand")		

	move_and_slide()
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	is_on_ladder = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_on_ladder = false


func _on_ladder_body_entered(body: Node2D) -> void:
	is_on_ladder = true


func _on_ladder_middle_body_entered(body: Node2D) -> void:
	is_on_ladder = true


func _on_ladder_connect_body_entered(body: Node2D) -> void:
	is_on_ladder = true


func _on_ladder_middle_body_exited(body: Node2D) -> void:
	is_on_ladder = false


func _on_ladder_body_exited(body: Node2D) -> void:
	is_on_ladder = false


func _on_ladder_connect_body_exited(body: Node2D) -> void:
	is_on_ladder = false
