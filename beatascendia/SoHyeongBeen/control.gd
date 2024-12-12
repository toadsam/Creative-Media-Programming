extends Control

@export var text_value : String
@export var button_text_x_scale : float
@export var button_text_y_scale : float

@onready var normal_button_sprite = $normalSprite


var is_button_pressing = false
func _ready() -> void:
	$button.text=text_value
	$button.size = Vector2(button_text_x_scale, button_text_y_scale)
	
func _process(delta: float) -> void:
	if is_button_pressing:
		normal_button_sprite.visible = false
	else:
		normal_button_sprite.visible = true

func _on_button_pressed() -> void:
	print("sans")

func _on_button_button_up() -> void:
	is_button_pressing = false
	
func _on_button_button_down() -> void:
		is_button_pressing = true
