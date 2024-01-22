extends Node
class_name StateMachine


@export var initial_state: State

var __states: Dictionary = {}
var __tda: Array[State.STATE] = []


func notify(event: InputEvent) -> void:
    self.__top().notify(event)


func update(delta: float) -> void:
    self.__top().update(delta)


func _on_finished_state() -> void:
    self.__remove_top()
    self.__top().enter()


func _on_property_set_state(state: State.STATE, property: StringName, value) -> void:
    self.__states[state].set(property, value)


func _on_state_changed_state(state: State.STATE) -> void:
    self.__remove_top()
    self.__tda.append(state)
    self.__top().enter()


func _ready() -> void:
    for child: Node in self.get_children():
        if not child is State:
            continue

        assert(not child.get_class_name() in self.__states, "Cannot set duplicate state")

        child.finished.connect(self._on_finished_state)
        child.property_set.connect(self._on_property_set_state)
        child.state_changed.connect(self._on_state_changed_state)
        self.__states[child.get_class_name()] = child


func __remove_top() -> void:
    self.__top().exit()
    self.__tda.pop_back()


func __top() -> State:
    return self.__states[self.__tda[-1]]
