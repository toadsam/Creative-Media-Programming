extends CharacterBody2D

# Shadow의 이전 프레임 위치 저장 변수
var shadow_previous_position = Vector2.ZERO

func _physics_process(delta):
	# Add the gravity.
	var shadow_velocity = global_position - shadow_previous_position
	
	if !is_on_floor():
		$ShadowAnim.play("Jump")
	elif shadow_velocity.x != 0:
		$ShadowAnim.flip_h = shadow_velocity.x < 0
		$ShadowAnim.play("Run")
	else:
		$ShadowAnim.play("Stand")
	
	# 현재 위치를 다음 프레임 비교를 위해 저장
	shadow_previous_position = global_position
	
	move_and_slide()
