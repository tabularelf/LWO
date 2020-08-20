/// @description Init LWO Instances
repeat(100) {
	lwo_create(new lwo_test(irandom(1024),irandom(1024)));	
}