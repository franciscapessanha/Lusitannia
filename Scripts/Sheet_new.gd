extends StaticBody2D

onready var first  = get_parent().get_node("Platforms/first")
onready var second  = get_parent().get_node("Platforms/second")
onready var third  = get_parent().get_node("Platforms/third")
onready var fourth  = get_parent().get_node("Platforms/fourth")
onready var wrong2  = get_parent().get_node("Platforms/wrong")

onready var note1 = get_node("note1")
onready var note2 = get_node("note2")
onready var note3 = get_node("note3")
onready var note4 = get_node("note4")

onready var seq_notes = [note1, note2, note3, note4]
onready var seq_len = [400, 400, 400, 400]

onready var wrong = get_node("wrong")
onready var collect = get_node("collect")
var try = ""
var truth = "1234"
var mode = "all"

func _ready():
	set_process(false)

func _process(delta):
	if try.length() == truth.length():
		if try == truth:
			get_parent().get_node("Bard").set_exploring()
			collect.start()
			set_process(false)
		else:
			try = ""
			wrong.start()


func play_song():
	mode = "all"
	set_process(false)
	play_note1()

func play_note1():
	first.get_node("animation").play("on")
	note1.play()		

func _on_note1_finished():
	first.get_node("animation").play("off")
	note2.play()
	if mode == "all":
		play_note2()

func play_note2():
	second.get_node("animation").play("on")
	note2.play()	

func _on_note2_finished():
	second.get_node("animation").play("off")
	if mode == "all":
		play_note3()

func play_note3():
	third.get_node("animation").play("on")
	note3.play()		

func _on_note3_finished():
	third.get_node("animation").play("off")
	if mode == "all":
		play_note4()
		print("note3")

func play_note4():
	fourth.get_node("animation").play("on")
	note4.play()		

func _on_note4_finished():
	fourth.get_node("animation").play("off")
	if mode == "all":
		set_process(true)
		mode = "try"



func _on_wrong_timeout():
	play_song()
	pass # replace with function body


func _on_collect_timeout():
	queue_free()
	pass # replace with function body
