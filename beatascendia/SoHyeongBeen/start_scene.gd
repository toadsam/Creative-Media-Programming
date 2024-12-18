extends CanvasLayer

@onready var volume_slider = $BoxContainer/Control/HSlider
@onready var master_bus = AudioServer.get_bus_index("Master")
var button = 0

func _ready() -> void:
	$AudioStreamPlayer.play()
	
func _process(delta: float) -> void:
	button = 0

func _on_button_pressed_1() -> void:
	button = 1

func _on_button_pressed_2() -> void:
	button = 2

func _on_button_pressed_3() -> void:
	button = 3

func _on_h_slider_value_changed(value: float) -> void:
	var mapped_value = remap(value, 0, 100, -30, 0)
	
	# -80dB 미만은 음소거로 처리
	if mapped_value <= -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
		AudioServer.set_bus_volume_db(master_bus, mapped_value)
