
extends Area2D

func _ready():
	pass

func _on_WinArea_body_enter( body ):
	body.do_win()
