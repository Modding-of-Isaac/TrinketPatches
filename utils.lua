return {
    isFire = function(entityRef)
        return (entityRef.Type == EntityType.ENTITY_FIREPLACE or
                (entityRef.Type == EntityType.ENTITY_EFFECT and
                 (entityRef.Variant == EffectVariant.BLUE_FLAME or
                  entityRef.Variant == EffectVariant.RED_CANDLE_FLAME or
                  entityRef.Variant == EffectVariant.HOT_BOMB_FIRE)))
    end,

    chance = function(x, affectedByLuck)
        -- Takes percentage, i.e. 20 for 20%
        if not affectedByLuck then
            return math.random() < (x / 100)
        else
            local player = Isaac.GetPlayer(0)
            -- +5% chance for every luck up
            local modifier = x + 5 * player.Luck
            return math.random() < (x / 100)
        end
    end,

    log = function(text)
        if TrinketPatches.debug then
            print("[TP] "..tostring(text))
        end
    end,

    register = function(arg)
        return setmetatable({arg}, {
            __concat = function(_, f)
                TrinketPatches.mod:AddCallback(ModCallbacks[arg], f)
                return f
            end
        })
    end
}