class_name TrashData


const PATH: String = "user://trash.save"

static var moni: float = 0.0
static var purchasedItems: Array[int]


static func save() -> void:
	# get/create the file
	var file = FileAccess.open(PATH, FileAccess.WRITE)
	
	# store the data
	file.store_8(LevelList.highestLevel)
	file.store_float(TrashData.moni)
	file.store_var(TrashData.purchasedItems)


static func load() -> void:
	# ensure we have data
	if !FileAccess.file_exists(PATH):
		return
	
	# load the file
	var file = FileAccess.open(PATH, FileAccess.READ)
	
	# extract the data
	LevelList.highestLevel = file.get_8()
	TrashData.moni = file.get_float()
	TrashData.purchasedItems = file.get_var()
	
	## check for parsing errors
	#var purchased_items = file.get_line()
	#var json = JSON.new()
	#var result = json.parse(purchased_items)
	#if not result == OK:
		#print("JSON Parse Error: %s in %s at line %s" % [
			#json.get_error_message(), 
			#purchased_items, 
			#json.get_error_line(),
		#])
		#return
	#TrashData.purchasedItems = json.data
