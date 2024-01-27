extends CharacterBody2D


signal penguin_collision(body)

var walking: bool = false
var armour: bool = false

var globals;
var UPGRADES_ENUM;

const SPEED = 100.0
var upgrades = []


func _ready() -> void:
	globals = get_node("/root/GLOBALS")
	UPGRADES_ENUM = globals.Upgrades
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
	$Grandma.armour_active = value

func _reset():
	self.position = Vector2(636, 57)
	self.set_armour($Grandma.is_purchased)

func _add_upgrade(upgrade):
	# Add and track upgrade on penguin
	upgrades.append(upgrade)
	self._apply_upgrade(upgrade)

func _apply_upgrade(upgrade):
	if (upgrade == UPGRADES_ENUM.GRANDMA_ARMOUR):
		$Grandma.is_purchased = true;
		self.set_armour(true)
	
