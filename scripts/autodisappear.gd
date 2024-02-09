extends Node2D


func _ready():
	# Connect the timeout signal of the Timer node to this script
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout():
	hide()
