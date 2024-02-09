extends Sprite2D 


var duration: float = 0.5
var scale_factor: float = 1.2

var ticks = 0;
var growing = 1;

# make a functiont hat makes the heart beat on physics process
func _physics_process(delta: float) -> void:
	
	scale = Vector2(0.656 + ticks, 0.656 + ticks)
	
	ticks = ticks + (0.0006 * growing)
	
	if ticks > 0.02:
		growing = -1
		
	if ticks < -0.02: 
		growing = 1
	
