class_name RestingSpot
extends Area2D

signal rest
var triggered = false

func _on_body_entered(body):
	if (!triggered):
		triggered = true
		rest.emit()
