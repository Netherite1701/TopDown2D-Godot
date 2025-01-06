extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_dir : Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready() -> void:
	update_animation_parameters(starting_dir)

func get_input_direction() -> Vector2:
	return Vector2 (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
func update_animation_parameters(input_direction: Vector2) -> void:
	if(input_direction != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Walk/blend_position", input_direction)
		
func pick_new_state() -> void:
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
	
		
func _physics_process(delta: float) -> void:
	var input_direction = get_input_direction()
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction.normalized() * move_speed
	
	move_and_collide(velocity * delta)
	
	pick_new_state()
	
