/// @description Process LWO
lwo_process("e_draw");
draw_text(32,32,"Number of LWO instances: " + string(lwo_count()));
//var _array = array_create(10000);
//var _i = 0;
/*var _size = ds_list_size(listc);
for(var i = 0; i < _size; ++i) {
	var _inst = listc[| i];
	//show_debug_message(_inst);
	if (_inst[0] != undefined) {
		_inst[1]();	
		//if (lwo_count() != 0) {_inst[0]._func_array_e_draw[@ 0] = undefined; lwo_destroy(lwo_find(i));}
		/*delete _inst[@ 0];
		ds_list_delete(listc,i);
		--i;
		--_size;*/
/*	} else {
		ds_list_delete(listc,i);	
		--i;
		--_size;
	}
}
//show_debug_message(lwo_count());
//repeat(10000) func();
/*
for(var _i = 0; _i < size; ++_i) {
	xx[_i]++;
	yy[_i]++;
	draw_sprite(spr_test,0,xx[_i],yy[_i]);
}