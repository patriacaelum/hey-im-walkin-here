extends Node2D


var BananaPeelScene: PackedScene = preload("res://scenes/objects/banana_peel.tscn")
var CarScene: PackedScene = preload("res://scenes/car.tscn")
var RestingScene: PackedScene = preload("res://scenes/resting_spot.tscn")
var banana_peels_per_block: int = 15
var rest_stop_counter: int = 0
var banana_peel_block: int = 0
var fancy_car_spawn_rate: float = 0.2
var animal_control_spawn_rate: float = 0.05

const initial_rest_y: int = 3000
var rest_multiplier: float = 1.1
var car_spawn_multiplier: float = 1.0
var rest_y: int = 0

const BOOST_SPEED: int = 250
const CAR_SPAWN_MULTIPLIER_CHANGE_RATE: float = 0.9


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
		self.car_spawn_multiplier *= self.CAR_SPAWN_MULTIPLIER_CHANGE_RATE

	$UI.update_score(int($Penguin.position.y / 10))


func _on_ui_started() -> void:
	if !$Penguin.alive:
		# Reset level to start
		rest_stop_counter = 0
		$Penguin._reset()
		$Tilemap.reset()
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
		self.car_spawn_multiplier = 1.0
		self._spawn_next_rest()
	
	# Begin
	$Penguin.walking = true
	$CarSpawnTimer.start(2)
	$Penguin/Arrow.hide()
	self._starting_boost()
	
func _starting_boost():
	# Boost in X direction disabled
	var rotation = $Penguin/Arrow.rotation
	var direction_x = -sin(rotation)
	var direction_y = cos(rotation)
	#$Penguin.velocity.x += direction_x * BOOST_SPEED
	$Penguin.velocity.y += direction_y * BOOST_SPEED
	
	$Penguin/Arrow/Timer.start()
	await $Penguin/Arrow/Timer.timeout
	
	#$Penguin.velocity.x -= direction_x * BOOST_SPEED
	$Penguin.velocity.y = max($Penguin.velocity.y - $Penguin.velocity.y * BOOST_SPEED, $Penguin.SPEED)

	pass


func _on_crash_penguin(body) -> void:
	$CarSpawnTimer.stop()
	$UI.update_highscore()
	$UI.set_mode(UI.MODE.UPGRADE)
	

func _on_ui_upgrade_purchased(upgrade) -> void:
	if upgrade == GLOBALS.Upgrades.MORE_LUXURY:
		self.fancy_car_spawn_rate *= 2
	else:
		# Set upgrade on penguin
		$Penguin._add_upgrade(upgrade)


func _on_car_spawn_timer_timeout() -> void:
	var car: Car = CarScene.instantiate()
	var side: int = sign(randf() - 0.5)

	var car_type: Car.CAR_TYPE = Car.CAR_TYPE.NORMAL
	if randf() < self.fancy_car_spawn_rate:
		car_type = Car.CAR_TYPE.FANCY
	elif randf() < self.animal_control_spawn_rate:
		car_type = Car.CAR_TYPE.ANIMAL_CONTROL

	car.speed = -side * randi_range(car.SPEED_MIN, car.SPEED_MAX)
	var midpoint: int = int(self.get_viewport_rect().size.x / 2)
	car.position = Vector2(
		midpoint + side * (midpoint + car.POS_X_BUFFER),
		$Penguin.position.y + 256 + 128 * randi_range(0, 15)
	)
	if car_type == Car.CAR_TYPE.ANIMAL_CONTROL:
		car.position.y = $Penguin.position.y - 500
		car.position.x = $Penguin.position.x
	car.set_sprite(car_type)
	$Cars.add_child(car)

	$CarSpawnTimer.start(0.2 * self.car_spawn_multiplier)


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
	$Penguin/Money.start()
	$UI.add_currency(amount)

func _on_resting():
	# Stop car spawn and disable any current cars
	$CarSpawnTimer.stop()
	for child: Node in $Cars.get_children():
		if child is Car:
			child._disable_car()
	$UI.set_mode(UI.MODE.UPGRADE)
	_spawn_next_rest()
	$Penguin._resting_pause()
	$Penguin/Arrow.show()


func _spawn_next_rest() -> void:
	
	rest_stop_counter += 1
	
	var rs: RestingSpot = RestingScene.instantiate()
	rs.update_stop_label(rest_stop_counter)
	rs.rest.connect(_on_resting)
	if rest_y == 0:
		rest_y = initial_rest_y
	else :
		rest_y += (initial_rest_y * rest_multiplier)
	rest_multiplier += 0.1
	rs.position = Vector2(642, rest_y)
	add_child(rs)
	

