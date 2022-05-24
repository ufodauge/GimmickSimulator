local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'

local SequenceManager = {}

function SequenceManager:update( dt )
  self._keyManager:update( dt )
end

function SequenceManager:start()
  if self._started then
    return
  end

  self._started = true

  for i, sequence in pairs( self._sequences ) do
    if sequence.start then
      sequence:start()
    end
  end
  print( 'SequenceManager:start' )
  self:notifyObservers( { name = 'start' } )
end

function SequenceManager:reset()
  self._started = false
  for i, sequence in pairs( self._sequences ) do
    if sequence.reset then
      sequence:reset()
    end
  end

  print( 'SequenceManager:reset' )
  self:notifyObservers( { name = 'reset' } )
end

function SequenceManager:started()
  return self._started
end

function SequenceManager:add( sequence )
  table.insert( self._sequences, sequence )
end

function SequenceManager:remove( sequence )
  for i, g in pairs( self._sequences ) do
    if g == sequence then
      table.remove( self._sequences, i )
    end
  end
end

function SequenceManager:getSequences()
  return unpack( self._sequences )
end

-- observer pattern ----------
function SequenceManager:addObserver( observer )
  table.insert( self._observers, observer )
end

function SequenceManager:removeObserver( observer )
  for i, g in pairs( self._observers ) do
    if g == observer then
      table.remove( self._observers, i )
    end
  end
end

function SequenceManager:notifyObservers( event )
  for i = 1, #self._observers do
    self._observers[i]:updateObserver( event )
  end
end
-----------------------------

function SequenceManager:deleteSequences()
  for i, sequence in pairs( self._sequences ) do
    if sequence.delete then
      sequence:delete()
      sequence = nil
    end
  end
  self._sequences = {}

end

function SequenceManager:new()
  local obj = {}

  obj._sequences = {}
  obj._observers = {}
  obj._started = false
  obj._player = nil

  local keySpace = Keyboard:new( 'space', function( self, dt, f )
    if f == 0 then
      if obj._started then
        obj:reset()
      else
        obj:start()
      end
    end
  end )
  obj._keyManager = KeyManager:new()
  obj._keyManager:add( keySpace )

  return setmetatable( obj, {
    __index = SequenceManager,
    tostring = function()
      return 'SequenceManager'
    end
  } )
end

return SequenceManager
