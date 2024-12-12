extends CharacterBody2D

class_name Player

@export var speed = 200  # 플레이어 이동 속도
@export var jumpPower = -500  # 플레이어 점프력
@export var wallJumpPower = Vector2(-150, -300)  # 벽 점프 방향과 힘 (x, y)
@export var coolTime = 5000.0  # 시간 되감기 능력 쿨타임(ms)
@export var health = 100

@onready var shadow = get_parent().get_node("Shadow")

var prePosition = []  # 플레이어의 이전 좌표를 저장하는 배열
var timeDelay = 3000.0  # Shadow가 따라할 시간 간격(ms)
var recordInterval = 10.0  # 좌표를 기록하는 간격(ms)
var lastRecordTime = 0.0  # 마지막으로 기록한 시간
var abilityStartTime = 0.0  # 능력 발동 시작 시간
var isCoolTime = false  # Shadow가 쿨타임일 때 비활성화하도록 하는 변수
var isTouchingWall = false  # 벽에 붙어있는지 여부
var wallNormal = Vector2.ZERO  # 벽의 방향(법선 벡터)
var vertical = 0
var horizontal = 0

static var is_on_ladder = false
const Climpspeed = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += gravity * delta
	# 기본 이동
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jumpPower
		elif isTouchingWall:  # 벽 점프 처리
			velocity = Vector2(wallNormal.x * wallJumpPower.x, wallJumpPower.y)
			isTouchingWall = false  # 벽 점프 이후 상태 초기화

	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	
	if is_on_ladder:
		velocity.y = 0
		if Input.is_action_pressed("up"):
			velocity.y = -Climpspeed
		if Input.is_action_pressed("down"):
			velocity.y = Climpspeed

	# 시간 되감기 능력 발동
	if Input.is_action_just_pressed("Action") and not isCoolTime:
		self.global_position = shadow.global_position
		isCoolTime = true
		abilityStartTime = Time.get_ticks_msec()

	# 쿨타임 동안 Shadow 비활성화
	if isCoolTime:
		var elapsedCoolTime = Time.get_ticks_msec() - abilityStartTime
		if elapsedCoolTime >= coolTime:
			isCoolTime = false
		else:
			shadow.hide()
	else:
		shadow.show()
	
	check_wall_contact()

	move_and_slide()
	
	if is_on_ladder:
		$PlayerAnim.play("Climb")	
	elif not is_on_floor():
		$PlayerAnim.play("Jump")
	elif direction == 1:
		$PlayerAnim.flip_h = false
		$PlayerAnim.play("Run")
	elif direction == -1:
		$PlayerAnim.flip_h = true
		$PlayerAnim.play("Run")
	else:
		$PlayerAnim.play("Stand")

	# 플레이어 좌표 기록
	record_position()

	# Shadow 위치 갱신
	if prePosition.size() > 0:
		shadow.global_position = prePosition[0]
	# 벽 점프 상태 확인


func check_wall_contact() -> void:
	# 벽 충돌 감지 초기화
	isTouchingWall = false
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)  # KinematicCollision2D 객체 반환
		if collision and collision.get_normal().x != 0:  # 법선 벡터 확인
			if not is_on_floor() and abs(collision.get_normal().x) > 0.7:  # 수직 벽 감지
				isTouchingWall = true
				wallNormal = collision.get_normal()  # 법선 벡터 저장
				break

func record_position():
	var currentTime = Time.get_ticks_msec()

	# 일정한 간격으로 위치와 시간을 기록
	if currentTime - lastRecordTime >= recordInterval:
		prePosition.append(self.global_position)
		lastRecordTime = currentTime  # 마지막 기록 시간 갱신
	
	if prePosition.size() > timeDelay / 1000 * 60:
		prePosition.pop_front()
