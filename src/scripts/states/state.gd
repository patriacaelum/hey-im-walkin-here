extends Node
class_name State


enum STATE {
    NULL,
}


# The state should emit this when its action is complete.
signal finished
signal property_set(state: STATE, property: StringName, value)
signal state_changed(state: STATE)


func get_class_name() -> String:
    return ""


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


func _ready() -> void:
    assert(self.get_class_name() != "", "A `State` child class is missing its name")
