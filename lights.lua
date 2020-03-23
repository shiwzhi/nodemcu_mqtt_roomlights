local light0 = 5
local light1 = 6
local light2 = 7

local status_led_pin = 0
gpio.mode(status_led_pin, gpio.OUTPUT)
gpio.write(status_led_pin, gpio.HIGH)

local status_led_tmr = tmr.create()
status_led_tmr:register(200, tmr.ALARM_AUTO, 
function()
    if true then
        if gpio.read(status_led_pin) == gpio.HIGH then
            gpio.write(status_led_pin, gpio.LOW)
        else 
            gpio.write(status_led_pin, gpio.HIGH)
        end
    else 
        gpio.write(status_led_pin, gpio.HIGH)
    end
end)
-- status_led_tmr:start()

gpio.mode(light0, gpio.OUTPUT, gpio.PULLUP)
gpio.mode(light1, gpio.OUTPUT, gpio.PULLUP)
gpio.mode(light2, gpio.OUTPUT, gpio.PULLUP)

local pin_tmr = tmr.create()
pin_tmr:register(200, tmr.ALARM_AUTO,
function()
    gpio.write(light0, living_light)
    gpio.write(light1, 1 - kitchen_light)
    gpio.write(light2, 1 - dining_light)
end)
pin_tmr:start()