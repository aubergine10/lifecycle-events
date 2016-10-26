# lifecycle-events

When a mod creates or destroys an entity via Lua script, no events are fired. This is not a problem if the created/destroyed entities are from that mod, because it can handle everything internally.

However, if the created/destroyed entities are from an external mod, or the vanilla game, problems can arise - because other mods, which may need to take action, have no clue that the entities were created/destroyed.

This mod fixes that issue, by providing event-generating methods for creating and destroying entities.

## Installation

Download the `event-lifecycle.lua` and put it in your mod folder, then require it at the top of your own `control.lua`:

```lua
require 'event-lifecycle`
```

## Usage

Three new global functions are provided:

* `can_destroy( entity )` -- can the entity be deleted?
* `destroy_entity( entity )` -- includes check to see if it `can_detroy( entity )`
* `create_entity( surface, settings[, player] )`

Note: To mtaintain performance, very little error checking is performed.

## Destroying entities

The `destroy_entity()` function is similar to `LuaEntity.destroy()`, but it triggers an event:

* `defines.events.on_entity_died` -- only triggered if it `can_destroy( entity )`


```lua
local result = destroy_entity( entity )
```

Where:

* `result` = `true` if entity was destroyed, otherwise `nil` (which is equivalent to `false`)
* `entity` = a valid [`LuaEntity`](http://lua-api.factorio.com/latest/LuaEntity.html) table

## Creating entities

The global `create_entity()` function is similar to `LuaSurface.create_entity()`, but it triggers an event:

* `defines.events.on_built_entity` -- only if `player` param specified
* `defines.events.on_robot_built_entity`

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
