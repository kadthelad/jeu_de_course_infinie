class_name ShopMenu
extends CanvasLayer

# Constants
const ITEMS_PATH := "res://Entities/Items/GameItems/"

# Onready
@onready var purse_label: Label = %PurseLabel
@onready var shop_item_list: ItemList = %ShopItemList
@onready var description_text_edit: TextEdit = %DescriptionTextEdit
@onready var buy_one_button: Button = %BuyOneButton
@onready var buy_five_button: Button = %BuyFiveButton
@onready var buy_ten_button: Button = %BuyTenButton
@onready var player_inventory_item_list: ItemList = %PlayerInventoryItemList

# Variables
var items_array: Array[GameItem] = []
var selected_item: GameItem = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_data()
	update_ui()
	
	GameManager._update_game_ui.connect(update_ui)

func update_ui() -> void:
	purse_label.text = "%s: %s" % [tr("game_total_coins"), str(GameManager.coins_player_purse)]
	
	# Player's inventory
	player_inventory_item_list.clear()
	for item: GameItem in GameManager.player_inventory:
		player_inventory_item_list.add_item("%s [%s]" % [item.i_name, GameManager.player_inventory[item]])

static func load_item_list(items_array_to_add: Array) -> void:
	# Add existing items in items_array
	var dir_access := DirAccess.open(ITEMS_PATH)
	if dir_access:
		for file in dir_access.get_files():
			items_array_to_add.append(ResourceLoader.load(ITEMS_PATH + file))

func show_data() -> void:
	# Load the items for the shop:
		load_item_list(items_array)
		for item: GameItem in items_array:
			shop_item_list.add_item("%s [%s %s]" % [item.i_name, str(item.price), tr("game_coins")], item.icon)
			shop_item_list.set_item_metadata(shop_item_list.item_count-1, item.ID)

func buy_item(quantity: int) -> void:
	var price_to_pay := selected_item.price * quantity
	if selected_item == null:
		return
	if GameManager.coins_player_purse >= price_to_pay:
		GameManager.coins_player_purse -= price_to_pay
		for i in range(quantity):
			if GameManager.player_inventory.has(selected_item):
				GameManager.player_inventory[selected_item] += 1
			else:
				GameManager.player_inventory[selected_item] = 1
		
		# Save changes
		DataUtils.save_player_data()
		update_ui()

static func item_id_is_equal(item: GameItem, item_id: int) -> bool:
	if item.ID == item_id:
		return true
	return false

func _on_shop_item_list_item_selected(index: int) -> void:
	var selected_item_id: int = shop_item_list.get_item_metadata(index)
	selected_item = items_array[items_array.find_custom(item_id_is_equal.bind(selected_item_id))]
	#PrintUtils.print_dbg("selected item with ID: " + str(selected_item_id) + 
	#". This item is a " + selected_item.i_name)
	
	# Update the UI for the selected item's information
	description_text_edit.text = selected_item.description
	buy_one_button.text = "%s (%s %s)" % [tr("shop_menu_buy_one"), str(selected_item.price), tr("game_coins")]
	buy_five_button.text = "%s (%s %s)" % [tr("shop_menu_buy_five"), str(selected_item.price*5), tr("game_coins")]
	buy_ten_button.text = "%s (%s %s)" % [tr("shop_menu_buy_ten"), str(selected_item.price*10), tr("game_coins")]

func _on_back_button_pressed() -> void:
	queue_free()

# Buy Buttons
func _on_buy_one_button_pressed() -> void:
	buy_item(1)

func _on_buy_five_button_pressed() -> void:
	buy_item(5)

func _on_buy_ten_button_pressed() -> void:
	buy_item(10)
