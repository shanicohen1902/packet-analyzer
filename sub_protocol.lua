require("fields-properties")

my_protocol = Proto(my_protocol_id, my_protocol_name)
filter_field = Field.new(wireshark_filter)

-- From hex representation to string/number
local data_type_function = {}
data_type_function["HEX"]  = function(tvb,start,len) return tvb(start,len) end
data_type_function["ASCII"]  = function(tvb,start,len) return unhex(tostring(tvb:bytes()(start,len))) end
data_type_function["DEC"]  = function(tvb,start,len) return tonumber(tostring(tvb(start,len)),16) end

-- Subscribe to wireshark post dissector
register_postdissector(my_protocol)

-- Main 
function dissect(tvb, pinfo, tree)
    
     if filter_field() and filter_match(filter_field()) then
          pinfo.cols.protocol = my_protocol.name
          subtree = tree:add(my_protocol, tvb(), "My Protocol Information")

          for k in pairs(fields) do
               start = fields[k][1]
               len = fields[k][2]
               label = fields[k][4]
               data_type = fields[k][3]
               data = data_type_function[data_type](tvb,start,len)
               subtree:add(label .. ": " .. data)
          end
     end
end
--
function filter_match(packet_filter_val)
     if type(filter_value) == "string" then  
          return tostring(packet_filter_val) == tostring(filter_value) 
     elseif type(filter_value) == "number" then  
          return tonumber(tostring(packet_filter_val)) == filter_value
     end   
end
--
function unhex( input )
     return (input:gsub( "..", function(c)
         return string.char( tonumber( c, 16 ) )
     end))
 end
--
function my_protocol.dissector(tvb, pinfo, tree)
     dissect(tvb, pinfo, tree)
end

