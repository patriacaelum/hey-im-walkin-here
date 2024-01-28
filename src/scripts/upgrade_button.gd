class_name UpgradeButton
extends Button


signal purchased(price: int, upgrade_num: int)

@export var price: int = 1
@export var is_purchased: bool = false
@export var upgrade_num: GLOBALS.Upgrades = GLOBALS.Upgrades.GRANDMA_ARMOUR


func _ready() -> void:
	self.pressed.connect(self._on_pressed_upgrade_button)
	self.text = "$" + String.num_int64(self.price)


func _on_pressed_upgrade_button() -> void:
	self.is_purchased = true

	self.purchased.emit(self.price, self.upgrade_num)
	self.disabled = true
	self.focus_mode = FocusMode.FOCUS_NONE
