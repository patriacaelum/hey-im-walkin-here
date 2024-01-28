extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@export var speed = 75
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	path_follow.progress = 0
	self.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_follow.progress += speed * delta
	if (path_follow.progress_ratio == 1):
		self.hide()
