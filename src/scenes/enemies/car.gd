extends Area2D

@export var speed: int = 0
var pos: Vector2
var broken: bool = false
signal crash

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta

func _on_body_entered(_body):
	broken = true
	crash.emit()

func _on_spawn_timer_timeout():
	queue_free()
