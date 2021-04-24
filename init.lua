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
    {name = 'Telegram', app = 'Telegram.app', screen = 'Built%-in Retina Display', unit = hs.layout.right50, layout = 'coding'}
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
    {name = 'Safari', app = 'Safari.app', screen = 'SAMSUNG', unit = hs.layout.maximized, layout = 'relax'}
  },
  meeting = {
    {name = 'OBS', app = 'OBS.app', screen = 'VX3276%-QHD', unit = units.center},
    {name = 'NDI Virtual Input', app = 'NDI Virtual Input.app', screen = 'VX3276%-QHD', unit = units.center},
    {name = 'zoom.us', app = 'zoom.us.app', screen = 'VX3276%-QHD', unit = units.center, layout = 'meeting'}
  },
  talk = {
    {name = 'VLC', app = 'VLC.app', screen = 'Built%-in Retina Display', unit = units.center},
    {name = 'zoom.us', app = 'zoom.us.app', screen = 'Built%-in Retina Display', unit = units.center, layout = 'talk'}
 }
}

function runLayout(layout)
  local zoomlayouts = Set{'meeting', 'talk'}
  local slowapps = Set{'Eclipse', 'zoom.us'}
  local last = #layout - 0
  local mainScreen = hs.screen.primaryScreen()
  hs.dialog.alert(mainScreen:currentMode().w/2, mainScreen:currentMode().h/2-91, function(result) print("Clicked " .. result) end, "Loading " .. layout[last].layout .. " layout ...")
  for i = 1,#layout do
    local t = layout[i]
    local theapp = hs.application.get(t.name)
    local appwait
    if theapp == nil then
      if slowapps[t.name] then
        appwait = 10
      else
        appwait = 5
      end
      theapp = hs.application.open(t.app, appwait)
    end
    local win = theapp:mainWindow()
    local screen
    if t.screen ~= nil then
      screen = hs.screen.find(t.screen)
    end
    win:move(t.unit, screen, true)
    if next(layout,i) == nil then
      local message
      if t.layout then
        if zoomlayouts[t.layout] then
          -- requires: brew install vitorgalvao/tiny-scripts/calm-notifications
          hs.execute("calm-notifications on", true)
        else
          hs.execute("calm-notifications off", true)
          if t.layout == 'relax' then
            if hs.screen.find('SAMSUNG') then
              local samsungaudio = hs.audiodevice.findOutputByName('SAMSUNG')
              if samsungaudio ~= nil then
                samsungaudio:setDefaultOutputDevice()
                showMessage("Default sound output", "Set default sound output to SAMSUNG audio")
              end
            end
            --hs.wifi.setPower(true)
            --hs.printf('Turned wifi on')
          else
            --hs.wifi.setPower(false)
            --hs.printf('Turned wifi off')
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

function Set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

function sendKeysToApp(appname, modifiers, char)
  local app = hs.application.get(appname)
  if app then
    hs.eventtap.keyStroke(modifiers, char, app)
  else
    showMessage("Send Keys To App", "You have to open " .. appname .. " first")
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

mash = {'shift', 'alt'}
hs.hotkey.bind(mash, '[', function() hs.window.focusedWindow():move(hs.layout.left50, nil, true) end)
hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(hs.layout.right50, nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum, nil, true) end)
hs.hotkey.bind(mash, ';', function() hs.window.focusedWindow():move(units.center, nil, true) end)
hs.hotkey.bind(mash, '0', function() runLayout(layouts.talk) end)
hs.hotkey.bind(mash, '9', function() runLayout(layouts.meeting) end)
hs.hotkey.bind(mash, '8', function() runLayout(layouts.covisit) end)
hs.hotkey.bind(mash, '7', function() runLayout(layouts.coding) end)
hs.hotkey.bind(mash, '6', function() runLayout(layouts.relax) end)
hs.hotkey.bind(mash, 's', function() sendKeysToApp('zoom.us', {'shift', 'cmd'}, 's') end)
hs.hotkey.bind(mash, 'n', function() sendKeysToApp('VLC', {'cmd'}, hs.keycodes.map['right']) end)
hs.hotkey.bind(mash, 'w', function() hs.wifi.setPower(not hs.wifi.interfaceDetails()['power']) end)