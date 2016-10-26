# lifecycle-events

When a mod creates or destroys an entity via Lua script, no events are fired. This is not a problem if the created/destroyed entities are from that mod, because it can handle everything internally.

However, if the created/destroyed entities are from an external mod, or the vanilla game, other mods which may need to take action have no clue that the entities were created/destroyed - that's a problem, but the devs [won't fix it](https://forums.factorio.com/viewtopic.php?f=34&t=34952).

## When should I use this module?

Use the functions provided by this module when you create or destroy entities that aren't part of your mod.

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

## Example

Imagine you've got a mod that creates roads, but you want to line those roads with concrete lampposts (entity from a separate mod).

If you just place the lamppost with `LuaSurface.create_entity()`, the Concrete Lamppost won't know about it, and won't spawn the additional entities. Likewise, if you destroy a lamppost with `LuaEntity.destroy()`, the Concrete Lamppost mod won't know about it, and the additional entities will remain on the map.

To solve this, use the `create_entity()` and `destroy_entity()` functions - they spawn the events that almost every mod will recongise and act upon...

```
-- control.lua

require 'lifecycle-events'

-- some time later in the script...

local function add_lamppost( surface, pos, dir, player )
  return create_entity(
    surface,
    {
      type = 'electric-pole',
      name = 'concrete-lamppost',
      position = pos,
      direction = dir,
      force = player.force
    },
    player
  )
end

local function remove_lappost( lamppost )
  return destroy_entity( lamppost )
end
```

## License

[MIT](LICENSE) (open source)
