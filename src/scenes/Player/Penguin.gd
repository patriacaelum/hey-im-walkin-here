class_name Penguin
extends CharacterBody2D


signal penguin_collision(body)
signal currency_collected(amount: int)

@export var thorsound: int = -25
var walking: bool = false
var alive: bool = true
var armour: int = 0
var animation_state: String = "walking"
var bp_ratio: float = 1.0
var upgrades: Array = []
var is_invincible: bool = false
var is_rolling: bool = false
var is_sliding: bool = false
var is_boosted: bool = false

const SPEED: float = 100.0
const INIT_POSITION: Vector2 = Vector2(636, 57)
const ROLL_FACTOR: float = 3.5


func _ready() -> void:
	self.velocity.y = SPEED
	$IFrameTimer.timeout.connect(self._on_iframe_timer_timeout)
	$RollingTimer.timeout.connect(self._on_rolling_timer_timeout)
	$ThorZoneTimer.timeout.connect(self._on_thor_zone_timer_timeout)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not self.is_rolling and not self.is_sliding:
		if self.velocity.x != 0:
			self.velocity.x *= self.ROLL_FACTOR
		else:
			self.velocity.y *= self.ROLL_FACTOR

		self.is_rolling = true
		self.animation_state = "roll"
		$RollingTimer.start()
	elif event.is_action_pressed("thor_zone") and $ThorZoneSprite.visible:
		var used: bool = false
		$THORZONESFX.play()
		for body: Node2D in $ThorZone.get_overlapping_bodies():
			if body is Car:
				body._disable_car()
				body.lightning_struck()
				used = true

		if used:
			$ThorZoneSprite.hide()
			$ThorZoneTimer.start()


func _physics_process(delta: float) -> void:
	if not self.walking:
		return

	if not self.is_rolling && not self.is_boosted:
		var direction_x = Input.get_axis("ui_left", "ui_right")
		if direction_x:
			self.velocity.x = direction_x * self.SPEED
		else:
			self.velocity.x = move_toward(velocity.x, 0, self.SPEED)
	
	self.move_and_slide()
	self.position.x = clamp(self.position.x, 0, self.get_viewport_rect().size.x)
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
		self.is_invincible = false
		self.is_rolling = false
		self.is_sliding = false
	else:
		self.is_invincible = true
		$IFrameTimer.start()


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
	if self.is_invincible:
		return

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
	self.is_rolling = false
	self.is_sliding = false
	self.restore_armour()
	$GrandmaHolder.rotation = 0
	if $GrandmaHolder/Grandma.is_purchased:
		# If armour is +=1 after a reset you'll die in one hit
		armour = 1
		$GrandmaHolder/Grandma.armour_active = true
		$GrandmaHolder/Grandma.randomizeColour()


func _add_upgrade(upgrade):
	# Add and track upgrade on penguin
	upgrades.append(upgrade)
	self._apply_upgrade(upgrade)


func _apply_upgrade(upgrade):
	if upgrade == GLOBALS.Upgrades.GRANDMA_ARMOUR:
		$GrandmaHolder/Grandma.is_purchased = true
		self.armour += 1
	elif upgrade == GLOBALS.Upgrades.MORE_BANANAS:
		self.bp_ratio += 0.25
	elif upgrade == GLOBALS.Upgrades.THOR_ZONE:
		$ThorZoneSprite.show()


func _on_iframe_timer_timeout() -> void:
	self.is_invincible = false


func _on_rolling_timer_timeout() -> void:
	self.velocity.y = self.SPEED
	self.is_rolling = false
	self.animation_state = "walking"


func _on_thor_zone_timer_timeout() -> void:
	$ThorZoneSprite.show()
