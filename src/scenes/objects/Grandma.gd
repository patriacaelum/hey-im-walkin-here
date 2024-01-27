extends StaticBody2D

@export var armour_active: bool = true
@export var is_purchased: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_purchased && armour_active):
		self.show()
	else:
		self.hide()
	pass
