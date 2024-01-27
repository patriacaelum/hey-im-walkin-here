extends Node2D


var currency: int = 0

const CURRENCY_LABEL_PREFIX = "Bank: $"


func add_currency(amount: int) -> void:
	self.currency += amount
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)


func spend_currency(amount: int) -> void:
	self.currency -= amount
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)
