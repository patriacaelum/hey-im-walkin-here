class_name UpgradeButton
extends Button


signal purchased(price: int)

@export var price: int = 1


func _init() -> void:
    self.pressed.connect(self._on_pressed_upgrade_button)


func _on_pressed_upgrade_button() -> void:
    self.purchased.emit(self.price)
