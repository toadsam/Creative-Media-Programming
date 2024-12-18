extends Area2D

@export var idle_texture: Texture  # 평소 상태 이미지
@export var countdown_textures: Array[Texture]  # 카운트다운 이미지들
@export var explosion_texture: Texture  # 폭발 이미지
@export var countdown_time: float = 3.0  # 카운트다운 시간
@export var respawn_time: float = 3.0  # 재생성 시간

var is_counting_down: bool = false  # 카운트다운 여부
var countdown_timer: float = 0.0  # 카운트다운 타이머
var scale_speed: float = 0.3  # 폭발 커지는 속도
var original_position: Vector2  # 시작 위치 저장
var current_texture_index: int = 0  # 카운트다운 이미지 인덱스

@onready var sprite = $Sprite2D  # Sprite2D 참조
@onready var collision_shape = $CollisionShape2D  # 충돌 콜라이더
@onready var timer = $Timer  # 재생성 타이머 참조

func _ready():
	sprite.texture = idle_texture  # 평소 상태 이미지
	original_position = global_position  # 원래 위치 저장
	timer.wait_time = respawn_time  # 재생성 시간 설정

func _process(delta):
	if is_counting_down:
		# 카운트다운 중 이미지 번갈아 표시
		countdown_timer += delta
		if countdown_timer > 0.2:  # 이미지 전환 속도
			current_texture_index = (current_texture_index + 1) % countdown_textures.size()
			sprite.texture = countdown_textures[current_texture_index]
			countdown_timer = 0.0

		# 카운트다운 완료 시 폭발
		countdown_time -= delta
		if countdown_time <= 0:
			explode()

func _on_body_entered(body):
	if not is_counting_down and body.name == "TestPlayer":
		is_counting_down = true

func explode():
	# 폭발 상태로 변경
	sprite.texture = explosion_texture
	is_counting_down = false
	countdown_time = 3.0
	sprite.scale = Vector2(0.5, 0.5)
	collision_shape.disabled = true  # 충돌 비활성화

	# 점점 커지는 애니메이션
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(_on_explosion_complete)

func _on_explosion_complete():
	sprite.visible = false  # 폭발 후 숨김
	timer.start()  # 재생성 타이머 시작

func _on_Timer_timeout():
	# 폭탄 재생성
	global_position = original_position  # 원래 위치로 돌아감
	sprite.visible = true  # 스프라이트 다시 보이게 설정
	sprite.texture = idle_texture  # 평소 상태 이미지로 되돌림
	collision_shape.disabled = false  # 충돌 활성화
	sprite.scale = Vector2(0.1, 0.1)  # 스프라이트 크기 초기화
	is_counting_down = false  # 카운트다운 상태 초기화
