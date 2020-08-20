// Init LWO System
#region Initialize
// Basic info about LWO.
#macro LWO_VERSION "1.0"
#macro LWO_CREDITS "LWO " + LWO_VERSION + " by TabularElf. https://github.com/tabularelf"

// We use these macros to more easily identify when a function starts and ends for users
// Who aren't too familiar with function() as of yet.
#macro LWO_EVENT_START function() {
#macro LWO_EVENT_END }

// Enums for events.
// Currently only STEP and DRAW are active. Though a secret e_destroy event exists.
// It's more optimal to perform everything within the draw event, but if you need to utilize the step event
// Then you're free to use the step event.
enum lwoEvents {
	BEGIN_STEP,
	STEP,
	END_STEP,
	BEGIN_DRAW,
	DRAW,
	END_DRAW
}

// The Main Constructor for the LWO Constructor
function lwo_struct() constructor {	
	// Events
	e_step = method(undefined, lwo_event_null);
	e_draw = method(undefined, lwo_event_null);
	e_destroy = method(undefined, lwo_event_null);
}

// This is the lwo_system. This is mostly automanaged along with all of the other functions.
// Please don't touch this unless you know what you're doing!
global.__lwo_system = {
	lwo_counter : 0,
	lwo_ids : 0,
	lwo_pos : 0,
	lwo_list :	ds_list_create(),
	//lwo_list_inactive : ds_list_create(),
	lwo_map : ds_map_create(),
	
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
		//ds_list_destroy(lwo_list_inactive);
	}
}

// Output Credits to log
show_debug_message(LWO_CREDITS + " Initalized!"); 

#endregion


#region Functions

/// @function lwo_event_null
/// @description Used within lwo_struct events. This allows the system to continue processing without much of a fuss.
function lwo_event_null() {
	return 0;	
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
	return global.__lwo_system.lwo_map[? _id];	
}

/// @function lwo_create
/// @param struct
/// @description Use case: lwo_create(new lwo_test(x,y)). This is to ensure that the lwo instance is properly added to the system. Returns struct.
function lwo_create(_lwo) {	
	// Give it an ID
	_lwo.id = global.__lwo_system.lwo_ids++;
	
	// Add to database

	ds_list_add(global.__lwo_system.lwo_list,_lwo);
	global.__lwo_system.lwo_map[? _lwo.id] = _lwo;
	global.__lwo_system.lwo_counter = ds_list_size(global.__lwo_system.lwo_list);
	global.__lwo_system.current_lwo = _lwo;
	//ds_queue_clear()
	return _lwo;
}
	
/// @function lwo_free
/// @description ONLY USE WHEN YOU CLOSE THE PROGRAM!!! lwo_free simply removes the lwo_system from memory, along with all instances.
function lwo_free() {
	global.__lwo_system.lwo_sys_delete();
	delete global.__lwo_system;
}
	
function lwo_clear() {
	global.__lwo_system.lwo_sys_clear();	
}

/// @function lwo_free
/// @param [id]
/// @param [execute_destroy(bool)]
/// @description Removes the lwo instance from memory, executing it's destroy event. Can be disabled with [execute_destroy].
function lwo_destroy() {
	var _id;
	var _execute_destroy = true;
	var _list = global.__lwo_system.lwo_list;
	switch(argument_count) {
		case 0: _id = _list[| global.__lwo_system.lwo_pos]; break;
		case 2: _execute_destroy = argument[1]; case 1: _id = argument[0]; break;
	}
	
	//show_debug_message(_id);
	if !is_struct(_id) throw "Not a struct! " + string(_id);
		var _list_pos = ds_list_find_index(_list,_id);
		if (_list_pos != -1) {
		global.__lwo_system.lwo_counter--;
		//global.__lwo_system.lwo_pos--;
		var _idd = _id.id;
		
		// Run Destroy Event
		if(_execute_destroy) _id.e_destroy();
		
		// Remove from Memory, since we no longer need it.
		delete _id;
		ds_list_delete(_list, _list_pos);
		ds_map_delete(global.__lwo_system.lwo_map,_idd);
	}
}


/// @function lwo_process
/// @param event
/// @description Processes all instances with the appropriate event. Currently step and draw are supported.
function lwo_process(_event) {
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
	}
}
	
#endregion