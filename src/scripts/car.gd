class_name Car
extends StaticBody2D

signal crashed


enum CAR_TYPE {
	NORMAL,
	FANCY,
}


@export var speed: int = 0

var pos: Vector2
var broken: bool = false

var __car_type: CAR_TYPE = CAR_TYPE.NORMAL

const SPEED_MAX: int = 150
const SPEED_MIN: int = 500
const POS_X_BUFFER: int = 256

	
func _ready() -> void:
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)


func _process(delta: float) -> void:
	self.position.x += self.speed * delta

	if self.__out_of_bounds():
		self.queue_free()


func set_sprite(type: CAR_TYPE) -> void:
	self.__car_type = type

	match self.__car_type:
		CAR_TYPE.NORMAL:
			$CarAliveSprite.show()
			$CarDeadSprite.hide()
			$FancyAliveSprite.hide()
			$FancyDeadSprite.hide()
		CAR_TYPE.FANCY:
			$CarAliveSprite.hide()
			$CarDeadSprite.hide()
			$FancyAliveSprite.show()
			$FancyDeadSprite.hide()

	if self.speed > 0:
		$CarAliveSprite.flip_h = true
		$CarDeadSprite.flip_h = true
		$FancyAliveSprite.flip_h = true
		$FancyDeadSprite.flip_h = true


func _on_area_2d_body_entered(body: Node) -> void:
	if body.get_instance_id() == self.get_instance_id():
		return

	speed = 0
	broken = true

	match self.__car_type:
		CAR_TYPE.NORMAL:
			$CarAliveSprite.hide()
			$CarDeadSprite.show()
		CAR_TYPE.FANCY:
			$FancyAliveSprite.hide()
			$FancyDeadSprite.show()

	$SmokeParticles.emitting = true


func __out_of_bounds() -> bool:
	var left_boundary: bool = self.position.x < -self.POS_X_BUFFER
	var right_boundary: bool = self.position.x > self.get_viewport_rect().size.x + self.POS_X_BUFFER

	return left_boundary or right_boundary
