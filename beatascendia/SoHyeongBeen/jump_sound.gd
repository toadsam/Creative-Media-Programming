
extends AudioStreamPlayer2D

@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor() or player.isTouchingWall:
			self.play()
			get_tree().create_timer(0.2).timeout
