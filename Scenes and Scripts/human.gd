extends CharacterBody2D

var healthy = true
var index
var is_infected

var human_textures = [load("res://GameAssets/Assets/pixel people/person001.png"),
load("res://GameAssets/Assets/pixel people/person003.png"),
load("res://GameAssets/Assets/pixel people/person004.png"), 
load("res://GameAssets/Assets/pixel people/person005.png"), 
load("res://GameAssets/Assets/pixel people/person006.png"),
load("res://GameAssets/Assets/pixel people/person007.png"), 
load("res://GameAssets/Assets/pixel people/person008.png"),
load("res://GameAssets/Assets/pixel people/person009.png"),
load("res://GameAssets/Assets/pixel people/person010.png"),  
load("res://GameAssets/Assets/pixel people/person011.png"),
load("res://GameAssets/Assets/pixel people/person012.png"),
load("res://GameAssets/Assets/pixel people/person013.png"), 
load("res://GameAssets/Assets/pixel people/person014.png"), 
load("res://GameAssets/Assets/pixel people/person015.png")
 ]

var infected_textures = [load("res://GameAssets/Assets/pixel people/person001_infected.png"),
load("res://GameAssets/Assets/pixel people/person003_infected.png"),
load("res://GameAssets/Assets/pixel people/person004_infected.png"),
load("res://GameAssets/Assets/pixel people/person005_infected.png"),
load("res://GameAssets/Assets/pixel people/person006_infected.png"),
load("res://GameAssets/Assets/pixel people/person007_infected.png"),
load("res://GameAssets/Assets/pixel people/person008_infected.png"),
load("res://GameAssets/Assets/pixel people/person009_infected.png"),
load("res://GameAssets/Assets/pixel people/person010_infected.png"),
load("res://GameAssets/Assets/pixel people/person011_infected.png"),
load("res://GameAssets/Assets/pixel people/person012_infected.png"),
load("res://GameAssets/Assets/pixel people/person013_infected.png"),
load("res://GameAssets/Assets/pixel people/person014_infected.png"),
load("res://GameAssets/Assets/pixel people/person015_infected.png"),
]

func _ready() -> void:
	
	#Pick a random human texture from the list on load
	var rand_texture = human_textures.pick_random()
	$Sprite2D.texture = rand_texture
	index = human_textures.find(rand_texture)

func _physics_process(_delta: float) -> void:
	if healthy:
		visible = true
	else:
		$Sprite2D.texture = infected_textures[index]
		$CollisionShape2D.disabled = true

