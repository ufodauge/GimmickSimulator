local Timer = require( 'lib.timer' ):new()
local lume = require( 'lib.lume' )
-- local Timer = require( 'lib.hump.timer' ).new()

local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'
local GIManager = require( 'class.gameinstance.manager' ):getInstance()

local GimmickManager = {}

function GimmickManager:update( dt )
  for i, v in ipairs( self._gimmicks ) do
    if v == nil then
      table.remove( self._gimmicks, i )
    end
  end
  Timer:update( dt )
end

function GimmickManager:updateObserver( event )
  if event.name == 'reset' then
    self:deleteGimmicks()
  end
end

function GimmickManager:getObserver()
  return self._observer
end

function GimmickManager:add( gimmick, deleteaftersecond )
  print( gimmick )
  GIManager:add( gimmick )
  table.insert( self._gimmicks, gimmick )
  if deleteaftersecond then
    local func = function()
      self:remove( gimmick )
    end
    Timer:after( deleteaftersecond, func )
  end
end

function GimmickManager:remove( gimmick )
  lume.remove( self._gimmicks, gimmick )
  GIManager:remove( gimmick )
end

function GimmickManager:deleteGimmicks()
  for i, g in pairs( self._gimmicks ) do
    GIManager:remove( g )
    if g.delete then
      self._gimmicks[i]:delete()
      self._gimmicks[i] = nil
    end
  end

  lume.clear( self._gimmicks )
end

function GimmickManager:getGimmicks()
  return unpack( self._gimmicks )
end

function GimmickManager:delete()
  self:deleteGimmicks()
  self = nil
end

function GimmickManager:new()
  local obj = {}

  obj._gimmicks = {}

  return setmetatable( obj, {
    __index = GimmickManager,
    __tostring = function()
      return 'GimmickManager'
    end
  } )
end

return GimmickManager
