extends CanvasLayer

var button = 0
func _process(delta: float) -> void:
	button = 0

func _on_button_pressed_1() -> void:
	button = 1

func _on_button_pressed_2() -> void:
	button = 2

func _on_button_pressed_3() -> void:
	button = 3
