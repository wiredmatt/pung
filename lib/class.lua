local middleclass = {}

local function _create_index_wrapper(a_class, f)
    if f == nil then
        return a_class.__instance_dict
    elseif type(f) == "function" then
        return function(self, name)
            local value = a_class.__instance_dict[name]

            if value ~= nil then
                return value
            else
                return (f(self, name))
            end
        end
    else -- if  type(f) == "table" then
        return function(self, name)
            local value = a_class.__instance_dict[name]

            if value ~= nil then
                return value
            else
                return f[name]
            end
        end
    end
end

local function _propagate_instance_method(a_class, name, f)
    f = name == "__index" and _create_index_wrapper(a_class, f) or f
    a_class.__instance_dict[name] = f

    for subclass in pairs(a_class.subclasses) do
        if rawget(subclass.__declared_methods, name) == nil then
            _propagate_instance_method(subclass, name, f)
        end
    end
end

local function _declare_instance_method(aClass, name, f)
    aClass.__declared_methods[name] = f

    if f == nil and aClass.super then
        f = aClass.super.__instance_dict[name]
    end

    _propagate_instance_method(aClass, name, f)
end

local function _tostring(self) return "class " .. self.name end
local function _call(self, ...) return self:new(...) end

local function _create_class(name, super)
    local dict = {}
    dict.__index = dict

    local a_class = {
        name = name,
        super = super,
        static = {},
        __instance_dict = dict,
        __declared_methods = {},
        subclasses = setmetatable({}, { __mode = 'k' })
    }

    if super then
        setmetatable(a_class.static, {
            __index = function(_, k)
                local result = rawget(dict, k)
                if result == nil then
                    return super.static[k]
                end
                return result
            end
        })
    else
        setmetatable(a_class.static, { __index = function(_, k) return rawget(dict, k) end })
    end

    setmetatable(a_class, {
        __index = a_class.static,
        __tostring = _tostring,
        __call = _call,
        __newindex = _declare_instance_method
    })

    return a_class
end

local function _include_mixin(a_class, mixin)
    assert(type(mixin) == 'table', "mixin must be a table")

    for name, method in pairs(mixin) do
        if name ~= "included" and name ~= "static" then a_class[name] = method end
    end

    for name, method in pairs(mixin.static or {}) do
        a_class.static[name] = method
    end

    if type(mixin.included) == "function" then mixin:included(a_class) end
    return a_class
end

local DefaultMixin = {
    __tostring     = function(self) return "instance of " .. tostring(self.class) end,

    initialize     = function(self, ...) end,

    is_instance_of = function(self, a_class)
        return type(a_class) == 'table'
            and type(self) == 'table'
            and (self.class == a_class
                or type(self.class) == 'table'
                and type(self.class.is_subclass_of) == 'function'
                and self.class:is_subclass_of(a_class))
    end,

    static         = {
        allocate = function(self)
            assert(type(self) == 'table', "Make sure that you are using 'Class:allocate' instead of 'Class.allocate'")
            return setmetatable({ class = self }, self.__instance_dict)
        end,

        new = function(self, ...)
            assert(type(self) == 'table', "Make sure that you are using 'Class:new' instead of 'Class.new'")
            local instance = self:allocate()
            instance:initialize(...)
            return instance
        end,

        subclass = function(self, name)
            assert(type(self) == 'table', "Make sure that you are using 'Class:subclass' instead of 'Class.subclass'")
            assert(type(name) == "string", "You must provide a name(string) for your class")

            local subclass = _create_class(name, self)

            for methodName, f in pairs(self.__instance_dict) do
                if not (methodName == "__index" and type(f) == "table") then
                    _propagate_instance_method(subclass, methodName, f)
                end
            end
            subclass.initialize = function(instance, ...) return self.initialize(instance, ...) end

            self.subclasses[subclass] = true
            self:subclassed(subclass)

            return subclass
        end,

        subclassed = function(self, other) end,

        is_subclass_of = function(self, other)
            return type(other) == 'table' and
                type(self.super) == 'table' and
                (self.super == other or self.super:is_subclass_of(other))
        end,

        include = function(self, ...)
            assert(type(self) == 'table', "Make sure you that you are using 'Class:include' instead of 'Class.include'")
            for _, mixin in ipairs({ ... }) do _include_mixin(self, mixin) end
            return self
        end
    }
}

function middleclass.class(name, super)
    assert(type(name) == 'string', "A name (string) is needed for the new class")
    return super and super:subclass(name) or _include_mixin(_create_class(name), DefaultMixin)
end

setmetatable(middleclass, { __call = function(_, ...) return middleclass.class(...) end })

---@class Class
---@field public static table
---@field initialize fun(self:table, ...)
---@field is_instance_of fun(self:table, a_class:table):boolean
---@field new fun(self:table, ...): table
---@field subclass fun(self:table, name:string):table
---@field subclassed fun(self:table, other:table)
---@field is_subclass_of fun(self:table, other:table):boolean
---@field include fun(self:table, ...):table
---@field private class fun(name:string, super:table):table

---@class Object
---@field public static table
---@field is_instance_of fun(self:table, a_class:table):boolean
---@field new fun(self:table, ...): table
---@field include fun(self:table, ...):table

return middleclass --[[@as Class]]
