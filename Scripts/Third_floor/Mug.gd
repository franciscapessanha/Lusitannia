extends KinematicBody2D

onready var animations = get_node("animations")
var final
var direction
var velocity = Vector2()
onready var break_sound = get_node("break_sound")
var break_ = false
var bard

func _ready():
	set_physics_process(false)
	
func deadly():
	pass

func start_movement(initial_pos, final_pos):
	final = final_pos
	global_position = initial_pos
	set_physics_process(true)
	
func _physics_process(delta):
	direction = (final - global_position)
	velocity = move_and_slide(0.2*Vector2(direction.x * 0.05, direction.y))
	var collision = move_and_collide(velocity)
	if collision and collision.collider.has_method("lost_life"):
		bard = collision.collider
		get_node("Label").set_text("")
		animations.play("break")
		break_sound.play()
		break_ = true
		break_sound.play()
		get_parent().get_parent().bard_died()
		set_physics_process(false)
		
func _on_animations_animation_finished():
	if break_:
		bard.lost_life("mug", [])
		queue_free()
		
