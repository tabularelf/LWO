// We create a custom struct, while we inheritanced the lwo_struct for general usage.

function lwo_test(_x, _y) : lwo_struct() constructor {
	
	// Create Event
	x = _x;
	y = _y;
	z = 100;
	xstart = _x;
	ystart = _y;
	blend = make_color_hsv(irandom(255),irandom(255),255);
	
	// We also have control of the hidden destroy event.
	e_destroy = LWO_EVENT_START 
		show_debug_message("Goodbye cruel world! " + string(id));
	LWO_EVENT_END
	
	
	// Commented out by default as there's some performance losses when processing more than one event.
	// I've yet to find a more optimial solution, but this seems to be more of an issue in regards to
	// Function calls. Which is a bummer, given that this system was meant to be fairly easy to
	// Adapt to. I'll probably change it up later to better accomodate things.
	// In the meantime, just use the draw event and process everything from there.
	
	// Step Event
	/*e_step = LWO_EVENT_START
	
	x = xstart + (cos(current_time/100)*4);
	y = ystart + (sin(current_time/100)*2);
	
	LWO_EVENT_END*/
	
	// Draw Event
	e_draw = LWO_EVENT_START
	
	//matrix_set(matrix_world,matrix_build(x,y,z,0,0,0,1,1,1));
	draw_sprite_ext(spr_test,0,x + (cos(current_time/100)*2),y + (sin(current_time/100)*2),1,1,0,blend,1);
	
	LWO_EVENT_END
}