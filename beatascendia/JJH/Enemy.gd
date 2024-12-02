extends CharacterBody2D

# 속도 및 이동 범위 설정
@export var speed = 100           # 적의 이동 속도
@export var left_limit = -300     # 왼쪽 이동 한계점
@export var right_limit = 300     # 오른쪽 이동 한계점
var direction = 1                 # 이동 방향 (1: 오른쪽, -1: 왼쪽)

func _physics_process(delta):
	# 이동 처리
	velocity.x = speed * direction

	# 범위 제한 검사
	if global_position.x <= left_limit:
		direction = 1  # 오른쪽으로 전환
	elif global_position.x >= right_limit:
		direction = -1  # 왼쪽으로 전환

	# 충돌 감지
	if test_move(global_transform, velocity * delta):
		print("닿았습니다")  # 충돌 디버그 메시지 출력

	# 이동 실행
	move_and_slide()
