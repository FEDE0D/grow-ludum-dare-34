
extends CanvasLayer

var scene_path = null

func _ready():
	Globals.set("Transition", self)
	get_node("AnimationPlayer").play_backwards("fade_in")

func change_to(scene):
	scene_path = scene
	get_node("AnimationPlayer").play("fade_in")

func do_change():
	if scene_path != null:
		get_tree().change_scene(scene_path)
		scene_path = null
		get_node("AnimationPlayer").play_backwards("fade_in")

