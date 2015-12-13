
extends Node2D

export(Color) var sky_color = Color(1, 1, 1)

var time = 0
var enemies_count = 0

func _ready():
	Globals.set("Level", self)
	
	Globals.get("Plant").set_global_pos(get_node("map/Navigation2D/map").player_pos)
	
	for l in get_node("map/Navigation2D/map").camera_limits:
		Globals.get("Plant").get_node("Camera2D").set_limit(l.x, l.y)
	
	var exit = Vector2(get_node("map/Navigation2D/map").exit)
	exit.y -= 1
	get_node("map/WinArea").set_global_pos(Vector2(exit) * 16)
	enemies_count = get_node("map/Navigation2D/map").enemies_count
	
	
	VisualServer.set_default_clear_color(sky_color)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Globals.get("Transition").change_to("res://scenes/main/main.scn")

func start():
	Globals.get("Plant").do_start()
	get_node("GUI/indicators").start_timer(get_node("map/Navigation2D/map").time_to_solve)
	set_process(true)
	time = 0
	
	print("Width: ", get_node("map/Navigation2D/map").width, " Height: ", get_node("map/Navigation2D/map").height)
	print("Timer: ", get_node("map/Navigation2D/map").time_to_solve)
	print("Rats: ", enemies_count)

func _process(delta):
	time += delta

func _on_leftButton_pressed():
	Globals.get("Plant").left()

func _on_rightButton_pressed():
	Globals.get("Plant").right()

func add_exit():
	get_node("map/Navigation2D/map").add_exit()

func win():
	set_process(false)
	
	var mins = str(int(time) / 60)
	var secs = str(int(time) % 60).pad_zeros(2)
	var text = "TIME " + mins + ":" + secs
	
	get_node("GUI/win/timeLabel").set_text(text)
	Globals.get("Indicators").stop_timer()
	get_node("GUI/AnimationPlayer").play("win")

func die():
	set_process(false)
	Globals.get("Indicators").stop_timer()
	get_node("GUI/AnimationPlayer").play("die")

var pressed = false

func _on_replayButton_pressed():
	if not pressed:
		pressed = true
		Globals.get("Transition").change_to("res://scenes/level/level.scn")

func _on_nextButton_pressed():
	if not pressed:
		pressed = true
		Globals.set("WIDTH", Globals.get("WIDTH") + 1)
		Globals.set("HEIGHT", Globals.get("HEIGHT") + 1)
		Globals.get("Transition").change_to("res://scenes/level/level.scn")
