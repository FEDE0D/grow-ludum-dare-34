
extends CanvasLayer

func _ready():
	pass

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Globals.get("Transition").change_to("res://scenes/main/main.scn")
