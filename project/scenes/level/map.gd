
extends TileMap

var maze = {}
var width = 4
var height = 4
var result = []
var start = Vector2()
var exit = Vector2()
var backtracks = []
var t = -1

var player_pos = Vector2()
var camera_limits = []
const outside_height = 3
var time_to_solve = 0
var enemies_count = 0

func _ready():
	
	self.width = Globals.get("WIDTH")
	self.height = Globals.get("HEIGHT")
	self.start = Vector2(0, height - 1)
	
	amaze_ing()
	
	t = get_tileset().get_tiles_ids()
	
	# FOREGROUND
	var W = (width * 2) + 1
	var H = (height * 2) + 1
	for x in range(0, W):
		for y in range(0, H):
			set_cell(x, y, t[0])
	# extra tiles at the bottom
	for x  in range(0, W):
		for y in range(H, H + 10):
			set_cell(x, y, t[0])
	
	
	# DIG MAZE
	for p in result:
		var from = p[0]
		var to = p[1]
		var p = [int(from["pos"].x)*2, int(from["pos"].y)*2]
		var pp = [int(to["pos"].x)*2, int(to["pos"].y)*2]
		var inter = [int((pp[0] + p[0])/2), int((pp[1] + p[1])/2)]
		set_cell(p[0] + 1, p[1] + 1, t[1], randi()%2==0, randi()%2==0)
		set_cell(pp[0] + 1, pp[1] + 1, t[1], randi()%2==0, randi()%2==0)
		set_cell(inter[0] + 1, inter[1] + 1, t[1], randi()%2==0, randi()%2==0)
		
	# HOLES
	var cant = int((width * height * 2) / 8)
	for i in range(0, cant):
		var pos = Vector2(randi()%(width*2 -1) + 1, randi()%(height*2 -1) + 1)
		set_cell(pos.x, pos.y, t[1])
	
	# TIME
	time_to_solve = int( width * height * 0.8)
	
	# BACKTRACKS
	for b in backtracks:
		var pos = b["pos"]
		set_cell(pos.x, pos.y, t[2])

	# SET EXIT
	randomize()
	exit = Vector2((randi() % (width * 2)) -1, 0)
	while get_cell(exit.x, exit.y + 1) != t[1]:
		exit = Vector2((randi() % (width * 2)) -1, 0)

	# GRASS
	for x in range(0, (width*2 + 1)):
		var i = randi() % 3
		if i == 0:
			set_cell(x, -1, t[3], randi() % 2 == 0)
		elif i == 1:
			set_cell(x, -1, t[4], randi() % 2 == 0)
		elif i == 2:
			set_cell(x, -1, t[5], randi() % 2 == 0)

	# ENEMIES
	randomize()
	enemies_count = int((width * height) * 0.05) + 1
	var rat_scn = load("res://scenes/enemies/rat.scn")
	for i in range(0, enemies_count):
		var pos_rat = Vector2()
		while ((get_cell(pos_rat.x, pos_rat.y) != t[1] or get_cell(pos_rat.x, pos_rat.y+1) != t[0])) or pos_rat==start:
			pos_rat = Vector2(randi() % (width*2), randi()% (height*2))
		var rat = rat_scn.instance()
		get_node("../../../enemies").add_child(rat)
		rat.set_global_pos(pos_rat * 16 + Vector2(8, 8))

	# POSITION PLAYER
	player_pos = (((start * 2) + Vector2(2, 2)) * 16) - Vector2(8, 8)
	# LIMIT CAMERA
	var size = get_viewport_rect().size
	camera_limits.append(Vector2(0, 0))# left
	camera_limits.append(Vector2(1, -outside_height * 16*2))# top
	camera_limits.append(Vector2(2, width * 16 * 2 - 16*2))# right
	camera_limits.append(Vector2(3, height * 16 * 2 - 16*3))# bottom

func amaze_ing():
	for x in range(0, width):
		maze[x] = {}
		for y in range(0, height):
			maze[x][y] = {
				"visited": false,
				"pos": Vector2(x, y),
				"neighbors": get_default_neighbors(Vector2(x, y))
			}
	randomize()
	do_maze(maze[int(start.x)][int(start.y)])

func do_maze(cell):
	cell["visited"] = true
	var nn = cell["neighbors"]
	var index = []
	for i in range(0, nn.size()):
		index.append(i)
	
	for i in range(0, nn.size()):
		var r = randi() % index.size()
		var n = index[r]
		var neighbor = nn[n]
		index.erase(n)
		
		var datos = maze[int(neighbor.x)][int(neighbor.y)]
		if not datos["visited"]:
			add_path(cell, datos)
			do_maze(datos)

func add_exit():
	set_cell(exit.x, exit.y, t[1])

func add_path(from, to):
	result.append([from, to])

func get_default_neighbors(pos):
	var neighbors = []
	neighbors.append(Vector2(pos.x+1, pos.y)) # right
	neighbors.append(Vector2(pos.x, pos.y-1)) # top
	neighbors.append(Vector2(pos.x-1, pos.y)) # left
	neighbors.append(Vector2(pos.x, pos.y+1)) # bottom
	var nn = []
	
	for n in neighbors:
		if n.x < 0 or n.x == width or n.y < 0 or n.y == height:
			pass
		else:
			nn.append(n)
	return nn
