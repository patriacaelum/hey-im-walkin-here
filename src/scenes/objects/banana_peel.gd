extends Area2D

var speedboost: int = 200
var speedboost_time: float = 2.0

signal bananapeel(time)

func _ready():
	$SpeedBoostTime.wait_time = speedboost_time

# Add speed boost to charracter for a set amount of time
func _on_body_entered(body):
	body.velocity.y += speedboost
	$SpeedBoostTime.start()
	
	# Emit duration of speedboost to change character animation
	bananapeel.emit(speedboost_time)
	
	await $SpeedBoostTime.timeout
	body.velocity.y -= speedboost
	

# Function should upgrade banana peel spawn rate or boost time duration
func upgrade():
	pass

	
	queue_free()
	pass # Replace with function body.
