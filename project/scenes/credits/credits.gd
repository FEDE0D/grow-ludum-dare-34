
extends CanvasLayer

func _ready():
	pass

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Globals.get("Transition").change_to("res://scenes/main/main.scn")
		Globals.get("Sounds").play_ui()


func _on_RichTextLabel_meta_clicked( meta ):
	OS.shell_open(meta)