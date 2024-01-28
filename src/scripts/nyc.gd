extends Node2D


var BananaPeelScene: PackedScene = preload("res://scenes/objects/banana_peel.tscn")
var CarScene: PackedScene = preload("res://scenes/car.tscn")
var RestingScene: PackedScene = preload("res://scenes/resting_spot.tscn")
var banana_peels_per_block: int = 15

var banana_peel_block: int = 0
var fancy_car_spawn_rate: float = 0.2

const initial_rest_y: int = 3000
var rest_multiplier: float = 1.1
var rest_y: int = 0


func _ready() -> void:
	$UI.started.connect(self._on_ui_started)
	$CarSpawnTimer.timeout.connect(self._on_car_spawn_timer_timeout)
	$Penguin.currency_collected.connect(self._on_penguin_currency_collected)

	var view_y = int(self.get_viewport_rect().size.y)
	self._spawn_next_rest()
	self.__spawn_banana_peels(view_y)
	self.banana_peel_block = view_y


func _physics_process(delta: float) -> void:
	if $Penguin.position.y > self.banana_peel_block:
		var view_y: int = int(self.get_viewport_rect().size.y)
		self.__spawn_banana_peels($Penguin.position.y + view_y)
		self.banana_peel_block += view_y

	$UI.update_score(int($Penguin.position.y / 10))


func _on_ui_started() -> void:
	if !$Penguin.alive:
		# Reset level to start
		$Tilemap.reset()
		$Penguin._reset()
		$Penguin/Camera2D.position = Vector2(0, 0)
		
		for child: Node in $Cars.get_children():
			if child is Car:
				child.queue_free()
				
		for child: Node in self.get_children():
			if child is BananaPeel:
				child.queue_free()
		banana_peel_block = 0
		
		for child: Node in self.get_children():
			if child is RestingSpot:
				child.queue_free()
		rest_y = 0
		rest_multiplier = 1.1
		self._spawn_next_rest()
	
	# Begin
	$Penguin.walking = true
	$CarSpawnTimer.start(2)


func _on_crash_penguin(body) -> void:
	$CarSpawnTimer.stop()
	$UI.update_highscore()
	$UI.set_mode($UI.MODE.UPGRADE)
	

func _on_ui_upgrade_purchased(upgrade) -> void:
	# Set upgrade on penguin
	$Penguin._add_upgrade(upgrade)


func _on_car_spawn_timer_timeout() -> void:
	var car: Car = CarScene.instantiate()
	var side: int = sign(randf() - 0.5)

	var car_type: Car.CAR_TYPE = Car.CAR_TYPE.NORMAL
	if randf() < self.fancy_car_spawn_rate:
		car_type = Car.CAR_TYPE.FANCY

	car.speed = -side * randi_range(car.SPEED_MIN, car.SPEED_MAX)
	var midpoint: int = int(self.get_viewport_rect().size.x / 2)
	car.position = Vector2(
		midpoint + side * (midpoint + car.POS_X_BUFFER),
		$Penguin.position.y + 256 + 128 * randi_range(0, 15)
	)
	car.set_sprite(car_type)
	$Cars.add_child(car)

	$CarSpawnTimer.start(0.2)


func _on_banana_peel_boost(time):
	$Penguin.play_timed_animation("slipping", time)

func __spawn_banana_peels(y_min: int) -> void:
	for i in range(self.banana_peels_per_block * $Penguin.bp_ratio):
		var bp: BananaPeel = BananaPeelScene.instantiate()
		bp.boost.connect(_on_banana_peel_boost)
		bp.position = Vector2(
			randi_range(0, int(self.get_viewport_rect().size.x)),
			randi_range(y_min, y_min + int(self.get_viewport_rect().size.y)),
		)
		self.add_child(bp)


func _on_penguin_currency_collected(amount: int) -> void:
	$UI.add_currency(amount)

func _on_resting():
	# Stop car spawn and disable any current cars
	$CarSpawnTimer.stop()
	for child: Node in $Cars.get_children():
		if child is Car:
			child._disable_car()
	$UI.show()
	self._spawn_next_rest()
	$Penguin._resting_pause()
	pass

func _spawn_next_rest() -> void:
	var rs: RestingSpot = RestingScene.instantiate()
	rs.rest.connect(_on_resting)
	if rest_y == 0:
		rest_y = initial_rest_y
	else :
		rest_y += (initial_rest_y * rest_multiplier)
	rest_multiplier *= rest_multiplier
	rs.position = Vector2(642, rest_y)
	self.add_child(rs)
	

