# packet-analyzer
packet-analyzer is a simple Wireshark frame dissector plugin written in Lua, which provides easily cross platform dissection for viewing customized protocols.
The main reason for using the plugin is the need to read custom payloads, which have no official known protocol.

For more information about Lua dissectors: https://wiki.wireshark.org/Lua

# usage
1. To dissect packets place both sub_protocol.lua, fields-properties.lua in the Wireshark plugins directory (may need to be created).

    The standard user path on Windows install  
    %APPDATA%\Wireshark\plugins\

    On a linux install use:  
    //usr/share/wireshark/plugins
    
     On a macOs install use:  
    /Users/usr/.config/wireshark/plugins

1. Set the custom protocol properties in 'fields-properties' file
1. Open Wireshark, or load Lua plugins while Wireshark is open with command/ctrl+shift+l

# Example - Kafka network sniffer
The [attached](https://wiki.wireshark.org/SampleCaptures?action=AttachFile&do=get&target=kafka-testcases-v4.tar.gz)/create-topics Kafka capture, contains TCP frames assign to a Kafka broker.
The new sub-protocol, parse kafka messages of type 19 (create-topic)

```lua

-- wireshark_filter: filter parameter from Wireshark
-- https://www.wireshark.org/docs/man-pages/wireshark-filter.html
wireshark_filter = "kafka.api_key"

-- filter_value: currently, only '==' is supported
filter_value = 19

```

The fields fetched in the example are: 
API Key, Client ID, Topic Name, Number of partitions, Replication factor

```lua

fields={
  --  {start,number of bytes,type: HEX/DEC/ASCII,field label},
    {66,2,"DEC","API Key"},
    {75,6,"ASCII","Client ID"},
    {86,11,"ASCII","Topic Name"},
    {95,4,"DEC","Number of partitions"},
    {99,2,"DEC","Replication factor"},
}

```
Wireshark already has a Kafka dissector script, so the result can be compared and checked.  
On Wireshark, when API Key is 19, the frame contains a new tree:

![sub-tree frame](https://user-images.githubusercontent.com/58383975/109509431-8be47900-7aa9-11eb-84cd-361215b7c851.png)
