extends Node2D

@onready var music_system = $"../MusicSystem"
@onready var sprite1 = $BeatSprite1
@onready var sprite2 = $BeatSprite2
@onready var sprite3 = $BeatSprite3
@onready var sprite4 = $BeatSprite4

var beat : int = 0
var compare_beat_because_print : int = 0

func _process(delta: float) -> void:
	compare_beat_because_print = beat
	beat = music_system.beat
	
	if beat == compare_beat_because_print:
		return
		
	if beat % 4 == 1:
		print("beat: 1")
		sprite1.modulate = Color(1, 0, 0)
		var tween = get_tree().create_tween()
		tween.tween_property($BeatSprite1, "modulate", Color(1, 1, 1), 0.5)

	elif beat % 4 == 2:
		print("beat: 2")
		sprite2.modulate = Color(0, 0, 1)
		var tween = get_tree().create_tween()
		tween.tween_property($BeatSprite2, "modulate", Color (1, 1, 1), 0.5)
		
	elif beat % 4 == 3:
		print("beat: 3")
		sprite3.modulate = Color(0, 0, 1)
		var tween = get_tree().create_tween()
		tween.tween_property($BeatSprite3, "modulate", Color (1, 1, 1), 0.5)
		
	elif beat % 4 == 0:
		print("beat: 4")
		sprite4.modulate = Color(0, 0, 1)
		var tween = get_tree().create_tween()
		tween.tween_property($BeatSprite4, "modulate", Color (1, 1, 1), 0.5)
