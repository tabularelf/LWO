<div align="center">

# LWO v1.0 - Light Weight Objects for GameMaker Studio 2.3.0
</div>

This is a system I'm designing to use as light weight objects for some of my upcoming projects. These take advantage of GameMaker's newly featured structs, and allows you to make your own objects, without all of the unnecessary variables/bloat that comes attached with objects. 

Note: In the future, I might merge out step and draw to be one.


## Functions
`lwo_create(struct)`

Provides the necessary information via said struct, adding it to the LWO System. Returns struct.

i.e. 

`lwo_create(new lwo_test(x,y));`



`lwo_count()`

Returns the current number of LWO instances.

`lwo_find(id)`

Returns the specific struct if found. Otherwise returns undefined.

`lwo_destroy([id],[execute destroy (bool)])`

Destroys struct with either ID provided, or will obtain current ID executing within loop. Though, it's recommended for best practice to use the id of the LWO instance, as the system doesn't have a very reliable way of handling things as of yet.

`lwo_process(event)`

Processes all LWO specific events. Currently step and draw events are supported only. Though it's recommended to only use one of the two, as processing multiple events degrades performance.

`lwo_free()`

Only use when you absolutely no longer need LWO system. Will free the LWO system from memory. As of currently, there's no way to recreate the LWO System besides restarting the game.

`lwo_clear()`

Removes all structs from memory.

# Macros

`LWO_EVENT_START` mimics `function() {`. 
It isn't necessary to use, but makes it somewhat cleaner to read through.

`LWO_EVENT_END` mimics `}`

To end a `LWO_EVENT_START`. Not much else to say.
