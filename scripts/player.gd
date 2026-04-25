extends CharacterBody2D

@export var animator: AnimatedSprite2D
# Drag and drop your game_over.tscn file into this slot in the Inspector
@export_file("*.tscn") var game_over_scene: String

# The Y coordinate at which the player dies (Adjust this in the Inspector based on your level)
@export var death_height: float = 1000.0

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var coyote_time := 0.1
var coyote_timer := 0.0
var is_dead := false # Prevents movement and multiple death triggers

func _ready():
	# Set collision mask for platforms (Layer 2)
	set_collision_mask_value(2, true)

func _physics_process(delta: float) -> void:
	# Stop all logic if the player is dead
	if is_dead:
		return

	if position.y > death_height:
		die()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor():
		if velocity.y < 0:
			animator.play("jump")
		else:
			animator.play("fall")
	else:
		if direction != 0:
			animator.play("run")
		else:
			animator.play("idle")

	if direction > 0:
		animator.flip_h = false
	elif direction < 0:
		animator.flip_h = true

	_fallThroughPlatforms()
	move_and_slide()

func _fallThroughPlatforms():
	# Allow falling through one-way platforms (Layer 2)
	if Input.is_action_just_pressed("down"):
		set_collision_mask_value(2, false)
	elif Input.is_action_just_released("down"):
		set_collision_mask_value(2, true)

# This function is triggered by the Area2D (Hurtbox) signal
func _on_hurtbox_body_entered(body: Node2D) -> void:
	# Check if the body we collided with is in the "enemies" or "outOfBounds" group
	if body.is_in_group("enemies") or body.is_in_group("outOfBounds"):
		die()

func die():
	# Prevent the function from running multiple times
	if is_dead: 
		return
		
	is_dead = true
	print("Player died!")
	
	# Stop the player's movement immediately
	velocity = Vector2.ZERO
	
	# Disable collision so the player doesn't keep interacting with objects
	collision_layer = 0
	
	animator.play("death")
	
	# Short pause for dramatic effect before scene transition
	await get_tree().create_timer(0.5).timeout
	
	# Switch to the Game Over scene or reload the current one
	if game_over_scene != "" and FileAccess.file_exists(game_over_scene):
		get_tree().change_scene_to_file(game_over_scene)
	else:
		# Fallback: Restart current level if no scene is assigned in Inspector
		get_tree().reload_current_scene()
