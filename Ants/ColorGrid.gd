extends Control

export var bg = Color.whitesmoke
export var fg = Color.fuchsia
export var rows = 720/10
export var columns = 1080/10

var w
var h
var cw
var ch
var value_grid = {}
var grid_initialized = false
var rng = RandomNumberGenerator.new()
var decay = 0.9

#var nest = get_node('AntNest')


func _ready():
	w = rect_size.x
	h = rect_size.y
	cw = w/columns #cell width
	ch = h/rows #cell height
	rng.randomize()
	init_grid()


func init_grid():
	if grid_initialized == false:
		for row in rows:
			value_grid[row] = {}
			for column in columns:
				value_grid[row][column] = {"nest_count": 0.0, "food_count": 0.0}
		grid_initialized = true


func grid_to_color(row, column):
	var xy_dict = value_grid.get(row, {}).get(column, {})
	var nest_count = xy_dict.get('nest_count')
	var food_count = xy_dict.get('food_count')
#	var ants_roaming = self.nest.max_ants
	var ants_roaming = 1000
	
	return Color(float(nest_count)/float(ants_roaming), 0, float(food_count)/float(ants_roaming))


func get_grid(row, column):
	return value_grid[row][column]


func update_grid(row, column, value):
	value_grid[row][column]['nest_count'] = decay*value_grid[row][column]['nest_count'] + value


func draw_grid():
	for row in value_grid:
		for column in columns:
			var x = cw*column+(cw*0.5)
			var y = ch*row+(ch*0.5)
			draw_rect(Rect2(Vector2(x, y), Vector2(cw, ch)), grid_to_color(row, column))

func _draw():
	draw_grid()

