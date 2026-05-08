extends CharacterBody2D

@export var animator: AnimatedSprite2D
@export var banana_label: Label
@export_file("*.tscn") var game_over_scene: String

@export var death_height: float = 1000.0

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var coyote_time := 0.1
var coyote_timer := 0.0
var is_dead := false

var score: int = 0

func _ready():
	set_collision_mask_value(2, true)
	update_score_ui()

func _physics_process(delta: float) -> void:
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

	# Animations
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
	if Input.is_action_just_pressed("down"):
		set_collision_mask_value(2, false)
	elif Input.is_action_just_released("down"):
		set_collision_mask_value(2, true)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") or body.is_in_group("outOfBounds"):
		die()

func add_score(amount: int):
	score += amount
	update_score_ui()

func update_score_ui():
	banana_label.text = "Score: " + str(score)

func die():
	if is_dead:
		return
		
	is_dead = true
	print("Player died!")
	
	velocity = Vector2.ZERO
	collision_layer = 0
	
	animator.play("death")
	
	await get_tree().create_timer(0.5).timeout
	
	if game_over_scene != "" and FileAccess.file_exists(game_over_scene):
		get_tree().change_scene_to_file(game_over_scene)
	else:
		get_tree().reload_current_scene()
