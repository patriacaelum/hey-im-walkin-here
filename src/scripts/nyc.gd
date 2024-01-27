extends Node2D


var CarScene: PackedScene = preload("res://scenes/car.tscn")


func _ready() -> void:
	$UI.started.connect(self._on_ui_started)
	$CarSpawnTimer.timeout.connect(self._on_car_spawn_timer_timeout)
	# Spawn penguin
	pass


func _on_ui_started() -> void:
	$Penguin.walking = true
	$CarSpawnTimer.start(2)


func _on_crash_penguin(body) -> void:

	# Destroy armour on penguin
	if body in $Cars.get_children():
		if $Penguin.armour:
			$Penguin.armour = false
		else:
			print("Penguin is dead")
	
	# Add money to UI
	# if penguin has no more armour:
	#     end current launch and show UI
	
	# Stop the car
	if 'crash' in body:
		body.crash()


func _on_ui_upgrade_purchased(upgrade) -> void:
	# Set upgrade on penguin
	$Penguin._add_upgrade(upgrade)
	pass
	


func _on_car_spawn_timer_timeout() -> void:
	var car: Car = CarScene.instantiate()
	var side: int = sign(randf() - 0.5)

	car.speed = -side * randi_range(car.SPEED_MIN, car.SPEED_MAX)
	var midpoint: int = self.get_viewport_rect().size.x / 2
	car.position = Vector2(
		midpoint + side * (midpoint + car.POS_X_BUFFER),
		$Penguin.position.y + 256 + 128 * randi_range(0, 15)
	)
	$Cars.add_child(car)

	$CarSpawnTimer.start(0.2)


func _on_banana_peel_boost(time):
	$Penguin.play_timed_animation("slipping", time)
