// Init LWO System
#region Initialize
// Basic info about LWO.
#macro LWO_VERSION "2.0"
#macro LWO_CREDITS "LWO " + LWO_VERSION + " by TabularElf. https://github.com/tabularelf"

/// @function image_speed_get
/// @param sprite_index
/// @description Returns the proper speed setting for the sprite. 
function image_speed_get(_sprite) {
  return sprite_get_speed_type(_sprite) == spritespeed_framespergameframe ? sprite_get_speed(_sprite) : sprite_get_speed(_sprite)/game_get_speed(gamespeed_fps);
}

// The Main Constructor for the LWO Constructor
#macro LWO_SYSTEM global.__lwo_system
function lwo_struct() constructor {	
	// Create basic variables
	x = 0;
	y = 0;
	alarm[0] = 0;
	sprite_index = spr_animated;
	image_index = 0;
	image_speed = 1;
	
	static e_timer = function() {
		alarm[0]--;
	}
	
	static e_draw = function() {
		//gml_pragma("forceinline");
		if (sprite_exists(sprite_index)) {
			image_index += image_speed_get(sprite_index)*image_speed mod sprite_get_number(sprite_index);
			draw_sprite(sprite_index,image_index,x,y);
		}
	}
}

// This is the lwo_system. This is mostly automanaged along with all of the other functions.
// Please don't touch this unless you know what you're doing!
global.__lwo_system = {
	lwo_counter : 0,
	lwo_ids : 0,
	lwo_pos : 0,
	lwo_list :	ds_list_create(),
	lwo_list_inactive : ds_list_create(),
	lwo_map : ds_map_create(),
	lwo_events : ds_map_create(),
	paused : false,
	
	// Functions
	lwo_sys_clear : function() {
		if (ds_list_size(lwo_list) > 0) {
			var _size = lwo_counter;
			for(var _i = 0; _i < _size; ++_i) {
				delete(lwo_list[| 0]);
				ds_list_delete(lwo_list,0);
			}
		}	
	},
	
	lwo_sys_delete : function() {
		lwo_clear();
		ds_map_destroy(lwo_map);
		ds_list_destroy(lwo_list);
		ds_list_destroy(lwo_list_inactive);
	}
}

// Initalize basic events
ds_map_add_list(LWO_SYSTEM.lwo_events,"e_draw",ds_list_create());
ds_map_add_list(LWO_SYSTEM.lwo_events,"e_step",ds_list_create());
ds_map_add_list(LWO_SYSTEM.lwo_events,"e_timer",ds_list_create());

// Output Credits to log
show_debug_message(LWO_CREDITS + " Initalized!"); 

#endregion


#region Functions

/// @function lwo_event_null
/// @description (Deprecated) Used within lwo_struct events. This allows the system to continue processing without much of a fuss.
function lwo_event_null() {
	return 0;	
}

/// @function lwo_pause
/// @description pauses the current LWO
function lwo_pause(_bool) {
	global.__lwo_system.paused = _bool;	
}

/// @function lwo_count
/// @description Return count of current lwo instances
function lwo_count() {
	return global.__lwo_system.lwo_counter;	
}

/// @function lwo_count
/// @param id
/// @description Return struct of instance if found. Otherwise returns undefined.
function lwo_find(_id) {
	return LWO_SYSTEM.lwo_map[? _id].lwo;	
}

/// @function lwo_create
/// @param struct
/// @description Use case: lwo_create(new lwo_test(x,y)). This is to ensure that the lwo instance is properly added to the system. Returns struct.
function lwo_create(_lwo) {	
	// Give it an ID
	_lwo.id = LWO_SYSTEM.lwo_ids++;
	
	// Create memory struct
	var _struct = {
		lwo: _lwo,
		isActive: true,
		events: {}
	}
	var _se = _struct.events;
	// Add to database

	ds_list_add(global.__lwo_system.lwo_list,_struct);
	LWO_SYSTEM.lwo_map[? _lwo.id] = _struct;
	LWO_SYSTEM.lwo_counter = ds_list_size(LWO_SYSTEM.lwo_list);
	//global.__lwo_system.current_lwo = _lwo;
	
	// Register events
	var _map = LWO_SYSTEM.lwo_events;
	var _key = ds_map_find_first(_map);
	while (_key != undefined) {
		var _event = variable_struct_get(_lwo, _key);
		if (_event != undefined) && (is_method(_event)) {
			var _array = [weak_ref_create(_struct),method(_lwo,_event)];
			variable_struct_set(_se,_key,_array);
			ds_list_add(LWO_SYSTEM.lwo_events[? _key],_array);
		}
		_key = ds_map_find_next(_map, _key);
	}	
	return _lwo;
}
	
