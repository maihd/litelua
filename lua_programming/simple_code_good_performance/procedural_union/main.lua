-- In fact, the procedural code more clean, shorter

local ShapeType = {
    Circle = 0,
    Triangle = 1,
    Rectangle = 2,
}


local function getArea(shape)
    -- if shape.type == ShapeType.Circle then
    --     return shape.r * shape.r * math.pi
    -- elseif shape.type == ShapeType.Triangle then
    --     return shape.b * shape.h * 0.5
    -- elseif shape.type == ShapeType.Rectangle then
    --     return shape.w * shape.h
    -- end

    return shape.w * shape.h * shape.factor
end


local function totalAreaVTBL(shapes)
    local accum = 0.0

    for _, shape in ipairs(shapes) do
        accum = accum + getArea(shape)
    end

    return accum
end


local function totalAreaVTBL4(shapes)
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

        accum1 = accum1 + getArea(shape1)
        accum2 = accum2 + getArea(shape2)
        accum3 = accum3 + getArea(shape3)
        accum4 = accum4 + getArea(shape4)

        idx = idx + 1
    end

    return accum1 + accum2 + accum3 + accum4
end


local util = require("../ffi_util")
local ITERATIONS = 100000000


local shapes = {
    { type = ShapeType.Circle, r = 10, w = 10, h = 10, factor = math.pi },
    { type = ShapeType.Triangle, b = 10, w = 10, h = 10, factor = 0.5 },
    { type = ShapeType.Rectangle, w = 10, h = 10, factor = 1.0 },


    { type = ShapeType.Circle, r = 10, w = 10, h = 10, factor = math.pi },
    { type = ShapeType.Triangle, b = 10, w = 10, h = 10, factor = 0.5 },
    { type = ShapeType.Rectangle, w = 10, h = 10, factor = 1.0 },


    { type = ShapeType.Circle, r = 10, w = 10, h = 10, factor = math.pi },
    { type = ShapeType.Triangle, b = 10, w = 10, h = 10, factor = 0.5 },
    { type = ShapeType.Rectangle, w = 10, h = 10, factor = 1.0 },


    { type = ShapeType.Circle, r = 10, w = 10, h = 10, factor = math.pi },
    { type = ShapeType.Triangle, b = 10, w = 10, h = 10, factor = 0.5 },
    { type = ShapeType.Rectangle, w = 10, h = 10, factor = 1.0 },
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