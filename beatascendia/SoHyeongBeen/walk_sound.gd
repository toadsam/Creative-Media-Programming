extends AudioStreamPlayer2D

@onready var player = $".."
var walk_sounds: Array = [
	preload("res://SoHyeongBeen/sounds/player walk1.mp3"),
	preload("res://SoHyeongBeen/sounds/player walk2.mp3"),
	preload("res://SoHyeongBeen/sounds/player walk3.mp3"),
	preload("res://SoHyeongBeen/sounds/player walk4.mp3"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_on_floor() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		play_sound()
	else:
		self.stop()

func play_sound() -> void:
	if not self.playing:
		var random_index = randi() % walk_sounds.size()
		self.stream = walk_sounds[random_index]
		self.play()
