/// @description Insert description here
// You can write your code in this editor
lwo_process("e_timer");
lwo_process("e_step");
//lwo_process("e_timer");

if keyboard_check(vk_space) lwo_create(new lwo_test(256+irandom(512),128+irandom(512)));	
//lwo_pause(keyboard_check(vk_control));

//repeat(100) func();

/*var _size = ds_list_size(lista);
for(var i = 0; i < _size; ++i) {
	lista[| i]();	
}
*/

if keyboard_check_released(vk_control) {
	repeat(10000) 
//{instance_create_depth(256+irandom(512),128+irandom(512),0,obj_test);} 
{lwo_create(new lwo_test(256+irandom(512),128+irandom(512)));}

}

if mouse_check_button_released(mb_right) {
	LWO_SYSTEM.lwo_sys_delete();
	ds_map_destroy(LWO_SYSTEM.lwo_events);
	delete LWO_SYSTEM;
	//instance_destroy();
}