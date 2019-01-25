extends StaticBody2D

onready var first  = get_parent().get_node("Platforms/first")
onready var second  = get_parent().get_node("Platforms/second")
onready var third  = get_parent().get_node("Platforms/third")
onready var wrong2  = get_parent().get_node("Platforms/wrong")

onready var note = get_node("note")


onready var seq_plat = [first, second, third]
onready var times = [1,1,1]

onready var wrong = get_node("wrong")
onready var collect = get_node("collect")
onready var rhythm = get_node("rhythm")
var try = ""
var truth = "1234"
var mode = "all"
var i = 0
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
	play_note()

func play_note():

	if i < len(seq_plat):
		seq_plat[i].get_node("animation").play("on")
		note.play()
		rhythm.wait_time = times[i]
		rhythm.start()
		print("i",i)
		i +=1
	else:
		print("try")
		mode = "try"

func _on_note_finished():
	print(i-1)
	seq_plat[i-1].get_node("animation").play("off")
	seq_plat[i-1].get_node("CollisionShape2D").disabled = true

func _on_wrong_timeout():
	play_song()
	pass # replace with function body


func _on_collect_timeout():
	queue_free()
	pass # replace with function body


func _on_rhythm_timeout():
	if mode == "all":
		print("entrou")
		play_note()
	pass # replace with function body
