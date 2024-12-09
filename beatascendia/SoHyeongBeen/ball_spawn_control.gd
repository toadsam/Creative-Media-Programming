extends Node2D

@export var ball_scene: PackedScene  # 인스펙터에서 BallSystem 씬을 할당

func _ready() -> void:
	randomize()

func _input(event: InputEvent) -> void:
	# 왼쪽 마우스 버튼 클릭 시 BallSystem 인스턴스 생성
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		spawn_ball(get_global_mouse_position())

func spawn_ball(position: Vector2) -> void:
	# BallSystem 씬 인스턴스화
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = position
	ball_instance.rotation_degrees = randf_range(0, 360)
	add_child(ball_instance)
