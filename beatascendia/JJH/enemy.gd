extends CharacterBody2D

@export var speed: float = 50.0  # 적의 이동 속도
@onready var player = get_parent().get_node("TestPlayer")  # 플레이어 노드
var is_paused: bool = false  # 적이 멈춰 있는지 확인하는 플래그

func _ready():
	# 절대 경로로 플레이어 찾기
	if not player:
		# 상대 경로로 시도
		player = $"../TestPlayer"  # 적과 같은 부모 아래에 있을 때
	if not player:
		# 트리에서 검색
		player = get_tree().get_root().find_node("TestPlayer", true, false)
	if player:
		print("Player found!")
	else:
		print("Player not found!")

func _physics_process(delta: float) -> void:
	if player and not is_paused:
		# 플레이어를 따라가기
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

	# 플레이어와의 충돌을 감지
	if player and global_position.distance_to(player.global_position) < 10.0 and not is_paused:  # 10은 거리(충돌 거리)
		on_player_collision()

func on_player_collision() -> void:
	if not is_paused:
		# 체력 감소 메시지 출력 (체력이 닿을 때마다 감소)
		print("플레이어의 체력이 깎입니다!")
		
		# 적이 멈추는 상태로 변경
		is_paused = true
		velocity = Vector2.ZERO  # 속도를 0으로 설정
		move_and_slide()  # 즉시 멈춤

		# 4초 대기 후 다시 움직임 가능
		call_deferred("resume_after_pause")

func resume_after_pause():
	await get_tree().create_timer(4.0).timeout
	is_paused = false
