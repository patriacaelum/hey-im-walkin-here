extends CharacterBody2D


signal penguin_collision(body)

var walking: bool = false
var armour: bool = false

const SPEED = 100.0


func _ready() -> void:
	self.velocity.y = SPEED


func _physics_process(delta: float) -> void:
	if not self.walking:
		return

	var direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		self.velocity.x = direction_x * SPEED
	else:
		self.velocity.x = move_toward(velocity.x, 0, SPEED)
	
	self.move_and_slide()

func _on_area_2d_body_entered(body):
	penguin_collision.emit(body);

func set_armour(value: bool) -> void:
	armour = value
