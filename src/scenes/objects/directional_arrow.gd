extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotation = clamp(self.rotation - delta, -PI/2, PI/2, )
	print(self.rotation/PI*180)
	pass
