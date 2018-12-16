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
onready var note6 = get_node("note6")

onready var seq_notes = [note1, note2, note3, note4]
onready var seq_arrows = [left, up, down, right] 
onready var seq_len = [400, 400, 400, 400]

func _ready():
	set_process(false)
func get_input():
	if Input.is_action_just_pressed("ui_left"):
		play_note1()
	elif Input.is_action_just_pressed("ui_up"):
		play_note2()
	elif Input.is_action_just_pressed("ui_down"):
		play_note3()	
	elif Input.is_action_just_pressed("ui_right"):
		play_note4()

func _process(delta):
	get_input()
	
func play_song():
	play_note1()
	set_process(true)

func play_note1():
	seq_arrows[0].play("on")
	seq_notes[0].play()		
func _on_note1_finished():
	seq_arrows[0].play("off")

func play_note2():
	seq_arrows[1].play("on")
	seq_notes[1].play()	
func _on_note2_finished():
	seq_arrows[1].play("off")	

func play_note3():
	seq_arrows[2].play("on")
	seq_notes[2].play()		
func _on_note3_finished():
	seq_arrows[2].play("off")

func play_note4():
	seq_arrows[3].play("on")
	seq_notes[3].play()		
func _on_note4_finished():
	seq_arrows[3].play("off")
