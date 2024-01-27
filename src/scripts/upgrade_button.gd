class_name UpgradeButton
extends Button


signal purchased(price: int)

@export var upgrade_name: String = ""
@export var price: int = 1
@export var is_purchased: bool = false


func _ready() -> void:
	self.pressed.connect(self._on_pressed_upgrade_button)
	self.text = self.upgrade_name + " ($" + String.num_int64(self.price) + ")"


func _on_pressed_upgrade_button() -> void:
	self.is_purchased = true

	self.purchased.emit(self.price)
	self.disabled = true
	self.focus_mode = FocusMode.FOCUS_NONE
