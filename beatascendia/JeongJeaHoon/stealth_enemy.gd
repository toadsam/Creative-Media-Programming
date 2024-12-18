extends CharacterBody2D

# Configurable variables
@export var move_distance: float = 200.0  # Patrol distance
@export var move_speed: float = 100.0     # Movement speed
@export var visibility_duration: float = 2.0  # Visible state duration
@export var invisibility_duration: float = 2.0  # Stealth state duration

# Texture settings
@export var normal_texture: Texture  # Texture for normal state
@export var stealth_texture: Texture  # Texture for stealth state

# Internal variables
var start_position: Vector2  # Stores the starting position
var moving_right: bool = true  # Movement direction
var is_visible: bool = true  # Current visibility state (default: visible)
@onready var sprite: Sprite2D = $Sprite2D  # Reference to the sprite

func _ready():
	start_position = global_position  # Save the starting position
	toggle_visibility()  # Start toggling visibility

func _physics_process(delta: float) -> void:
	# Handle movement
	move_stealth_enemy(delta)

func move_stealth_enemy(delta: float) -> void:
	# Double speed when in stealth mode
	var current_speed = move_speed * 2 if not is_visible else move_speed

	# Calculate movement distance
	var direction = 1 if moving_right else -1
	global_position.x += direction * current_speed * delta

	# Reverse direction and flip sprite when reaching patrol distance
	if abs(global_position.x - start_position.x) > move_distance:
		moving_right = !moving_right  # Reverse direction
		sprite.flip_h = not sprite.flip_h  # Flip sprite horizontally

func toggle_visibility():
	while true:
		# Visible state
		is_visible = true
		sprite.modulate.a = 1.0  # Alpha value 1 (fully visible)
		sprite.texture = normal_texture  # Change to normal state texture
		await get_tree().create_timer(visibility_duration).timeout

		# Stealth state
		is_visible = false
		sprite.modulate.a = 0.2  # Alpha value 0.2 (nearly transparent)
		sprite.texture = stealth_texture  # Change to stealth state texture
		await get_tree().create_timer(invisibility_duration).timeout
