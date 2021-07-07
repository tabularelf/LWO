//gc_enable(true);
//show_debug_message(gc_target_frame_time(1000000));
repeat(10) 
//{instance_create_depth(256+irandom(512),128+irandom(512),0,obj_test);} 
{var _inst = lwo_create(new lwo_test(256+irandom(512),128+irandom(512)));}

/*arrr[1000000] = 0;
for(var _i=0; _i < 300000; ++_i) {
	arrr[_i] = {test: 0};	
}*/
var func = function() {
	x = 0;	
}
var _list = ds_list_create();
ds_list_add(_list,func);

var array = [func];
var _t = get_timer();
repeat(1) {
	var _i = array[0]();
}
//show_message(get_timer()-_t);

/// @description Init LWO Instances
/*repeat(0) {
	//lwo_create(new lwo_test(256+irandom(512),128+irandom(512)));	
}


//inst = lwo_create(new lwo_test(32,320));
*/
/*lista = ds_list_create();
listb = ds_list_create();
*//*listc = ds_list_create();
/*repeat(1000) {
	ds_list_add(lista,[{test : true, id : ++idd},function() { x += 32; y += 32; }]);	
}

repeat(1000) {
	ds_list_add(listb,[{test : true, id : ++idd},function() { x += 32; y += 32; }]);	
}
*/
/*repeat(10000) {
	var _inst = lwo_create(new lwo_test(256+irandom(512),128+irandom(512)));
	var _func_array = [_inst,method(_inst,_inst.e_draw)];
	//_inst._func_array_e_draw = _func_array;
	ds_list_add(listc,_func_array);	
}/**

/*func = function() {
	inst.e_step();
}*/

/*size = 10000;
xx[size] = 0;
yy[size] = 0;