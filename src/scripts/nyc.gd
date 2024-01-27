extends Node2D


var CarScene: PackedScene = preload("res://scenes/car.tscn")


func _ready() -> void:
	$UI.started.connect(self._on_ui_started)
	$CarSpawnTimer.timeout.connect(self._on_car_spawn_timer_timeout)
	# Spawn penguin
	pass


func _on_ui_started() -> void:
	# Start penguin walking
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
	car.speed = 150
	car.position = Vector2(-car.POS_X_BUFFER, 256 + 128 * randi_range(0, 10))
	self.add_child(car)
	$CarSpawnTimer.start(0.5)
