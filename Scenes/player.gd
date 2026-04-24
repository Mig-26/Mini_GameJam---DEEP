extends CharacterBody2D

@export var animator: AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# 1. Gravity toevoegen
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Springen
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Richting en snelheid
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. ANIMATIE LOGICA (Belangrijk!)
	if not is_on_floor():
		# Prioriteit: We zijn in de lucht
		if velocity.y < 0:
			animator.play("jump")
		else:
			animator.play("fall")
	else:
		# We zijn op de grond
		if direction != 0:
			animator.play("run")
		else:
			animator.play("idle")

	# 5. Omdraaien (Flippen)
	if direction > 0:
		animator.flip_h = false
	elif direction < 0:
		animator.flip_h = true

	move_and_slide()
