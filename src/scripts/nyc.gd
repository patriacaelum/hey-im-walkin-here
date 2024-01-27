extends Node2D


func _ready() -> void:
	$UI.started.connect(self._on_ui_started)
	# Spawn penguin
	pass


func _on_ui_started() -> void:
	# Start penguin walking
	# Start car spawning
	pass


func _on_crash_penguin(car) -> void:
	# Destroy armour on penguin
	# Add money to UI
	# if penguin has no more armour:
	#     end current launch and show UI
	# Update car state to crash
	pass


func _on_ui_upgrade_purchased(upgrade) -> void:
	# Set upgrade on penguin
	pass
