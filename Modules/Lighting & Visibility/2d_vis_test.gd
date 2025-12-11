extends Node2D

@export var player: Node3D
@onready var light: PointLight2D = $PointLight2D
@onready var gridmap: GridMap = $Walls
@onready var tilemap: TileMap = $TileMap2

const MINX = -500
const MAXX = 500
const MINY = -500
const MAXY = 500

func _ready():
	#tilemap.set_cell(0,Vector2(0,0),0,Vector2(0,0))
	#print(tilemap.get_cell_alternative_tile(0,Vector2(0,0)))
	generate_tilemap()

func _process(_delta):
	if player:
		light.position = Vector2(player.position.x * 100 ,player.position.z * 100)

func generate_tilemap():
	for i in range(MINX,MAXX + 1):
		for j in range(MINY,MAXY + 1):
			if gridmap.get_cell_item(Vector3(i,0,j)) == 0:
				print("found wall")
				tilemap.set_cell(0,Vector2(i,j), 0,Vector2.ZERO)
