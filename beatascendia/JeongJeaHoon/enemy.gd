extends CharacterBody2D

@export var speed: float = 50.0  # Enemy's movement speed
@onready var player = get_parent().get_node("TestPlayer")  # Player node
var is_paused: bool = false  # Flag to check if the enemy is paused

func _ready():
	# Find the player using an absolute path
	if not player:
		# Try finding the player using a relative path
		player = $"../TestPlayer"  # When the enemy and player share the same parent
	if not player:
		# Search for the player in the tree
		player = get_tree().get_root().find_node("TestPlayer", true, false)
	if player:
		print("Player found!")
	else:
		print("Player not found!")

func _physics_process(delta: float) -> void:
	if player and not is_paused:
		# Follow the player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

	# Detect collision with the player
	if player and global_position.distance_to(player.global_position) < 10.0 and not is_paused:  # 10 is the collision distance
		on_player_collision()

func on_player_collision() -> void:
	if not is_paused:
		# Display a message when the player's health decreases
		print("The player's health is reduced!")
		
		# Change the enemy to a paused state
		is_paused = true
		velocity = Vector2.ZERO  # Set velocity to 0
		move_and_slide()  # Stop immediately

		# Wait for 4 seconds before the enemy can move again
		call_deferred("resume_after_pause")

func resume_after_pause():
	await get_tree().create_timer(4.0).timeout
	is_paused = false
