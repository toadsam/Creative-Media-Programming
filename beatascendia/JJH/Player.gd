extends CharacterBody2D

# 속도 및 물리 설정
const SPEED = 200          # 좌우 이동 속도
const JUMP_FORCE = -400    # 점프 힘
const GRAVITY = 800        # 중력

func _physics_process(delta):
	# 중력 적용
	velocity.y += GRAVITY * delta

	# 좌우 이동 처리
	velocity.x = 0  # 초기화
	if Input.is_action_pressed("move_left"): # 왼쪽 이동
		velocity.x -= SPEED
	if Input.is_action_pressed("move_right"): # 오른쪽 이동
		velocity.x += SPEED

	# 점프 처리
	if is_on_floor() and Input.is_action_just_pressed("jump"): # 점프 키
		velocity.y = JUMP_FORCE

	# 이동 및 충돌 처리
	move_and_slide()
