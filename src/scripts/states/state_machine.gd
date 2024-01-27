class_name StateMachine
extends Node
# The `StateMachine` manages its child `State` classes that manage the state of
# the root node.


@export var initial_state: State.STATENAME

var __states: Dictionary = {}
var __tda: Array[State.STATENAME] = []


func _ready() -> void:
	# Register all child states
	for child: Node in self.get_children():
		if not child is State:
			continue

		assert(not child.state_name in self.__states, "Cannot set duplicate state")

		child.finished.connect(self._on_finished_state)
		child.property_set.connect(self._on_property_set_state)
		child.state_changed.connect(self._on_state_changed_state)
		self.__states[child.state_name] = child

	# Enter initial state
	assert(self.initial_state != null, "Missing initial state")
	assert(self.initial_state in self.__states, "Unable to find initial state")
	self.__tda.append(self.initial_state)
	self.__top().enter()


func notify(event: InputEvent) -> void:
	self.__top().notify(event)


func update(delta: float) -> void:
	self.__top().update(delta)


func _on_finished_state() -> void:
	self.__remove_top()
	self.__top().enter()


func _on_property_set_state(state_name: State.STATENAME, property: StringName, value) -> void:
	self.__states[state_name].set(property, value)


func _on_state_changed_state(state_name: State.STATENAME) -> void:
	self.__remove_top()
	self.__tda.append(state_name)
	self.__top().enter()


func __remove_top() -> void:
	self.__top().exit()
	self.__tda.pop_back()


func __top() -> State:
	return self.__states[self.__tda[-1]]
