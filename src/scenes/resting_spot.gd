class_name RestingSpot
extends Area2D

signal rest
var triggered = false

func _on_body_entered(body):
	if (!triggered):
		triggered = true
		rest.emit()

func update_stop_label(value: int) -> void:
	$MarginContainer/NinePatchRect2/MarginContainer/HFlowContainer/RestStopNumber.text = str(value)
