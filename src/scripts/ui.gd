extends CanvasLayer


signal upgrade_purchased(upgrade)

@export var currency: int = 0

const CURRENCY_LABEL_PREFIX = "Bank: $"


func _ready() -> void:
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)

	for upgrade: Node in $GridContainer.get_children():
		if upgrade is UpgradeButton:
			upgrade.purchased.connect(self._on_purchased_upgrade_button)

	self.update_upgrade_buttons()

func add_currency(amount: int) -> void:
	self.currency += amount
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)


func spend_currency(amount: int) -> void:
	self.currency -= amount
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)


func update_upgrade_buttons() -> void:
	for upgrade: Node in $GridContainer.get_children():
		if upgrade is UpgradeButton:
			if upgrade.price <= self.currency:
				upgrade.disabled = false
			else:
				upgrade.disabled = true


func _on_purchased_upgrade_button(price: int) -> void:
	self.spend_currency(price)
	self.update_upgrade_buttons()
	self.upgrade_purchased.emit()
