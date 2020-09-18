extends HBoxContainer

onready var tile = preload("res://src/BonusTile.tscn")
onready var player = get_node("../../../Player")
onready var tween: Tween = get_node("../Tween")
onready var title: Label = get_node("../BonusTitle")
onready var game = get_node("../../..")

var bonuses = []

func show_title():
	tween.interpolate_property(title, "rect_scale", Vector2.ZERO, Vector2.ONE, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	
func hide_title():
	tween.interpolate_property(title, "rect_scale", Vector2.ONE, Vector2.ZERO, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	
func update_title(num: int, amount: int):
	if amount == 1:
		title.text = "Pick a bonus!"
		
	if num == amount - 1 && amount > 1:
		title.text = "Pick one final bonus!"
		
	if 0 - 1 && amount > 1:
		title.text = "Pick " + (amount - num) as String + " bonuses!"
	elif num < amount - 1 && amount > 1:
		title.text = "Pick " + (amount - num) as String + " more bonuses!"

func show_bonuses(num: int, amount: int):
	yield(get_tree().create_timer(1.5), "timeout")
	
	if player:
		player.picking_bonus = true
		yield(get_tree().create_timer(1.5), "timeout")
		
		update_title(num, amount)
		show_title()
	
		for index in range(5):
			var bonus = tile.instance()
			bonus.modulate.a = 0;
			add_child(bonus)
			bonus.setup(get_bonus(), index)
			bonuses.append(bonus)
			bonus.slide(index * 0.15)

func hide_bonuses():
	hide_title()
	var delay = 0.0
	for bonus in bonuses:
		bonus.slide_and_free(delay)
		delay += 0.15
		
	bonuses.clear()
	
func add_enemy_bonuses(index: int):
	yield(get_tree().create_timer(0.5), "timeout")
	var b1 = bonuses[index - 1]
	b1.add_stamp(false)
	game.enemy_pick(b1.bonus)
	yield(get_tree().create_timer(0.3), "timeout")
	var b2 = bonuses[(index + 1) % bonuses.size()]
	b2.add_stamp(false)
	game.enemy_pick(b2.bonus)
	
func get_bonus():
	var bonuses = [
		{
			"title": "MAX HP",
			"desc": "{value}",
			"texture": "hp",
			"key": "hp_max",
			"type": "add",
			"value": 1 + randi() % 4
		},
		{
			"title": "MAX HP",
			"desc": "{value}",
			"texture": "hp",
			"key": "hp_max",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "DAMAGE",
			"desc": "{value}",
			"texture": "damage",
			"key": "damage",
			"type": "add",
			"value": 1 + randi() % 3
		},
		{
			"title": "DAMAGE",
			"desc": "{value}",
			"texture": "damage",
			"key": "damage",
			"type": "multiply",
			"value": rand_range(1.1, 1.9)
		},
		{
			"title": "SPEED",
			"desc": "{value}",
			"texture": "speed",
			"key": "speed",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "RANGE",
			"desc": "{value}",
			"texture": "range",
			"key": "shot_range",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "FIRE RATE",
			"desc": "{value}",
			"texture": "firerate",
			"key": "fire_rate",
			"type": "multiply",
			"value": rand_range(1.1, 1.75)
		},
		{
			"title": "SHOT SPEED",
			"desc": "{value}",
			"texture": "shotspeed",
			"key": "shot_speed",
			"type": "multiply",
			"value": rand_range(1.05, 1.5)
		},
		{
			"title": "FULL HEAL",
			"desc": "Patched up!",
			"texture": "heal",
			"key": "heal",
			"type": "custom",
			"value": 0
		},
		{
			"title": "LUCKY",
			"desc": "More HP drops",
			"texture": "luck",
			"key": "luck",
			"type": "add",
			"value": 0.1
		},
		{
			"title": "HELPER",
			"desc": "+1 Shooter",
			"texture": "helper",
			"key": "drone",
			"type": "custom",
			"value": 0
		},
		{
			"title": "PATIENCE",
			"desc": "+1 Picks",
			"texture": "patience",
			"key": "picks",
			"type": "add",
			"value": 1
		},
		{
			"title": "POINTS",
			"desc": "+{value}",
			"texture": "points",
			"key": "points",
			"type": "custom",
			"value": (1 + randi() % 10) * 1000
		},
		{
			"title": "MULTIPLIER",
			"desc": "x{value}",
			"texture": "points",
			"key": "multiplier",
			"type": "custom",
			"value": 2 + randi() % 4
		}
	]
	
	return bonuses[randi() % bonuses.size()]
