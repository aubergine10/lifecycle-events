-- license: MIT (open source)

local _died = defines.events.on_entity_died
local _player = defines.events.on_built_entity
local _robot = defines.events.on_robot_built_entity

local fakeBot = { valid = false }

-- can entity be destroyed?
function _G.can_destroy( entity )
  if not entity or not entity.valid then return end
  -- TODO: work out if it can be destroyed (eg. rail with train on top = false)
  return true
end

-- trigger event before destroying entity
function _G.destroy_entity( entity )
  if can_destroy( entity ) then
     game.raise_event( _died, { entity = entity, tick = game.tick, name = _died } )
     return entity.destroy()
  end
end

-- trigger event after building entity
function _G.create_entity( surface, settings, player )
  local entity = surface.create_entity( settings )
  if entity then
    if player then
      game.raise_event( _player, { created_entity = entity, player = player, tick = game.tick, name = _player } )
    else
      game.raise_event( _robot, { created_entity = entity, robot = fakeBot, tick = game.tick, name = _robot } )
    end
    return entity
  end
end

return
