extends Node2D


var BananaPeelScene: PackedScene = preload("res://scenes/objects/banana_peel.tscn")
var CarScene: PackedScene = preload("res://scenes/car.tscn")
var banana_peels_per_block: int = 15

var banana_peel_block: int = 0


func _ready() -> void:
	$UI.started.connect(self._on_ui_started)
	$CarSpawnTimer.timeout.connect(self._on_car_spawn_timer_timeout)

	var view_y = int(self.get_viewport_rect().size.y)
	self.__spawn_banana_peels(view_y)
	self.banana_peel_block = view_y


func _physics_process(delta: float) -> void:
	if $Penguin.position.y > self.banana_peel_block:
		var view_y: int = int(self.get_viewport_rect().size.y)
		self.__spawn_banana_peels($Penguin.position.y + view_y)
		self.banana_peel_block += view_y


func _on_ui_started() -> void:
	$Penguin.walking = true
	$CarSpawnTimer.start(2)


func _on_crash_penguin(body) -> void:

	# Destroy armour on penguin
	if body in $Cars.get_children():
		if $Penguin.armour:
			print("armour being destroyed")
			$Penguin.set_armour(false)
		else:
			print("Penguin is dead")
	
	# Add money to UI
	# if penguin has no more armour:
	#     end current launch and show UI
	

func _on_ui_upgrade_purchased(upgrade) -> void:
	# Set upgrade on penguin
	$Penguin._add_upgrade(upgrade)
	pass
	


func _on_car_spawn_timer_timeout() -> void:
	var car: Car = CarScene.instantiate()
	var side: int = sign(randf() - 0.5)

	car.speed = -side * randi_range(car.SPEED_MIN, car.SPEED_MAX)
	var midpoint: int = int(self.get_viewport_rect().size.x / 2)
	car.position = Vector2(
		midpoint + side * (midpoint + car.POS_X_BUFFER),
		$Penguin.position.y + 256 + 128 * randi_range(0, 15)
	)
	$Cars.add_child(car)

	$CarSpawnTimer.start(0.2)


func _on_banana_peel_boost(time):
	$Penguin.play_timed_animation("slipping", time)

func __spawn_banana_peels(y_min: int) -> void:
	for i in range(self.banana_peels_per_block):
		var bp: BananaPeel = BananaPeelScene.instantiate()
		bp.position = Vector2(
			randi_range(0, int(self.get_viewport_rect().size.x)),
			randi_range(y_min, y_min + int(self.get_viewport_rect().size.y)),
		)
		self.add_child(bp)

