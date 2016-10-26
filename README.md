# lifecycle-events

When a mod creates or destroys an entity via Lua script, no events are fired. This is not a problem if the created/destroyed entities are from that mod, because it can handle everything internally.

However, if the created/destroyed entities are from an external mod, or the vanilla game, other mods which may need to take action have no clue that the entities were created/destroyed. That's a [problem](https://forums.factorio.com/viewtopic.php?f=34&t=34952).

## Installation

Download [`lifecycle-events.lua`](https://github.com/aubergine10/lifecycle-events/blob/master/lifecycle-events.lua) and put it in your mod folder, then require it at the top of your own `control.lua`:

```lua
-- in your control.lua:
require 'lifecycle-events`
```

## Usage

Three new global functions are provided:

* `can_destroy( entity )`
* `destroy_entity( entity )` -- includes check to see if it `can_detroy( entity )`
* `create_entity( surface, settings[, player] )`

Note: To mtaintain performance, very little error checking is performed.

## Destroying entities

The `destroy_entity()` function is similar to [`LuaEntity.destroy()`](http://lua-api.factorio.com/latest/LuaEntity.html#LuaEntity.destroy), but it triggers an event:

* [`defines.events.on_entity_died`](http://lua-api.factorio.com/latest/events.html#on_entity_died) -- only triggered if it `can_destroy( entity )`


```lua
local result = destroy_entity( entity )
```

Where:

* `result` = `true` if entity was destroyed, otherwise `nil` (which is equivalent to `false`)
* `entity` = a valid [`LuaEntity`](http://lua-api.factorio.com/latest/LuaEntity.html) table

## Creating entities

The `create_entity()` function is similar to [`LuaSurface.create_entity()`](http://lua-api.factorio.com/latest/LuaSurface.html#LuaSurface.create_entity), but it triggers an event:

* [`defines.events.on_built_entity`](http://lua-api.factorio.com/latest/events.html#on_built_entity) -- if `player` param specified
* [`defines.events.on_robot_built_entity`](http://lua-api.factorio.com/latest/events.html#on_robot_built_entity) -- if `player` param _not_ specified

```lua
local new_entity = create_entity( surface, settings[, player] )
```

Where:

* `surface` = a valid [LuaSurface](http://lua-api.factorio.com/latest/LuaSurface.html) table (_not_ a surface name)
* `settings` = a table [describing the entity](http://lua-api.factorio.com/latest/LuaSurface.html#LuaSurface.create_entity) to create
* `player` (optional) = a valid [`LuaPlayer`](http://lua-api.factorio.com/latest/LuaPlayer.html) table, or [player index](http://lua-api.factorio.com/latest/LuaPlayer.html#LuaPlayer.index)
  * If `player` specified, `on_built_entity` event is used
  * Otherwise, `on_robot_built_entity` is used with invalid `.robot` property
* `new_entity` = the entity that was created, or `nil` if there was a problem
