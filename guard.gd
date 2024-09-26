extends CharacterBody2D

var direction = 1: set = set_direction
var speed = 100

@onready var slime: Slime = $"../Slime"
@onready var tile_base: TileMapLayer = %TileBase

func set_direction(new_dir) -> void:
	direction = new_dir
	%Skin.scale.x = direction

func _physics_process(delta: float) -> void:
	
	if %Left.is_colliding():
		set_direction(1)
	if %Right.is_colliding():
		set_direction(-1)

	if %detection.overlaps_body(slime):
		#if we spot a slime we aim the raycast towards it 
		var direction_to_slime = %Target.global_position.direction_to(slime.global_position)
		%Target.target_position = direction_to_slime
		%Target.target_position = slime.global_position - %Target.global_position
			
		#check the first collider that the raycast interesects
		var detected_object = %Target.get_collider()
		
		#if its the wall dont do anything and just continue walking
		if detected_object == %TileBase:
			position.x += direction * speed * delta
		
		#if its a slime alert stop moving and aim at it untill it leaves sight
		if detected_object == slime:
			%AnimationPlayer.stop()
			%Head.look_at(slime.global_position)
	else:
		#if no slime is detected or slime left sight restart the head bobing and continue walking
		%AnimationPlayer.play("head_tilt")
		position.x += direction * speed * delta