/// @function lwo_free
/// @description ONLY USE WHEN YOU CLOSE THE PROGRAM!!! lwo_free simply removes the lwo_system from memory, along with all instances.
function lwo_free() {
	LWO_SYSTEM.lwo_sys_delete();
	delete global.__lwo_system;
}
	
function lwo_clear() {
	LWO_SYSTEM.lwo_sys_clear();	
}

/// @function lwo_destroy
/// @param [id]
/// @param [execute_destroy(bool)]
/// @description Removes the lwo instance from memory, executing it's destroy event. Can be disabled with [execute_destroy].
function lwo_destroy() {
	var _memstruct;
	var _execute_destroy = true;
	var _list = LWO_SYSTEM.lwo_list;
	switch(argument_count) {
		case 0: _memstruct = LWO_SYSTEM.lwo_map[? id];/*_list[| global.__lwo_system.lwo_pos];*/ break;
		case 2: _execute_destroy = argument[1]; case 1: _memstruct = LWO_SYSTEM.lwo_map[? argument[0]]; break;
	}
	
	//show_debug_message(_id);
	if !is_struct(_memstruct) throw "Not a struct! " + string(_memstruct);
		var _list_pos = ds_list_find_index(_list,_memstruct);
		if (_list_pos != -1) {
		LWO_SYSTEM.lwo_counter--;
		//global.__lwo_system.lwo_pos--;
		var _id = _memstruct.lwo.id;
		var _lwo = _memstruct.lwo;
		
		// Run Destroy Event
		if(_execute_destroy) {_lwo.e_destroy();}
		
		// Remove from Memory, since we no longer need it.
		
		// Start by removing all of the events from the loop
		var _se = _memstruct.events;
		var _names = variable_struct_get_names(_se);
		var _size = variable_struct_names_count(_se);
		for(var _i = 0; _i < _size; ++_i) {
			delete (variable_struct_get(_se,_names[_i])[@ 0]);	
		}
		delete _se;
		// Delete proper structs
		delete _lwo;
		delete _memstruct;
		ds_list_delete(_list, _list_pos);
		ds_map_delete(LWO_SYSTEM.lwo_map,_id);
	}
}

/// @function lwo_deactivate_id
/// @param id
function lwo_deactivate_id(_id) {
		
}

/// @function lwo_process
/// @param event
/// @description Processes all instances with the appropriate event. Currently step and draw are supported.
function lwo_process(_event) {
	gml_pragma("forceinline");
	var _e_list = LWO_SYSTEM.lwo_events[? string(_event)];
	
	// Error Out
	if (_e_list == undefined) {show_debug_message("LWO Error: Invalid Event: " + string(_event) + " Exiting..."); return -1;}
	
	var _size = ds_list_size(_e_list);
	for(var _i = 0; _i < _size; ++_i) {
		LWO_SYSTEM.lwo_pos = _i;
		var _inst = _e_list[| _i];

		if (weak_ref_alive(_inst[0])) {
			_inst[1]();	
			//show_debug_message(ptr(_inst[0].lwo));
		} else {
			ds_list_delete(_e_list,_i);	
			--_i;
			--_size;
		}
		
	} 
	/*if (global.__lwo_system.paused) exit;
	var _size = global.__lwo_system.lwo_counter;
	var _list = global.__lwo_system.lwo_list;
	
	// Loop
	for(global.__lwo_system.lwo_pos = 0; global.__lwo_system.lwo_pos < _size; ++global.__lwo_system.lwo_pos) {
		var _lwo = _list[| global.__lwo_system.lwo_pos];
		//show_debug_message(global.__lwo_system.lwo_pos);
		//show_debug_message(_lwo);
		if is_undefined(_lwo) {
			ds_list_delete(_list,global.__lwo_system.lwo_pos);
			--_size;
			--global.__lwo_system.lwo_pos;
			//--global.__lwo_system.lwo_pos;
			--global.__lwo_system.lwo_counter;
		} else {
			// Check for Event Type and execute base upon type
			var _func = undefined;
			switch(_event) {
				case lwoEvents.STEP: _func = _lwo.e_step; break;
				case lwoEvents.DRAW: _func = _lwo.e_draw; break;
			}
			
			if is_method(_func) {
				_func();	
			}
		}
	}*/
}
	
#endregion