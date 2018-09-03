local debug = true

local log = {
    debug = function(text)
        if debug then
            print("[TP] "..tostring(text))
        end
    end
}

return log
