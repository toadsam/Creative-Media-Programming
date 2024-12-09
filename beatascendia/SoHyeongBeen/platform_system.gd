extends Node2D

@onready var music_system = $"../../MusicSystem"
@onready var platform = $Platform
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_x_scale_at_beat()

func change_x_scale_at_beat() -> void:
	if music_system.music_system_output == 1:
		platform.scale.x=1.5
		
	elif music_system.music_system_output == 0 and platform.scale.x >= 1:
		platform.scale.x *= 0.996
