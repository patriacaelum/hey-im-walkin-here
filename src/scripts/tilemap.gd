extends TileMap


func _ready() -> void:
	$Area2D.body_entered.connect(self._on_area_2d_body_entered)


func reset() -> void:
	self.position.y = 0


func _on_area_2d_body_entered(body: Node) -> void:
	if body is Penguin:
		self.position.y += 1024
