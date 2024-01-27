extends CanvasLayer


var currency: int = 0

const CURRENCY_LABEL_PREFIX = "Bank: $"


func _ready() -> void:
	for upgrade: Node in $GridContainer.get_children():
		if upgrade is Button:
			upgrade.pressed.connect(self._on_pressed_upgrade)
			upgrade.disabled = true


func add_currency(amount: int) -> void:
	self.currency += amount
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)


func spend_currency(amount: int) -> void:
	self.currency -= amount
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)


func update_upgrade_states() -> void:
	for upgrade: Node in $GridContainer.get_children():
		if upgrade is Button:
			if upgrade.price <= self.currency:
				upgrade.disabled = false


func _on_pressed_upgrade() -> void:
	pass
