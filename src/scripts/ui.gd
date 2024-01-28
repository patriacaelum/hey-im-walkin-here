class_name UI
extends CanvasLayer


signal upgrade_purchased(upgrade)
signal started


enum MODE {
	UPGRADE,
	PENGUIN,
}


@export var currency: int = 0

var __current_score: int = 0

const CURRENCY_LABEL_PREFIX: String = "Bank: $"
const SCORE_BUFFER: int = 6


func _ready() -> void:
	$Currency.text = self.CURRENCY_LABEL_PREFIX + String.num_int64(self.currency)
	$FreeMoney.pressed.connect(self._on_free_money_pressed)
	$StartButton.pressed.connect(self._on_start_button_pressed)

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
			if upgrade.price > self.currency or upgrade.is_purchased:
				upgrade.disabled = true
			else:
				upgrade.disabled = false


func update_score(score: int) -> void:
	self.__current_score = max(score - self.SCORE_BUFFER, 0)
	$Distance.text = "Distance: " + String.num_int64(self.__current_score)


func update_highscore() -> void:
	var scores: Array[int] = [
		int($Highscore/Score0.text),
		int($Highscore/Score1.text),
		int($Highscore/Score2.text),
		self.__current_score,
	]
	scores.sort()
	
	$Highscore/Score0.text = String.num_int64(scores[3])
	$Highscore/Score1.text = String.num_int64(scores[2])
	$Highscore/Score2.text = String.num_int64(scores[1])


func set_mode(mode: MODE) -> void:
	match mode:
		MODE.UPGRADE:
			$GridContainer.show()
			$StartButton.show()
			$Highscore.show()
		MODE.PENGUIN:
			$GridContainer.hide()
			$StartButton.hide()
			$Highscore.hide()

	self.update_upgrade_buttons()


func _on_purchased_upgrade_button(price: int, upgrade_num: int) -> void:
	self.spend_currency(price)
	self.update_upgrade_buttons()
	self.upgrade_purchased.emit(upgrade_num)


func _on_free_money_pressed() -> void:
	self.add_currency(1)
	self.update_upgrade_buttons()


func _on_start_button_pressed() -> void:
	self.set_mode(MODE.PENGUIN)
	started.emit()
