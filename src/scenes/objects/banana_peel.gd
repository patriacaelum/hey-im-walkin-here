class_name BananaPeel
extends StaticBody2D

var speedboost: int = 200
var speedboost_time: float = 2.0


signal boost(time)

const Y_MIN_BUFFER: int = 128



func _ready():
	$SpeedBoostTime.wait_time = speedboost_time
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)


func _physics_process(delta: float) -> void:
	if self.__out_of_bounds():
		print("banana out of range")
		self.queue_free()


# Add speed boost to charracter for a set amount of time
func _on_area_2d_body_entered(body):
	if body.is_rolling:
		return
		
	body.velocity.y += speedboost
	body.is_sliding = true
	$SpeedBoostTime.start()

	# Emit duration of speedboost to change character animation
	boost.emit(speedboost_time)
	
	await $SpeedBoostTime.timeout
	body.velocity.y = max(body.velocity.y - speedboost, body.SPEED)
	body.is_sliding = false
	

# Function should upgrade banana peel spawn rate or boost time duration
func upgrade():
	pass


func __out_of_bounds() -> bool:
	return int(self.get_viewport_rect().position.y) > self.position.y - self.Y_MIN_BUFFER
