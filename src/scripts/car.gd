class_name Car
extends Area2D


signal crashed


@export var speed: int = 0

var pos: Vector2
var broken: bool = false

const SPEED_MAX: int = 150
const SPEED_MIN: int = 500
const POS_X_BUFFER: int = 256


func _ready() -> void:
	self.body_entered.connect(self._on_body_entered)


func _process(delta: float) -> void:
	self.position.x += self.speed * delta

	if self.__out_of_bounds():
		self.queue_free()


func _on_body_entered(_body):
	self.broken = true
	self.crashed.emit()


func __out_of_bounds() -> bool:
	var left_boundary: bool = self.position.x < -self.POS_X_BUFFER
	var right_boundary: bool = self.position.x > self.get_viewport_rect().size.x + self.POS_X_BUFFER

	return left_boundary or right_boundary
