-- Author: MeatG
-- Place this to your Taranis SD Card -> /SCRIPTS/MIXES/




local input = { {"Speed", VALUE, 5, 30, 10 },  -- 1/100 seconds -- min, max, default possible range -128..127
                 {"Delay", VALUE, 0, 100, 10 }}  
local output = { "Wipe" }




local startTime
local currTime

local currWipe
local dir = 1  --1 going up, -1 going down

local times_run = 0
local timer_running = false
local timer = 0

local function init_func()
    startTime = getTime() * 10 -- ms
    currWipe = 0.5
    timer = 0
    times_run = 0
    timer_running = false
    dir = 1
end


local function run_func( speed, delay )
    local duration = speed * 100 --ms
    local interval = delay * 100 --ms

    currTime = getTime() * 10 -- ms


    if timer_running == false then
        if times_run >= 1 then
            timer = 0
            startTime = currTime
            timer_running = true
        end  
        timer = 0
    else
        timer = currTime - startTime
        if timer >= interval then
            startTime = currTime -- milliseconds
            timer_running = false
            times_run = 0
        else 
            return currWipe * 1024 * 2
        end
    end
    
    if timer_running == true then
        return currWipe * 1024 * 2
    end

    local step = (30 / duration) * 2 --OpenTX loop is supposedly 30ms, not guaranteed in mix scripts

    currWipe = currWipe + step * dir

    if currWipe >= 0.5 and dir >0 then
        dir = -1
        currWipe = 0.5
        times_run = times_run + 1
    end

    if currWipe <= -0.5 and dir <0 then
        dir = 1
        currWipe = -0.5
    end
    
    -- OpenTX input, output values are -1024..1024
    return currWipe * 1024 * 2
end

return { input=input, output=output, run=run_func, init=init_func }