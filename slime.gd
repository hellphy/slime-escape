class_name Slime extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_range(0.0,800,1) var distance: float

var face_dir = 1
var can_move = true
var target: Vector2
var direction: float
var mouse: Vector2

func _process(delta: float) -> void:
	%velocity.text = "velocity: " + str(velocity)
	%distance.text = "distance: " + str(distance)
	%rotation.text = "rotation: " + str(%guide.rotation)
	mouse = get_global_mouse_position()
	%guide.look_at(mouse)
	
func _physics_process(delta: float) -> void:
	%charge.value = distance
	# Add the gravity.

	if %Area2D.overlaps_body(%TileBase):
		velocity.y += 10 * delta
		
	elif not is_on_floor():
		velocity += get_gravity() * delta
		
		
	if Input.is_action_just_pressed("right_click"):
		%Area2D.monitoring = false
	
	if Input.is_action_pressed("left_click") and can_move == false:
		if distance >= 800:
			pass
		else:
			distance += 10
			
		can_move = false
		
	if Input.is_action_just_released("left_click") and can_move == false:
		
		velocity = Vector2.RIGHT.rotated(%guide.rotation) * distance
		distance = 10
		print("velocity: ", velocity, " rotation: ",%guide.rotation)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if is_on_floor():
		distance = 0
		can_move = true
		%Area2D.monitoring = true
	
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
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_on_floor():
		if body.is_in_group("wall"):
			velocity.y = 0
			can_move = false
			
			
