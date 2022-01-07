extends Control

const HEART_PX_WIDE = 15

var err1
var err2
var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * HEART_PX_WIDE

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * HEART_PX_WIDE

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	err1 = PlayerStats.connect("health_changed", self, "set_hearts")
	err2 = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
