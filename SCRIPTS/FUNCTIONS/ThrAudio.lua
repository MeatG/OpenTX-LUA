
-- NOTE: analog values (e.g. sticks and sliders) typically range from -1024 to +1024
-- divide by 10.24 to scale into -100% thru +100%
-- or add 1024 and divide by 20.48 to scale into 0% thru 100%


local duration = 3000 --milliseconds

local minFreq = 200
local maxFreq = 1200

------------

local currFreq
local freqScale
local lastThrValue
local timer
local currTime




local function init()
    freqScale = maxFreq-minFreq
    lastThrValue = 0
    currTime = getTime() *10 -- multiple of 10ms, ie. 10 sec = 1000
    timer = currTime


end



local function run()
    currTime = getTime() *10
    local delay = currTime - timer


    local thrValue = getValue('thr')
    thrValue = (thrValue + 1024) / 20.48  -- 0-100%

    if  lastThrValue == thrValue  then 
        if delay < duration then
            return
        else
            timer = currTime
        end
    end
    
    currFreq = minFreq + (thrValue * freqScale) / 100
    
    playTone( currFreq, duration, 20, PLAY_BACKGROUND )

    lastThrValue = thrValue

end


return { init=init, run=run }