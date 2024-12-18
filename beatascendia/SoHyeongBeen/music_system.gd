extends Node2D

signal is_beat_signal(beat: int)

@export var bgm_stream: AudioStream
@export var music_node_name: String
@export var bpm: float

@onready var music_node: AudioStreamPlayer2D = get_node(music_node_name)
@onready var rewind_node: AudioStreamPlayer2D = $Rewind

var beat_interval: float
var next_beat_time: float = 0.0
var is_music_started: bool = false
var beat: int = 0
var music_system_output: int = -1  # -1 = Not playing music, 0 = not beat timing, 1 = beat timing

func _ready() -> void:
	if not music_node:
		return
	
	if bgm_stream:
		music_node.stream = bgm_stream
	
	beat_interval = 60.0 / bpm
	print("beat_interval: ", beat_interval)
	if not is_music_started:
		start_music()

func _process(_delta: float) -> void:
	if not music_node:
		return

	if is_music_started:
		check_beat()

func start_music() -> void:
	music_node.play()
	is_music_started = true
	next_beat_time = 0.0
	beat = 0
	music_system_output = 0

func stop_music() -> void:
	music_node.stop()
	is_music_started = false
	music_system_output = -1

func check_beat() -> void:
	if not music_node.playing:
		return

	var current_music_time = music_node.get_playback_position()
	music_system_output = 0
	
	if current_music_time >= next_beat_time:
		music_system_output = 1
		next_beat_time += beat_interval
		beat += 1
		emit_signal("is_beat_signal", beat)

func forward_music() -> void:
	var forward_time = max(music_node.get_playback_position() - 3.0, 0.0)
	
	next_beat_time = floor(forward_time / beat_interval) * beat_interval
	beat = int(next_beat_time / beat_interval)
	
	music_node.stop()
	rewind_music()
	await get_tree().create_timer(3.0).timeout
	music_node.play(forward_time)
	music_system_output = 0

func rewind_music() -> void:
	if not rewind_node.playing:
		rewind_node.play()

func _on_music_finished() -> void:
	stop_music()
