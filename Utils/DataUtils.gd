class_name DataUtils
extends Resource

const PLAYER_SAVE_FILE := "user://player_data.json"
const PLAYER_SETTINGS_FILE := "user://player_settings.json"

static func load_player_data() -> void:
	var player_data = JsonUtils.read_json_file(PLAYER_SAVE_FILE)
	# Load the data
	if player_data != {}:
		GameManager.coins_player_purse = player_data["coins"]
		var items_array: Array = []
		ShopMenu.load_item_list(items_array)
		if player_data.has("inventory"):
			for item_id in player_data["inventory"]:
				var item_to_add: GameItem = items_array[items_array.find_custom(ShopMenu.item_id_is_equal.bind(int(item_id)))]
				GameManager.player_inventory[item_to_add] = int(player_data["inventory"][item_id])
		if player_data.has("hotbar"):
			for i in range(3):
				if player_data["hotbar"][i] != null:
					var item_to_add: GameItem = items_array[items_array.find_custom(ShopMenu.item_id_is_equal.bind(int(player_data["hotbar"][i])))]
					GameManager.player_hotbar[i] = item_to_add
		if player_data.has("character"):
			GameManager.player_character = player_data["character"]
	else:
		save_player_data()

static func get_player_data() -> Dictionary:
	return JsonUtils.read_json_file(PLAYER_SAVE_FILE)

static func save_player_data(thing_to_save: String="") -> void:
	# Put the data in a dictionary
	# If there is already data for the player, use those for defaults
	var player_data := get_player_data()
	if player_data != {}:
		match thing_to_save:
			"coins":
				player_data["coins"] = GameManager.coins_player_purse
			"inventory":
				if GameManager.player_inventory != {}:
					for item: GameItem in GameManager.player_inventory:
						player_data["inventory"][str(item.ID)] = GameManager.player_inventory[item]
			"hotbar":
				for i in range(3):
					if GameManager.player_hotbar[i] != null:
						player_data["hotbar"][i] = GameManager.player_hotbar[i].ID
			"character":
				player_data["character"] = GameManager.player_character
	else: # Set default data before even saving anything
		player_data["coins"] = 0
		player_data["inventory"] = {}
		player_data["hotbar"] = [null, null, null]
		JsonUtils.write_json_file(PLAYER_SAVE_FILE, player_data)
		save_player_data(thing_to_save)
		return
	
	JsonUtils.write_json_file(PLAYER_SAVE_FILE, player_data)

static func load_player_settings() -> Dictionary:
	return JsonUtils.read_json_file(PLAYER_SETTINGS_FILE)

static func save_player_settings(settings_dict: Dictionary) -> void:
	JsonUtils.write_json_file(PLAYER_SETTINGS_FILE, settings_dict)
