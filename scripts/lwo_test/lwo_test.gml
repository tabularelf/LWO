// We create a custom struct, while we inheritanced the lwo_struct for general usage.

/*function lwo_test_estep() {
	
	//x = xstart;
	//y = ystart;
	
	if mouse_check_button_released(mb_left) {
		lwo_destroy(id,false);	
	}
}*/

function lwo_test(_x, _y) : lwo_struct() constructor {
	
	#region Create Event
	x = _x;
	y = _y;
	z = 100;
	xstart = _x;
	ystart = _y;
	blend = make_color_hsv(irandom(255),irandom(255),255);
	timer = irandom(60*100);
	#endregion
	
	#region Destroy Event
	// We also have control of the hidden destroy event.
	static e_destroy = function() { 
		show_debug_message("Goodbye cruel world! " + string(id));
	}
	
	#endregion
	#region Step Event
	// Commented out by default as there's some performance losses when processing more than one event.
	// I've yet to find a more optimial solution, but this seems to be more of an issue in regards to
	// Function calls. Which is a bummer, given that this system was meant to be fairly easy to
	// Adapt to. I'll probably change it up later to better accomodate things.
	// In the meantime, just use the draw event and process everything from there.
	
	// Step Event
	static e_step = function() {
	
	//x = xstart;
	//y = ystart;
	
	if mouse_check_button_released(mb_left) {
		lwo_destroy(id,false);	
	}
}
	
	//}
	#endregion
	
	#region Draw Event
	// Draw Event
	
	/*e_draw = function() {
	
	//matrix_set(matrix_world,matrix_build(x,y,z,0,0,0,1,1,1));
	//draw_sprite_ext(spr_test,0,x + (cos(current_time/100)*2),y + (sin(current_time/100)*2),1,1,0,blend,1);
	draw_sprite(sprite_index,image_index,x,y);
	//draw_text(x,y,id);
	// We have a timer to it's ultimate demise.
	if (timer == 0) {
		//lwo_destroy();
	} else {
		//--timer;
	}
	
	}*/
	#endregion
}