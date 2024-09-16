extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_range(10.0,800,1) var distance: float

var face_dir = 1
var can_move = true
var target: Vector2
var direction: float

@onready var ray_right: RayCast2D = %RayRight
@onready var ray_left: RayCast2D = %RayLeft

var mouse: Vector2

func _process(delta: float) -> void:
	%velocity.text = "velocity: " + str(velocity)
	%distance.text = "distance: " + str(distance)
	%rotation.text = "rotation: " + str(%guide.rotation)
	mouse = get_global_mouse_position()
	%guide.look_at(mouse)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if !ray_right.is_colliding() and !ray_left.is_colliding():
			velocity += get_gravity() * delta
			
		elif ray_right.is_colliding() or ray_left.is_colliding():
			can_move = false
			velocity.y = 0
			velocity.y += 400 * delta
		
	if Input.is_action_pressed("click"):
		if distance >= 800:
			pass
		else:
			distance += 10
			%charge.value = distance
			
		can_move = false
		
	if Input.is_action_just_released("click") and can_move == false:
		
		velocity += Vector2.RIGHT.rotated(%guide.rotation) * distance
		distance = 10

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if is_on_floor():
		can_move = true
	
	if can_move:
		movement()
		
	move_and_slide()
	
func movement() -> void:
	direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		%AnimatedSprite2D.flip_h = false
		face_dir = 1
	if direction < 0:
		%AnimatedSprite2D.flip_h = true
		face_dir = 2
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
