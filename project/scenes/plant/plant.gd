
extends KinematicBody2D

const VELOCITY_MAX = 64
const VELOCITY_MIN = 32
var velocity = VELOCITY_MAX
var direction = Vector2(0, -1)

var positions = []
var do_input = false

var strength = 0.0
const STRENGTH_DECAY_SPEED = 0.1

func _ready():
	Globals.set("Plant", self)

func _process(delta):
	move(velocity * direction * delta)
	var snapped = get_global_pos().snapped(Vector2(8, 8))
	var pos = get_global_pos()
	if direction.x == 0:
		pos.x = snapped.x
	if direction.y == 0:
		pos.y = snapped.y
		
	set_global_pos(pos)
	
	if positions.size() < 2:
		positions.append(snapped)
	elif positions[1] != snapped:
		positions.append(snapped)
		positions.remove(0)
		Globals.get("Vine").add_vine(positions[1], positions[0])
		if do_input:
			if fmod(snapped.x, 16) != 0 and fmod(snapped.y, 16) != 0:
				get_node("SamplePlayer").play("move")
	
	# STRENGTH DECAY
#	if do_input:
#		strength = max(0, strength - STRENGTH_DECAY_SPEED * delta)
#		velocity = VELOCITY_MIN + ((VELOCITY_MAX - VELOCITY_MIN) * strength)
#		Globals.get("Indicators").set_strength(strength)

func left():
	if do_input:
		direction = direction.rotated(deg2rad(90))
		direction = direction.snapped(Vector2(1, 1))
		set_rot(direction.angle())
	
func right():
	if do_input:
		direction = direction.rotated(deg2rad(-90))
		direction = direction.snapped(Vector2(1, 1))
		set_rot(direction.angle())

func do_pickup_food():
	strength = min(1.0, strength + (1.0/Globals.get("Level").enemies_count))
	Globals.get("Indicators").set_strength(strength)
	get_node("SamplePlayer").play("rat")
	
	if strength >= 1.0:
		Globals.get("Level").add_exit()
		get_node("SamplePlayer").play("exit")

func do_start():
	set_process(true)
	do_input = true

func do_win():
	do_input = false
	get_node("SamplePlayer").play("win")
	Globals.get("Level").win()

func do_die():
	do_input = false
	get_node("SamplePlayer").play("die")
	Globals.get("Level").die()