_G.u2_mod_manager = _G.u2_mod_manager or {}

Hooks:Add("LocalizationManagerPostInit", "u2_mod_manager_strings", function(loc)
    LocalizationManager:add_localized_strings({
		u2_mod_manager_title = "Mod Manager",
		u2_mod_manager_desc = "View and change the settings of your mods",
	})
end)

function MenuCallbackHandler:sliderTest(item)
    log("Slider value: " .. tostring(math.floor(item:value() + 0.5)) .. "\n")
    --LocalizationStringManagerSliderCallBack("string_id_2", tostring(item:value()))
end
    
function MenuCallbackHandler:toggleTest(item)
    log("Toggle value: " .. tostring(item:value()) .. "\n")
    --LocalizationStringManagerBooleanCallBack("string_id_1")
end
 
function MenuCallbackHandler:toggleTest2(item)
    log("Toggle value: " .. tostring(item:value()) .. "\n")
end
 
function MenuCallbackHandler:multichoiceTest(item)
    log("Multichoice value: " .. tostring(item:value()) .. "\n")
    --LocalizationStringManagerMultiChoiceCallBack("string_id_3", tostring(item:value()))
end

local menu_manager_init_orig = MenuManager.init
function MenuManager:init(is_start_menu)
	menu_manager_init_orig(self, is_start_menu)
	u2_mod_manager:addCustomMenu()
end

function u2_mod_manager:addSubmenu(name, title, desc, parent)
	local mainMenuNodes = managers.menu._registered_menus.menu_main and managers.menu._registered_menus.menu_main.logic._data._nodes or managers.menu._registered_menus.menu_pause.logic._data._nodes
		
	local newNode = deep_clone(mainMenuNodes.video)
	newNode._items = {}
	
	MenuManager:add_back_button(newNode)
	mainMenuNodes[name] = newNode
	
	local button = deep_clone( mainMenuNodes.options._items[1] )
	button._parameters.name = name
	button._parameters.text_id = title
	button._parameters.help_id = desc
	button._parameters.next_node = name

	parent:add_item(button)
	return newNode
end

function u2_mod_manager:addMultichoice(name, title, desc, cbk, value, parent)
	local data = {
		type = "MenuItemMultiChoice",
		{
			_meta = "option",
			text_id = "multichoice0",
			value = 0
		},
		{
			_meta = "option",
			text_id = "multichoice1",
			value = 1
		}
	}
	
	local params = {
		name = name,
		text_id = title,
		help_id = desc,
		callback = cbk,
		filter = true
	}
	
	local menuItem = parent:create_item(data, params)
	menuItem:set_value( math.clamp(value, data.min, data.max) or data.min )
	parent:add_item(menuItem)
end

function u2_mod_manager:addSlider(name, title, desc, cbk, value, parent)
	local data = {
		type = "CoreMenuItemSlider.ItemSlider",
		min = 0,
		max = 1,
		step = 0.1,
		show_value = true
	}

	local params = {
		name = name,
		text_id = title,
		help_id = desc,
		callback = cbk,
		disabled_color = Color(0.25, 1, 1, 1),
	}

	local menuItem = parent:create_item(data, params)
	menuItem:set_value( math.clamp(value, data.min, data.max) or data.min )
	parent:add_item(menuItem)
end

function u2_mod_manager:addToggle(name, title, desc, cbk, value, parent)
	local data = {
		type = "CoreMenuItemToggle.ItemToggle",
		{
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			value = true,
			x = 24,
			y = 0,
			w = 24,
			h = 24,
			s_icon = "guis/textures/menu_tickbox",
			s_x = 24,
			s_y = 24,
			s_w = 24,
			s_h = 24
		},
		{
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			value = false,
			x = 0,
			y = 0,
			w = 24,
			h = 24,
			s_icon = "guis/textures/menu_tickbox",
			s_x = 0,
			s_y = 24,
			s_w = 24,
			s_h = 24
		}
	}

	local params = {
		name = name,
		text_id = title,
		help_id = desc,
		callback = cbk,
		disabled_color = Color( 0.25, 1, 1, 1 ),
		icon_by_text = false
	}

	local menuItem = parent:create_item( data, params )
	menuItem:set_value( value and true or false )
	parent:add_item( menuItem )
end

function u2_mod_manager:addCustomMenu()
	local mainMenuNodes = managers.menu._registered_menus.menu_main and managers.menu._registered_menus.menu_main.logic._data._nodes or managers.menu._registered_menus.menu_pause.logic._data._nodes
	
	local menuEntry = deep_clone(mainMenuNodes.video)
	menuEntry._items = {}
	
	MenuManager:add_back_button(menuEntry)
	mainMenuNodes["u2_mod_manager_title"] = menuEntry

	local optionsButton = deep_clone( mainMenuNodes.options._items[1] )
	optionsButton._parameters.name = "u2_mod_manager_title"
	optionsButton._parameters.text_id = "u2_mod_manager_title"
	optionsButton._parameters.help_id = "u2_mod_manager_desc"
	optionsButton._parameters.next_node = "u2_mod_manager_title"
	mainMenuNodes.options:add_item(optionsButton)
	--table.insert( mainMenuNodes.options._items, optionsButton )
	
	local submenu = u2_mod_manager:addSubmenu("test_submenu", "submenu", "submenudesc", menuEntry)
	u2_mod_manager:addToggle("test_toggle2", "toggle2", "toggledesc2", "toggleTest2", true, submenu)
	u2_mod_manager:addToggle("test_toggle", "toggle", "toggledesc", "toggleTest", true, menuEntry)
	u2_mod_manager:addSlider("test_slider", "slider", "sliderdesc", "sliderTest", 0, menuEntry)
	u2_mod_manager:addMultichoice("test_multichoice", "multichoice", "multichoicedesc", "multichoiceTest", 0, menuEntry)
	u2_mod_manager:addToggle("test_toggle2", "toggle2", "toggledesc2", "toggleTest2", true, menuEntry)
end