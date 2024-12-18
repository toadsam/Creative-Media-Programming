extends Node2D  # 움직이는 물체의 노드 타입 (Sprite2D, Node2D 등 사용 가능)

@export var move_distance: float = 200.0  # 이동할 거리
@export var move_speed: float = 400.0  # 이동 속도
@export var wait_time: float = 0.3  # 시작 위치로 돌아오기 전 대기 시간

var start_position: Vector2  # 시작 위치
var moving_right: bool = true  # 현재 이동 방향
var current_distance: float = 0.0  # 현재 이동한 거리

@onready var player = get_parent().get_node("TestPlayer")  # 플레이어 노드

func _ready():
	# 초기 위치 저장
	start_position = global_position
	# 플레이어 노드 찾기
	player = get_node_or_null("/root/Main(JJH)/TestPlayer")
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

func _process(delta: float):
	if moving_right:
		# 오른쪽으로 이동
		var move_amount = move_speed * delta
		global_position.x += move_amount
		current_distance += move_amount

		# 이동 거리 초과 시
		if current_distance >= move_distance:
			moving_right = false
			current_distance = 0.0
			await_to_start_position()

	# 플레이어와 충돌 감지
	if player and global_position.distance_to(player.global_position) < 10.0:  # 충돌 범위
		print("플레이어한테 닿았습니다!")

func await_to_start_position():
	# 일정 시간 대기 후 처음 위치로 돌아가기
	await get_tree().create_timer(wait_time).timeout
	global_position = start_position
	moving_right = true
