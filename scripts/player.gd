extends CharacterBody2D

@export var animator: AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var coyote_time := 0.1
var coyote_timer := 0.0

func _ready():
	set_collision_mask_value(2, true)

func _fallThroughPlatforms():
	if Input.is_action_just_pressed("down"):
		set_collision_mask_value(2, false)
	elif Input.is_action_just_released("down"):
		set_collision_mask_value(2, true)

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# coyote time update
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# jumping
	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0

	# moving
	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#animations
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

	#flip
	if direction > 0:
		animator.flip_h = false
	elif direction < 0:
		animator.flip_h = true

	_fallThroughPlatforms()
	move_and_slide()
