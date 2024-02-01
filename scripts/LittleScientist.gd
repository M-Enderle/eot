extends CharacterBody2D

@export var speed = 175

var target = position
var min_scale = 0.7
var max_scale = 1.3

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()

func _physics_process(delta):
	var y = position[1]
	var ratio = range_lerp(position.y, 250, 600, min_scale, max_scale)
	scale = Vector2(ratio, ratio)
	
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		move_and_slide()
		$AnimatedSprite2D2.animation = "run"
	else:
		$AnimatedSprite2D2.animation = "default"
		
func range_lerp(value, min1, max1, min2, max2):
	var value_norm = inverse_lerp(min1, max1, value)
	return lerp( min2, max2, value_norm)
