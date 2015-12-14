
extends Control

func _ready():
	get_tree().set_auto_accept_quit(false)
	Globals.set("WIDTH", 4)
	Globals.set("HEIGHT", 4)

func _on_startButton_pressed():
	Globals.get("Transition").change_to("res://scenes/level/level.scn")
	Globals.get("Sounds").play_ui()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()

func _on_creditsButton_pressed():
	Globals.get("Transition").change_to("res://scenes/credits/credits.scn")
	Globals.get("Sounds").play_ui()
