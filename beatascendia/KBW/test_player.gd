extends CharacterBody2D

@export var speed = 300 #플레이어 이동속도
@export var jumpPower = -500 #플레이어 점프력
@export var coolTime = 5.0 #플레이어 시간 되감기 능력 쿨타임
@onready var shadow = $/root/TimeReverse/Shadow

var prePosition = [] #플레이어의 이전 좌표를 저장하는 배열 
var timeDelay = 2.0 #플레이어를 따라하는 시간 간격
var recordInterval = 0.01 #플레이어 좌표를 기록하는 간격
var timer = 0.0 #시간 되감기 등 특수 능력을 위한 타이머
var coolTimer = 0.0 #특수 능력 쿨타임 
var isCoolTime = false #shadow가 쿨타임일 때 비활성화하도록하는 변수	

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	#기본 이동
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpPower
		
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	
	#플레이어 시간 되감기 능력 발동
	if Input.is_action_just_pressed("Action"):
		self.global_position = shadow.global_position
		isCoolTime = true
	
	#쿨타임 동안 shadow 비활성화
	if(isCoolTime):
		coolTimer += delta
		shadow.hide()
	else:
		shadow.show()
	if(coolTimer >= coolTime):
		coolTimer = 0.0
		isCoolTime = false
	
	move_and_slide()	
	
	if (!is_on_floor()):
		$PlayerAnim.play("Jump")
	elif(direction == 1):
		$PlayerAnim.flip_h = false
		$PlayerAnim.play("Run")
	elif(direction == -1):
		$PlayerAnim.flip_h = true
		$PlayerAnim.play("Run")
	else:
		$PlayerAnim.play("Stand")
	
	#플레이어 좌표 기록
	record_position(delta)
	
	#shadow 위치 반영
	if prePosition.size() > 0:
		shadow.global_position = prePosition[0]
	
	#shadow 애니메이션	
	#update_shadow_animation()
	
func record_position(delta):
	timer += delta
	if timer >= recordInterval:
		prePosition.append(self.global_position)
		timer = 0.0
	if prePosition.size() > int(timeDelay / recordInterval):
		prePosition.pop_front() 

"""
func update_shadow_animation():
	var shadow_velocity = shadow.global_position - shadow_previous_position
	
	if !shadow.is_on_floor():
		$/root/TimeReverse/Shadow/ShadowAnim.play("Jump")
	elif shadow_velocity.x != 0:
		$/root/TimeReverse/Shadow/ShadowAnim.flip_h = shadow_velocity.x < 0
		$/root/TimeReverse/Shadow/ShadowAnim.play("Run")
	else:
		$/root/TimeReverse/Shadow/ShadowAnim.play("Stand")
	
	# 현재 위치를 다음 프레임 비교를 위해 저장
	shadow_previous_position = shadow.global_position
"""
