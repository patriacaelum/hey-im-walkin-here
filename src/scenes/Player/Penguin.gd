class_name Penguin
extends CharacterBody2D


signal penguin_collision(body)
signal currency_collected(amount: int)


var walking: bool = false
var alive: bool = true
var armour: int = 0
var animation_state: String = "walking"
var bp_ratio: float = 1.0
var upgrades: Array = []

const SPEED = 100.0
const INIT_POSITION = Vector2(636, 57)


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
	$AnimationPlayer.play(animation_state)
	
	if animation_state == "slipping":
		$GrandmaHolder.rotate(delta * 20)


func _on_area_2d_body_entered(body):
	if not body is Car:
		return

	self.remove_armour()
	self.currency_collected.emit(body.price)

	if self.armour < 0:
		self.walking = false
		self.alive = false
		penguin_collision.emit(body)


func _resting_pause():
	self.walking = false
	self.animation_state = "walking"
	self.restore_armour()
	


func play_timed_animation(animation: String, time: float) -> void:
	$AnimationChangeTimer.wait_time = time
	$AnimationChangeTimer.start()
	
	animation_state = animation
	$GrandmaHolder/Grandma.play_animation('slipping')

	await $AnimationChangeTimer.timeout
	
	# Reset to walking
	animation_state = "walking"
	$GrandmaHolder/Grandma.play_animation('walking')
	$GrandmaHolder.rotation = 0
	

func remove_armour() -> void:
	$GrandmaHolder/Grandma.armour_active = false
	self.armour -= 1


func restore_armour():
	if $GrandmaHolder/Grandma.is_purchased:
		# If armour is +=1 after a reset you'll die in one hit
		armour = 1
		$GrandmaHolder/Grandma.armour_active = true


func _reset():
	self.position = INIT_POSITION
	self.velocity.y = SPEED
	self.animation_state = "walking"
	self.alive = true
	self.restore_armour()
	$Grandma.randomizeColour()
	$GrandmaHolder.rotation = 0
	if $GrandmaHolder/Grandma.is_purchased:
		# If armour is +=1 after a reset you'll die in one hit
		armour = 1
		$GrandmaHolder/Grandma.armour_active = true


func _add_upgrade(upgrade):
	# Add and track upgrade on penguin
	upgrades.append(upgrade)
	self._apply_upgrade(upgrade)


func _apply_upgrade(upgrade):
	if upgrade == GLOBALS.Upgrades.GRANDMA_ARMOUR:
		$GrandmaHolder/Grandma.is_purchased = true
		self.armour += 1

	if upgrade == GLOBALS.Upgrades.MORE_BANANAS:
		self.bp_ratio += 0.25
