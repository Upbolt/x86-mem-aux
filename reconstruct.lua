-- define sizes of structs/classes here
local structSizes = {
    uint8_t = 1,
    uintptr_t = 4,
    TValue = 16
}

local function makeField(type, name, offset)
    local size = structSizes[type]

    if not size and type:find("*", 1, true) then
        size = 4
    end

    return {
        type = type,
        name = name,
        offset = offset or 0,
        size = size
    }
end

local function makeGap(space, size)
    return "uint8_t " .. ('_'):rep(space) .. '[' .. size .. '];\n\t'
end

local function getFieldInfo(field)
    return field.type .. ' ' .. field.name .. ';\n\t'
end

local function sortFields(fields)
    local key, previous

    for i = 2, #fields do
        key = fields[i]
        previous = i - 1

        while previous >= 1 and fields[previous].offset > key.offset do
            fields[previous + 1] = fields[previous]
            previous = previous - 1
        end

        fields[previous + 1] = key
    end

    return fields
end

local function makeStruct(name, fields)
    local head = "struct " .. name .. ' {\n\t'
    local gaps = 0

    fields = sortFields(fields)

    if fields[1] and fields[1].offset ~= 0 then
        gaps = gaps + 1
        head = head .. makeGap(gaps, fields[1].offset) 
    end

    head = head .. getFieldInfo(fields[1])

    for i = 2, #fields do
        local previous = fields[i - 1]
        local current = fields[i]

        if previous.offset + previous.size ~= current.offset then
            gaps = gaps + 1
            head = head .. makeGap(gaps, current.offset - (previous.offset + previous.size))
        end

        head = head .. getFieldInfo(current)
    end

    return head:sub(1, -3) .. '\n};\n'
end
