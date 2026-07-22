local function class(name, ...) 
    local clazz = {
        __name = name,
    }

    local supers = { ... }
    for _, super in ipairs(supers) do
        if type(super) == "table" then
            for k, v in pairs(super) do
                clazz[k] = v
            end
        end
    end

    setmetatable(clazz, {
        __call = function (self, ...) 
            local object = setmetatable({}, clazz)
            object:_ctor(...)
            return object
        end,
    })

    if not clazz._ctor then
        clazz._ctor = function (self, ...)

        end
    end

    if not clazz.__tostring then
        clazz.__tostring = function (self)
            return "[" .. self.__name .. "]"
        end
    end

    clazz.__index = clazz
    clazz.__super = supers[1]
    clazz.__supers = supers
    return clazz
end

-- class tests
-- local Object = class("Object")
-- local obj = Object()
-- print(obj)


local Shape = class("Shape")

function Shape:getArea() 
    return 0
end


local Circle = class("Circle", Shape)

function Circle:_ctor(r)
    Shape._ctor(self)

    -- Debugging with printing, doing OOP make the code more blackbox
    -- print("call Circle._ctor type(r) = " .. type(r))
    -- print("call Circle._ctor type(self) = " .. type(self))

    self.r = r
end

function Circle:getArea()
    return self.r * self.r * math.pi
end


local Triangle = class("Triangle", Shape)

function Triangle:_ctor(b, h)
    Shape._ctor(self)

    self.b = b
    self.h = h
end

function Triangle:getArea()
    return self.b * self.h * 0.5
end


local Rectangle = class("Rectangle", Shape)

function Rectangle:_ctor(w, h)
    Shape._ctor(self)

    self.w = w
    self.h = h
end

function Rectangle:getArea()
    return self.w * self.h
end


function totalAreaVTBL(shapes)
    local accum = 0.0
    for _, shape in ipairs(shapes) do
        accum = accum + shape:getArea()
    end

    return accum
end


function totalAreaVTBL4(shapes)
    local accum1 = 0.0
    local accum2 = 0.0
    local accum3 = 0.0
    local accum4 = 0.0

    local shapeCount = #shapes
    local shapeCount4 = math.floor(shapeCount / 4)

    local idx = 0
    while idx < shapeCount4 do
        local shape1 = shapes[idx * 4 + 1]
        local shape2 = shapes[idx * 4 + 2]
        local shape3 = shapes[idx * 4 + 3]
        local shape4 = shapes[idx * 4 + 4]

        accum1 = accum1 + shape1:getArea()
        accum2 = accum2 + shape2:getArea()
        accum3 = accum3 + shape3:getArea()
        accum4 = accum4 + shape4:getArea()

        idx = idx + 1
    end

    return accum1 + accum2 + accum3 + accum4
end

local util = require("../ffi_util")
local ITERATIONS = 100000000

local shapes = {
    Circle(10),
    Triangle(10, 10),
    Rectangle(10, 10),

    Circle(10),
    Triangle(10, 10),
    Rectangle(10, 10),

    Circle(10),
    Triangle(10, 10),
    Rectangle(10, 10),
    
    Circle(10),
    Triangle(10, 10),
    Rectangle(10, 10),
}

-- local startTime = util.time()
for i = 1, ITERATIONS do
    local result = totalAreaVTBL(shapes)
end


for i = 1, ITERATIONS do
    local result = totalAreaVTBL4(shapes)
end
-- local endTime = util.time()
-- local cycles = tonumber(endTime - startTime)
-- print("Cycles: %d", cycles)