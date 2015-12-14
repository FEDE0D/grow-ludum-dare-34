
extends SamplePlayer

func _ready():
	Globals.set("Sounds", self)

func play_ui():
	play("ui")

