
-- wireshark_filter: filter parameter from Wireshark
-- https://www.wireshark.org/docs/man-pages/wireshark-filter.html
wireshark_filter = "kafka.api_key"

-- filter_value: currently, only '==' is supported
filter_value = 19

fields={
  --  {start,number of bytes,type: HEX/DEC/ASCII,field label},
    {66,2,"DEC","API Key"},
    {75,6,"ASCII","Client ID"},
    {86,11,"ASCII","Topic Name"},
    {95,4,"DEC","Number of partitions"},
    {99,2,"DEC","Replication factor"},
}

my_protocol_name = "Create Kafka Topic sub-protocol"
my_protocol_id = "KAFKA_CREATE_TOPIC"