extends CharacterBody2D

class_name Player

@export var speed = 200  # Player movement speed
@export var jumpPower = -500  # Player jump power
@export var wallJumpPower = Vector2(-150, -300)  # Wall jump direction and force (x, y)

@export var coolTime = 5000.0  # Rewind ability cooldown (ms)

var health = 100

@onready var shadow = get_parent().get_node("Shadow")
@onready var camera = get_node("Camera2D")
@onready var collision_shape = get_node("CollisionShape2D") 

static var stage = 0
var prePosition = []  # Array to store previous positions of the player
var preHealth = []  # Array to store previous health values of the player
var timeDelay = 3000.0  # Time delay for Shadow to follow (ms)
var recordInterval = 10.0  # Interval to record positions (ms)
var lastRecordTime = 0.0  # Last recorded time
var abilityStartTime = 0.0  # Ability activation start time
var isCoolTime = false  # Variable to disable Shadow during cooldown
var isTouchingWall = false  # Whether the player is touching a wall
var wallNormal = Vector2.ZERO  # Direction of the wall (normal vector)
var vertical = 0
var horizontal = 0

var isRewinding = false  # Rewinding state
var rewindDuration = 3000.0  # Rewind duration (ms)
var rewindStartTime = 0.0  # Rewind start time
var rewindPositions = []  # Array to store positions during rewind
var elapsedCoolTime = 8000.0
static var is_on_ladder = false
const Climpspeed = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$HUD.update_time(8000)

func _physics_process(delta):	
	velocity.y += gravity * delta
	
	if not isRewinding:
		# Default movement
		var direction = Input.get_axis("left", "right")
		velocity.x = direction * speed
		
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = jumpPower
			elif isTouchingWall:  # Wall jump handling
				velocity = Vector2(wallNormal.x * wallJumpPower.x, wallJumpPower.y)
				isTouchingWall = false  # Reset state after wall jump
		
		if is_on_ladder:
			velocity.y = 0
			if Input.is_action_pressed("up"):
				velocity.y = -Climpspeed
			if Input.is_action_pressed("down"):
				velocity.y = Climpspeed
		
		# Check wall jump state
		check_wall_contact()
		move_and_slide()
		
		# Adjust camera limits
		if stage == 1:
			camera.limit_left = -10
			camera.limit_right = 1950
			camera.limit_top = -135
			camera.limit_bottom = 1100
		elif stage == 2:
			camera.limit_left = 0
			camera.limit_right = 5400
			camera.limit_top = 0
			camera.limit_bottom = 1825
		
		$HUD.update_health(health)
		
		# Record player position
		record_position()
		# Update Shadow position
		if prePosition.size() > 0:
			shadow.global_position = prePosition[0]
					
		if is_on_ladder:
			$PlayerAnim.play("Climb")
		elif not is_on_floor():
			$PlayerAnim.play("Jump")
		elif direction == 1:
			$PlayerAnim.flip_h = false
			$PlayerAnim.play("Run")
		elif direction == -1:
			$PlayerAnim.flip_h = true
			$PlayerAnim.play("Run")
		else:
			$PlayerAnim.play("Stand")
	
	else:
		# Rewind: Update position and health sequentially
		var elapsedRewindTime = Time.get_ticks_msec() - rewindStartTime
		var progress = elapsedRewindTime / rewindDuration  # Rewind progress (0.0 ~ 1.0)
		$PlayerAnim.play("Rewind")
		
		collision_shape.disabled = true
		
		if progress >= 1.0 or rewindPositions.is_empty() or preHealth.is_empty():
			# Reset state after rewind
			isRewinding = false
			rewindPositions.clear()
			preHealth.clear()
			collision_shape.disabled = false
		else:
			# Continue rewinding
			var index = int(progress * rewindPositions.size())
			self.global_position = rewindPositions[index]
			health = preHealth[index]
			$HUD.update_health(health)  # Update UI

		
		
	if Input.is_action_just_pressed("Action") and not isCoolTime and not isRewinding:
		# Start rewind
		isRewinding = true
		isCoolTime = true
		rewindStartTime = Time.get_ticks_msec()
		abilityStartTime = Time.get_ticks_msec()  # Start cooldown
		# Copy and reverse rewind data
		rewindPositions = prePosition.duplicate()
		rewindPositions.reverse()  # Reverse position array
		preHealth.reverse()  # Reverse health array
		$"MusicSystem".forward_music()

	# Disable Shadow during cooldown
	if isCoolTime:
		elapsedCoolTime = Time.get_ticks_msec() - abilityStartTime
		$HUD.update_time(elapsedCoolTime)	
		if elapsedCoolTime >= coolTime + rewindDuration:
			isCoolTime = false
		else:
			shadow.hide()
	else:
		shadow.show()

func check_wall_contact() -> void:
	# Reset wall collision detection
	isTouchingWall = false
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)  # KinematicCollision2D object
		if collision and collision.get_normal().x != 0:  # Check normal vector
			if not is_on_floor() and abs(collision.get_normal().x) > 0.7:  # Detect vertical walls
				isTouchingWall = true
				wallNormal = collision.get_normal()  # Store normal vector
				break

func record_position():
	var currentTime = Time.get_ticks_msec()

	# Record position and health at intervals
	if currentTime - lastRecordTime >= recordInterval:
		prePosition.append(self.global_position)
		preHealth.append(health)  # Record current health
		lastRecordTime = currentTime  # Update last record time
	
	# Remove old data (keep position and health in sync)
	if prePosition.size() > timeDelay / 1000 * 60:
		prePosition.pop_front()
	if preHealth.size() > timeDelay / 1000 * 60:
		preHealth.pop_front()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		health -= 10
		# Calculate relative position to the enemy
		var push_direction = (body.global_position - self.global_position).normalized()
		body.global_position += push_direction * 50  # Push back distance (50 pixels)
	elif body.is_in_group("StealthEnemy"):
		health -= 5
		# Calculate relative position to the enemy
		var push_direction = (body.global_position - self.global_position).normalized()
		body.global_position += push_direction * 2.5  # Push back distance (2.5 pixels)
	
	if(health <= 0):
					health = 0
					$HUD.update_health(health)
					$HUD.game_over()
					await get_tree().create_timer(1.5).timeout
					get_tree().reload_current_scene()
