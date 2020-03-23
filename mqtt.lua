living_light = 0
kitchen_light = 0
dining_light = 0

dofile("states.lua")

status_led = false

local mqtt_prefix = "/shiweizhi/light"

local m = mqtt.Client("esp8266"..tostring(node.chipid(), 60))

local status_tmr = tmr.create()
status_tmr:register(2000, tmr.ALARM_AUTO, 
function()
    status_led = true
    m:publish(mqtt_prefix.."/living/status", tostring(living_light), 0, 0)
    m:publish(mqtt_prefix.."/kitchen/status", tostring(kitchen_light), 0, 0)
    m:publish(mqtt_prefix.."/dining/status", tostring(dining_light), 0, 0)
end)

m:lwt(mqtt_prefix.."/status", "0", 2, 1)

m:on("connect",
function()
    print("MQTT connected")
    print("Uploading status")
    status_tmr:start()
    m:publish(
        mqtt_prefix.."/status",
        tostring(1),
        2,
        1
    )
    m:subscribe({
        [mqtt_prefix.."/living/power"]=2, 
        [mqtt_prefix.."/kitchen/power"]=2, 
        [mqtt_prefix.."/dining/power"]=2},
    function()
        print("MQTT subscribed")
    end)
end)

m:on("message",
function(client, topic, msg)
    print("Recive: "..topic .. " ".. msg)
    if topic == mqtt_prefix.."/living/power" then
        if msg == "0" or msg == "1" then 
            if living_light == 0 then 
                living_light = 1
            else  
                living_light = 0
            end
        end
        save_state()
    end
    if topic == mqtt_prefix.."/kitchen/power" then
        if msg == "0" or msg == "1" then 
            kitchen_light = tonumber(msg)
        end
        save_state()
    end
    if topic == mqtt_prefix.."/dining/power" then
        if msg == "0" or msg == "1" then 
            dining_light = tonumber(msg)
        end
        save_state()
    end
    
end)

m:on("offline",
function()
    status_tmr:stop()
    status_led = false
    m:connect("broker.hivemq.com", 1883, false)
end
)

m:connect("broker.hivemq.com", 1883, false)

dofile("lights.lua")
dofile("btn.lua")