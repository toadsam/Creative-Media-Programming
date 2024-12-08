extends RigidBody2D

var prePosition = [] #플레이어의 이전 좌표를 저장하는 배열 
var timeDelay = 2.0 #플레이어를 따라하는 시간 간격
var recordInterval = 0.01
var timer = 0.0

func _physics_process(delta):
	record_position(delta)
	if prePosition.size() > 0:
		global_position = prePosition[0]
	#if Input.is_action_just_pressed("Action"):
		#self.global_position = Player.global_position

func record_position(delta):
	timer += delta
	if timer >= recordInterval:
		prePosition.append(self.global_position)
		timer = 0.0
	if prePosition.size() > int(timeDelay / recordInterval):
		prePosition.pop_front() 
