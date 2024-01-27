class_name State
extends Node
# Base `State` class that is meant to child nodes of the `StateMachine` class.


signal finished
signal property_set(state: STATENAME, property: StringName, value)
signal state_changed(state: STATENAME)

# Each child class should register its state name in this enum.
enum STATENAME {
	NULL,
}

# Each child class should set its state name in its `_init` method.
var state_name: STATENAME = STATENAME.NULL


func _ready() -> void:
	assert(
		self.state_name != STATENAME.NULL,
		"Each child class of `State` must set and register its state name",
	)


# Set the internal parameters when entering the state.
func enter() -> void:
	pass


# Set the internal parameters when exiting the state.
func exit() -> void:
	pass


# Process user input to the state.
func notify(event: InputEvent) -> void:
	pass


# Updates the state by a single frame.
func update(delta: float) -> void:
	pass

