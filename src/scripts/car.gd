class_name Car
extends CharacterBody2D


signal animal_control_created
signal crashed


enum CAR_TYPE {
	NORMAL,
	FANCY,
	ANIMAL_CONTROL,
}


@export var speed: int = 0

var pos: Vector2
var broken: bool = false
var price: int = 5
var target_x: float = 640

var __car_type: CAR_TYPE = CAR_TYPE.NORMAL

const SPEED_MAX: int = 150
const SPEED_MIN: int = 500
const POS_X_BUFFER: int = 256
const POS_Y_BUFFER: int = 256

	
func _ready() -> void:
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)


func _process(delta: float) -> void:
	if self.__car_type == CAR_TYPE.ANIMAL_CONTROL:
		var viewport: Rect2 = self.get_viewport_rect()
		self.position = self.position.move_toward(
			Vector2(self.target_x, viewport.position.y + viewport.size.y * 1.25),
			self.speed * delta,
		)
		print(self.position)
	else:
		self.position.x += self.speed * delta

	if self.__out_of_bounds():
		self.queue_free()

# Play lightning animation in random order of frames


func set_sprite(type: CAR_TYPE) -> void:
	self.__car_type = type

	match self.__car_type:
		CAR_TYPE.NORMAL:
			$CarAliveSprite.show()
			$CarDeadSprite.hide()
			$FancyAliveSprite.hide()
			$FancyDeadSprite.hide()
			$MoneyParticles.hide()
		CAR_TYPE.FANCY:
			$CarAliveSprite.hide()
			$CarDeadSprite.hide()
			$FancyAliveSprite.show()
			$FancyDeadSprite.hide()
			$MoneyParticles.show()
			self.price *= 3
		CAR_TYPE.ANIMAL_CONTROL:
			# Hide and show appropriate sprites
			self.price *= 2

	if self.speed > 0:
		$CarAliveSprite.flip_h = true
		$CarDeadSprite.flip_h = true
		$FancyAliveSprite.flip_h = true
		$FancyDeadSprite.flip_h = true
		# Flip the right sprites

func _disable_car() -> void:
	speed = 0
	broken = true

	match self.__car_type:
		CAR_TYPE.NORMAL:
			$CarAliveSprite.hide()
			$CarDeadSprite.show()
		CAR_TYPE.FANCY:
			$FancyAliveSprite.hide()
			$FancyDeadSprite.show()
		CAR_TYPE.ANIMAL_CONTROL:
			# show and hide appropriate sprites
			pass

	$SmokeParticles.emitting = true
	
func _on_area_2d_body_entered(body: Node) -> void:
	if body.get_instance_id() == self.get_instance_id():
		return
	self._disable_car()

func __out_of_bounds() -> bool:
	var upper_boundary: bool = self.get_viewport_rect().position.y > self.position.y - self.POS_Y_BUFFER
	var left_boundary: bool = self.position.x < -self.POS_X_BUFFER
	var right_boundary: bool = self.position.x > self.get_viewport_rect().size.x + self.POS_X_BUFFER

	return upper_boundary or left_boundary or right_boundary


func _on_area_2d_area_entered(area):
	self._disable_car()
	
	
func lightning_struck():
	$AnimationPlayer.play("lightning")
