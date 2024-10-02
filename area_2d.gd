extends Area2D

var FOV_increment = 1 * PI / 360

@onready var space_state = get_world_2d().direct_space_state

@export var guard: CharacterBody2D = null



func _process(delta: float) -> void:
	draw_target_Area()


func draw_target_Area():
	var mouse_angle = get_global_mouse_position().angle()
	
	
	
	set_target_area(get_FOV_cone(guard.global_position,400, 1, %Head.rotation))



func get_FOV_cone(from:Vector2,radius, width:float, angle):
	var start_angle = angle - width/2
	var end_angle = angle + width/2
	var points = raycast_arc(from,radius,start_angle,end_angle)
	points.append(from)
	
	return points


func raycast_arc(from:Vector2, radius, start_angle, end_angle):
	var angle = start_angle
	var points = PackedVector2Array()
	
	while angle < end_angle:
		var offset = Vector2(radius, 0).rotated(angle)
		var to = from + offset
		var query = PhysicsRayQueryParameters2D.create(from, to, 3)
		var result = space_state.intersect_ray(query)
		if result:
			points.append(result.position)
		else:
			points.append(to)
			
		angle += FOV_increment
		
	return points


func set_target_area(points:PackedVector2Array):
	$TargetArea.polygon = points
	$TargetCollision.polygon = points
	
