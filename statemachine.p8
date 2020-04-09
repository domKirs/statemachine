pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

local PRESS_UP, PRESS_DOWN, PRESS_X, NO_INPUT = 2, 3, 5, 666

local Standing_State, Jumping_State, Ducking_State = {}, {}, {} -- heroine's state pattern 

local Heroine_States = {} -- object pool for heroine's states

Standing_State.__index = Standing_State

function Standing_State:new()
    return setmetatable({}, self)
end

function Standing_State:handle_input(heroine, input)
    if input == PRESS_X then
        heroine.state = Heroine_States.jumping_state
        heroine.w = heroine.jumping_w
        heroine.h = heroine.jumping_h
    elseif input == PRESS_DOWN then
        heroine.state = Heroine_States.ducking_state
        heroine.w = heroine.ducking_w
        heroine.h = heroine.ducking_h
    end
end

function Standing_State:update(heroine)

end

function Standing_State:init()

end

Jumping_State.__index = Jumping_State

function Jumping_State:new()
    local o = setmetatable({}, self)
    o.x_is_down = false
    o.air_time = 0
    o.air_time_max = 29
    return o
end

function Jumping_State:handle_input(heroine, input)
    if input == PRESS_DOWN then
        heroine.state = Heroine_States.standing_state
        heroine.w = heroine.standing_w
        heroine.h = heroine.standing_h
    end 

    if input == NO_INPUT then
        print("No input")
    end

end

function Jumping_State:update(heroine)

end

function Jumping_State:init()
    self.x_is_down = true
    self.air_time = self.air_time_max
end

Ducking_State.__index = Ducking_State

function Ducking_State:new()
    return setmetatable({}, self)
end

function Ducking_State:handle_input(heroine, input)
     if input == PRESS_UP then
        heroine.state = Heroine_States.standing_state
        heroine.w = heroine.standing_w
        heroine.h = heroine.standing_h
    end
end

function Ducking_State:update(heroine)

end

function Ducking_State:init()

end

Heroine_States.standing_state = Standing_State:new()
Heroine_States.jumping_state = Jumping_State:new()
Heroine_States.ducking_state = Ducking_State:new()

local Heroine = {}
Heroine.__index = Heroine

function Heroine:new(x, y)
    local o = setmetatable({}, self)
    o.state = Heroine_States.standing_state
    o.x, o.y = x, y
    o.w, o.h = 8, 8 
    o.standing_w, o.standing_h = 8, 8
    o.ducking_w, o.ducking_h = 12, 4
    o.jumping_w, o.jumping_h = 6, 10 
    o.c = 9

    return o
end

function Heroine:handle_input(input) 
    self.state:handle_input(self, input)
end

function Heroine:update()
    self.state:update(self)
end

function Heroine:draw()
    rectfill(self.x, self.y, self.x + self.w, self.y + self.h, self.c)
end

function _init()
    cls()
    heroine = Heroine:new(64, 64)
end

function _update60()
    if btnp(PRESS_UP) then 
        heroine:handle_input(PRESS_UP)
    elseif btnp(PRESS_DOWN) then
        heroine:handle_input(PRESS_DOWN)
    elseif btnp(PRESS_X) then
        heroine:handle_input(PRESS_X)
    else
        heroine:handle_input(NO_INPUT)
    end
end

function _draw()
    cls()
    heroine:draw()
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
