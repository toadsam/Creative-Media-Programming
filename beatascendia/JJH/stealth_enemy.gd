extends CharacterBody2D

# 설정 가능한 변수
@export var move_distance: float = 200.0  # 왕복 이동 거리
@export var move_speed: float = 100.0     # 이동 속도
@export var visibility_duration: float = 2.0  # 가시 상태 지속 시간
@export var invisibility_duration: float = 2.0  # 은신 상태 지속 시간

# 텍스처 설정
@export var normal_texture: Texture  # 일반 상태 이미지
@export var stealth_texture: Texture  # 은신 상태 이미지

# 내부 변수
var start_position: Vector2  # 시작 위치 저장
var moving_right: bool = true  # 이동 방향
var is_visible: bool = true  # 현재 투명 여부 (기본값: 보임)
@onready var sprite: Sprite2D = $Sprite2D  # 스프라이트 참조

func _ready():
	start_position = global_position  # 시작 위치 저장
	toggle_visibility()  # 투명/가시 상태 반복 시작

func _physics_process(delta: float) -> void:
	# 이동 처리
	move_stealth_enemy(delta)

func move_stealth_enemy(delta: float) -> void:
	# 은신 상태면 이동 속도 2배
	var current_speed = move_speed * 2 if not is_visible else move_speed

	# 이동 거리 계산
	var direction = 1 if moving_right else -1
	global_position.x += direction * current_speed * delta

	# 방향 전환 시 이미지 반전
	if abs(global_position.x - start_position.x) > move_distance:
		moving_right = !moving_right  # 방향 반전
		sprite.flip_h = not sprite.flip_h  # 이미지 좌우 반전

func toggle_visibility():
	while true:
		# 가시 상태
		is_visible = true
		sprite.modulate.a = 1.0  # 알파 값 1 (완전히 보임)
		sprite.texture = normal_texture  # 일반 상태 이미지로 변경
		await get_tree().create_timer(visibility_duration).timeout

		# 은신 상태
		is_visible = false
		sprite.modulate.a = 0.2  # 알파 값 0.2 (거의 투명)
		sprite.texture = stealth_texture  # 은신 상태 이미지로 변경
		await get_tree().create_timer(invisibility_duration).timeout
