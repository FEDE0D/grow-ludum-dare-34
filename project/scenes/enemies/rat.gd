
extends Area2D

var rayLeft = null
var rayRight = null
var rayLeftFront = null
var rayRightFront = null

const SPEED = 64

var direction = Vector2()
var timer = 1.5
var time = 0


func _ready():
	set_fixed_process(true)
	rayLeft = get_node("leftRaycast")
	rayRight = get_node("rightRaycast")
	rayLeftFront = get_node("leftFrontRaycast")
	rayRightFront = get_node("rightFrontRaycast")

func _fixed_process(delta):
	time += delta
	if time > timer:
		time = 0
		direction.x = (randi()%3) - 1
		if abs(direction.x) > 0:
			get_node("Sprite").set_flip_h(direction.x > 0)
	
	var vel = Vector2()
	if direction.x < 0:
		if rayLeft.is_colliding() and not rayLeftFront.is_colliding():
			vel = direction * SPEED
		else:
			time += timer * 0.5
	elif direction.x > 0:
		if rayRight.is_colliding() and not rayRightFront.is_colliding():
			vel = direction * SPEED
		else:
			time += timer * 0.5
	translate(vel * delta)

func _on_rat_body_enter( body ):
	Globals.get("Plant").do_pickup_food()
	queue_free()
