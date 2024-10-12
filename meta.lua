---@meta meta

---@alias vec4 table<number, number, number, number>
---@alias vec3 table<number, number, number>
---@alias vec2 table<number, number>

---@alias ContactCallback fun(self, a: love.Body, b: love.Body, coll: love.Contact)

---@class Scene
---@field load fun(self)
---@field draw fun(self)
---@field update fun(self, dt: number)

---@class GameObject : Object
---@field id string
---@field new fun(self): GameObject

---@class GameObjectWithPhysics : GameObject
---@field fixture love.Fixture
---@field shape love.Shape
---@field body love.Body

---@class GameObjectWithMaybePhysicsCallbacks : GameObjectWithPhysics
---@field begin_contact ContactCallback?
---@field end_contact ContactCallback?
---@field register_physics_callbacks fun(self, _begin: string?, _end: string?)
