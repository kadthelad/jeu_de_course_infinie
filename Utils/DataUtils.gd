class_name DataUtils
extends Resource

const PLAYER_SAVE_FILE := "user://player_data.json"
const PLAYER_SETTINGS_FILE := "user://player_settings.json"

static func load_player_data() -> void:
	var player_data = JsonUtils.read_json_file(PLAYER_SAVE_FILE)
	# Load the data
	if player_data != {}:
		GameManager.coins_player_purse = player_data["coins"]
		if player_data.has("inventory"):
			for item_id in player_data["inventory"]:
				var items_array: Array = []
				ShopMenu.load_item_list(items_array)
				var item_to_add: GameItem = items_array[items_array.find_custom(ShopMenu.item_id_is_equal.bind(int(item_id)))]
				GameManager.player_inventory[item_to_add] = int(player_data["inventory"][item_id])

static func save_player_data() -> void:
	# Put the data in a dictionary
	var player_data := {}
	player_data["coins"] = GameManager.coins_player_purse
	player_data["inventory"] = {}
	if GameManager.player_inventory != {}:
		for item: GameItem in GameManager.player_inventory:
			player_data["inventory"][str(item.ID)] = GameManager.player_inventory[item]
	JsonUtils.write_json_file(PLAYER_SAVE_FILE, player_data)

static func load_player_settings() -> Dictionary:
	return JsonUtils.read_json_file(PLAYER_SETTINGS_FILE)

static func save_player_settings(settings_dict: Dictionary) -> void:
	JsonUtils.write_json_file(PLAYER_SETTINGS_FILE, settings_dict)
