extends Node2D

@export var ball_scene : PackedScene  # 인스펙터에서 BallSystem 씬을 할당

func _input(event):
	# 왼쪽 마우스 버튼 클릭 확인
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		spawn_ball()

func spawn_ball():
	# 마우스의 현재 위치를 월드 좌표로 얻기
	var mouse_position = get_global_mouse_position()
	
	# BallSystem 씬 인스턴스화
	var ball_instance = ball_scene.instantiate()
	
	# 마우스 위치로 BallSystem 위치 설정
	ball_instance.position = mouse_position
	
	# BallSystem을 현재 노드의 자식으로 추가
	add_child(ball_instance)
