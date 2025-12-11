extends Node3D

@export var player: Node3D
@export var gridmap: GridMap
@onready var fake_player: Node2D = $"SubViewport/Node2D/Fake Player"
@onready var tilemap: TileMap = $SubViewport/Node2D/TileMap
@onready var viewport_sprite: Sprite3D = $ViewportSprite

const MINX = -500
const MAXX = 500
const MINY = -500
const MAXY = 500

func _ready():
	generate_tilemap()
	pass

func _process(_delta):
	viewport_sprite.position = Vector3(player.position.x,2.001,player.position.z)
	fake_player.position = Vector2(player.position.x * 100 ,player.position.z * 100)

func generate_tilemap():
	for i in range(MINX,MAXX + 1):
		for j in range(MINY,MAXY + 1):
			if gridmap.get_cell_item(Vector3(i,0,j)) == 0:
				#print("found wall")
				tilemap.set_cell(0,Vector2(i,j), 0,Vector2.ZERO)
