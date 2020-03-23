local btn_left = 2
local btn_right = 3
local btn_bottom = 1

gpio.mode(btn_left, gpio.INPUT, gpio.PULLUP)
gpio.mode(btn_right, gpio.INPUT, gpio.PULLUP)
gpio.mode(btn_bottom, gpio.INPUT, gpio.PULLUP)

local btn_timestamp = 0;

gpio.trig(btn_left, "down", 
function(level, when, eventcount)
    if tmr.now() - btn_timestamp > (0.5*1000*1000) then
        btn_timestamp = tmr.now()
        living_light = 1 - living_light
    end
    save_state()
end)

gpio.trig(btn_right, "down",
function(level, when, eventcount)
    if tmr.now() - btn_timestamp > (0.3*1000*1000) then
        btn_timestamp = tmr.now()
        kitchen_light = 1 - kitchen_light
    end
    save_state()
end)

gpio.trig(btn_bottom, "down",
function(level, when, eventcount)
    if tmr.now() - btn_timestamp > (0.5*1000*1000) then
        btn_timestamp = tmr.now()
        dining_light = 1 - dining_light
    end
    save_state()
end)