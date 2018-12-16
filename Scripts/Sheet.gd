extends StaticBody2D

onready var left  = get_parent().get_node("Arrows/left")
onready var up  = get_parent().get_node("Arrows/up")
onready var down  = get_parent().get_node("Arrows/down")
onready var right  = get_parent().get_node("Arrows/right")
onready var note1 = get_node("note1")
onready var note2 = get_node("note2")
onready var note3 = get_node("note3")
onready var note4 = get_node("note4")
onready var note5 = get_node("note5")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func play_song():
	left.play("on")
	note1.play()
	

func _on_note1_finished():
	left.play("off")
	note2.play()
	up.play("on")

func _on_note2_finished():
	up.play("off")
	note3.play()
	right.play("on")

func _on_note3_finished():
	right.play("off")
	note4.play()
	left.play("on")
	
func _on_note4_finished():
	left.play("off")
	note5.play()
	down.play("on")
	
func _on_note5_finished():
	down.play("off")
