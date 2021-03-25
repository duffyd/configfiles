-- Hammerspoon init file

hs.window.animationDuration = 0

units = {
  top50         = {x = 0.00, y = 0.00, w = 1.00, h = 0.50},
  bot50         = {x = 0.00, y = 0.50, w = 1.00, h = 0.50},
  bot80         = {x = 0.00, y = 0.20, w = 1.00, h = 0.80},
  bot90         = {x = 0.00, y = 0.20, w = 1.00, h = 0.90},
  topright30    = {x = 0.50, y = 0.00, w = 0.50, h = 0.30},
  botright70    = {x = 0.50, y = 0.30, w = 0.50, h = 0.70},
  topleft30     = {x = 0.00, y = 0.00, w = 0.50, h = 0.30},
  botleft70     = {x = 0.00, y = 0.30, w = 0.50, h = 0.70},
  right70top80  = {x = 0.70, y = 0.00, w = 0.30, h = 0.80},
  top0to33      = {x = 0.00, y = 0.00, w = 0.33, h = 1.00},
  top33to66     = {x = 0.33, y = 0.00, w = 0.33, h = 1.00},
  top66to100    = {x = 0.66, y = 0.00, w = 0.34, h = 1.00},
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
  center        = { x = 0.20, y = 0.10, w = 0.60, h = 0.80 }
}

layouts = {
  coding = {
    {name = 'Safari', app = 'Safari.app', screen = 'VX3276%-QHD', unit = hs.layout.left50},
    {name = 'Eclipse', app = 'Eclipse.app', screen = 'VX3276%-QHD', unit = hs.layout.right50},
    {name = 'Terminal', app = 'Terminal.app', screen = 'Built%-in Retina Display', unit = hs.layout.left50},
    {name = 'Telegram Lite', app = 'Telegram Lite.app', screen = 'Built%-in Retina Display', unit = hs.layout.right50, layout = 'coding'}
 },
 covisit = {
    {name = 'Acrobat Reader', app = 'Adobe Acrobat Reader DC.app', screen = 'Built%-in Retina Display', unit = hs.layout.left50},
    {name = 'Finder', app = 'Finder.app', screen = 'Built%-in Retina Display', unit = hs.layout.right50},
    {name = 'Terminal', app = 'Terminal.app', screen = 'VX3276%-QHD', unit = units.topright30},
    {name = 'Safari', app = 'Safari.app', screen = 'VX3276%-QHD', unit = units.botleft70},
    {name = 'Circuit Assistant', app = 'Circuit Assistant.app', screen = 'VX3276%-QHD', unit = units.botright70, layout = 'covisit'},
    --{name = 'Messages', app = 'Messages.app', screen = 'Built%-in Retina Display', unit = units.top0to33},
    --{name = 'WhatsApp', app = 'WhatsApp.app', screen = 'Built%-in Retina Display', unit = units.top66to100},
    --{name = 'LINE', app = 'LINE.app', screen = 'Built%-in Retina Display', unit = units.top33to66}
 },
 relax = {
    {name = 'Safari', app = 'Safari.app', screen = 'SAMSUNG', unit = hs.layout.maximized, layout = 'relax'},
 },
 meeting = {
    {name = 'OBS', app = 'OBS.app', screen = 'VX3276%-QHD', unit = units.center},
    {name = 'zoom.us', app = 'zoom.us.app', screen = 'VX3276%-QHD', unit = units.bot80, layout = 'meeting'},
 }
}

function runLayout(layout)
  for i = 1,#layout do
    local t = layout[i]
    local theapp = hs.application.get(t.name)
    local appwait
    if theapp == nil then
      if t.name == 'Eclipse' then
        appwait = 10
      else
        appwait = 5
      end
      theapp = hs.application.open(t.app, appwait)
    end
    if theapp ~= nil then
      local win = theapp:mainWindow()
      local screen
      if t.screen ~= nil then
        screen = hs.screen.find(t.screen)
      end
      win:move(t.unit, screen, true)
    end
    if next(layout,i) == nil then
      local message
      if t.layout then
        if t.layout ~= 'relax' then
          hs.wifi.setPower(false)
          hs.printf('Turned wifi off')
        else
          if hs.screen.find('SAMSUNG') then
            local samsungaudio = hs.audiodevice.findOutputByName('SAMSUNG')
            if samsungaudio ~= nil then
              samsungaudio:setDefaultOutputDevice()
              showMessage("Default sound output", "Set default sound output to SAMSUNG audio")
            end
            hs.wifi.setPower(true)
            hs.printf('Turned wifi on')
          end
        end
        message = "Successfully applied " .. t.layout .. " layout"
      else
        message = "Successfully applied layout"
      end
      showMessage("Apply layout", message)
    end
  end
end

function shareScreen()
  local zoom = hs.application.get('zoom.us')
  if zoom then
    hs.eventtap.keyStroke({'shift', 'cmd'}, 's', zoom)
  else
    showMessage("Share Screen", "You have to open Zoom first")
  end
end

function showMessage(title, message)
  local note = hs.notify.new({
    title=title,
    informativeText=message
  }):send()
  hs.timer.doAfter(3, function()
    note:withdraw()
    note = nil
  end)
end

mash = {'shift', 'ctrl', 'cmd'}
hs.hotkey.bind(mash, 'h', function() hs.window.focusedWindow():move(units.left70, nil, true) end)
hs.hotkey.bind(mash, 'k', function() hs.window.focusedWindow():move(units.top50, nil, true) end)
hs.hotkey.bind(mash, 'j', function() hs.window.focusedWindow():move(units.bot50, nil, true) end)
hs.hotkey.bind(mash, 'l', function() hs.window.focusedWindow():move(units.right30, nil, true) end)
hs.hotkey.bind(mash, '[', function() hs.window.focusedWindow():move(units.topleft30, nil, true) end)
hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(units.topright30, nil, true) end)
hs.hotkey.bind(mash, ';', function() hs.window.focusedWindow():move(units.bot80, nil, true) end)
hs.hotkey.bind(mash, "'", function() hs.window.focusedWindow():move(units.bot90, nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum, nil, true) end)
hs.hotkey.bind(mash, '0', function() runLayout(layouts.covisit) end)
hs.hotkey.bind(mash, '9', function() runLayout(layouts.meeting) end)
hs.hotkey.bind(mash, '8', function() runLayout(layouts.coding) end)
hs.hotkey.bind(mash, '7', function() runLayout(layouts.relax) end)
hs.hotkey.bind({'shift', 'alt'}, 's', function() shareScreen() end)

-- requires: brew install vitorgalvao/tiny-scripts/calm-notifications
local dndStatusBeforeZoom
updateZoomStatus = function(event)
  -- restore startup status on quit
  if (event == "from-running-to-closed") then
    hs.execute("calm-notifications " .. dndStatusBeforeZoom, true)
    hs.printf('Restored DND to original state:%s', dndStatusBeforeZoom)
  elseif (event == "from-closed-to-running") then
    dndStatusBeforeZoom, status, termType = hs.execute("calm-notifications status", true):gsub("\n$", "")
    if dndStatusBeforeZoom == "off" then
      hs.execute("calm-notifications on", true)
    end
    hs.printf('DND original state:%s', dndStatusBeforeZoom)
  end
end

hs.loadSpoon("Zoom")
spoon.Zoom:setStatusCallback(updateZoomStatus)
spoon.Zoom:start()