# nodemcu files for simple IoT
# supported-  Thingspeak

Problem statement-  nodemcu hangs up while communicating to/from Thingspeak via Ardiuno firmware
Maybe Arduino firmware doesn't have good memory management. So I decided to use Nodemcu-firmware written in Lua.


But then I realized that getting data from Thingspeak is not as easy as posting into Thingspeak

So I have created the easiest files for sending and reading data- almost in an Arduino manner.

Examples will be present in test.lua
Read, Write API etc are present in credentials.lua
any other changes, like channel name are present in speak2thing.lua


If you appreciate this prject, let me know here on github..
Thanks,
