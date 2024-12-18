extends Control

#UI control
@onready var normal_button_sprite = $normalSprite as Node2D
var is_button_pressing = false
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if is_button_pressing:
		normal_button_sprite.visible = false
	else:
		normal_button_sprite.visible = true

func _on_button_button_up() -> void:
	is_button_pressing = false
	
func _on_button_button_down() -> void:
	is_button_pressing = true
	print($activeSprite/middleSprite.scale)
