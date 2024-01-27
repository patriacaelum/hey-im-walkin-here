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


func _on_crash_penguin(car) -> void:
	# Destroy armour on penguin
	# Add money to UI
	# if penguin has no more armour:
	#     end current launch and show UI
	# Update car state to crash
	pass


func _on_ui_upgrade_purchased(upgrade) -> void:
	# Set upgrade on penguin
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
	self.add_child(car)

	$CarSpawnTimer.start(0.2)
