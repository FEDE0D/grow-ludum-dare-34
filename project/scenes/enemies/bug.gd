
extends Node2D

const speed_persue = 24
const speed_wonder = 8
const timer_persue = 0.1
const timer_wonder = 2.0
var time = 0
var speed = 0

const NAV_WONDER = 0
const NAV_PERSUE = 1
const NAV_FLEE = 2

var navigation = NAV_WONDER

var path = []

func _ready():
	set_process(true)

func _process(delta):
	time += delta
	if navigation == NAV_PERSUE and time > timer_persue:
		time = 0
		speed = speed_persue
		path = Array(Globals.get("Navigation").get_path_to_player_from(get_global_pos()))
	elif navigation == NAV_WONDER and time > timer_wonder:
		time = 0
		speed = speed_wonder
		var rand_dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
		var rand_dist = rand_range(32, 64)
		var rand_point = get_global_pos() + (rand_dir*rand_dist)
		path = Array(Globals.get("Navigation").get_simple_path(get_global_pos(), rand_point))
	for p in path:
		if p.distance_to(get_global_pos()) < 5.0:
			path.erase(p)
	if path.size() > 0:
		var point = path[0]
		var direction = Vector2(point - get_global_pos()).normalized()
		translate(direction * speed * delta)


func _on_Area2D_body_enter( body ):
	navigation = NAV_PERSUE
	get_node("PersueTimer").start()

func _on_PersueTimer_timeout():
	navigation = NAV_WONDER
