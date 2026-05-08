extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpsound: AudioStreamPlayer2D = $jumpsound
@onready var failed_sound: AudioStreamPlayer2D = $failedSound

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var alive = true
var can_move = true

signal player_failed(body)

func _physics_process(delta: float) -> void:
	#Add animation
	if !alive:
		return
		
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
	
	if global_position.y > 1000:
		fail()
		emit_signal("player_failed", self)
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"
	
	if can_move:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumpsound.play()

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if direction == 1.0:
			animated_sprite_2d.flip_h = false
		elif direction == -1.0:
			animated_sprite_2d.flip_h = true

func fail() -> void:
	failed_sound.play()
	animated_sprite_2d.animation = "failed"
	alive = false
