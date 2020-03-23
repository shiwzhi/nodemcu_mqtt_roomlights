function save_state()
    print("Save state")
    if file.open("states.txt", 'w') then
        file.write(tostring(living_light)..tostring(kitchen_light)..tostring(dining_light))
        file.close()
    end
end

function restore_state()
    print("Restore state")
    if file.open("states.txt", 'r') then
        living_light = tonumber(file.read(1))
        kitchen_light = tonumber(file.read(1))
        dining_light = tonumber(file.read(1))
        file.close()
    end
end

restore_state()