local awful = require('awful')
require('awful.autofocus')
local naughty = require('naughty')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local apps = require('configuration.apps')

local home_dir = os.getenv('HOME')

-- Key bindings
local globalKeys =
  awful.util.table.join(
  -- Hotkeys
  awful.key({modkey}, 'F1', hotkeys_popup.show_help, {description = 'show help', group = 'awesome'}),
  -- Tag browsing
  awful.key({modkey}, 'w', awful.tag.viewprev, {description = 'view previous', group = 'tag'}),
  awful.key({modkey}, 's', awful.tag.viewnext, {description = 'view next', group = 'tag'}),
  --awful.key({altkey, 'Control'}, 'Up', awful.tag.viewprev, {description = 'view previous', group = 'tag'}),
  --awful.key({altkey, 'Control'}, 'Down', awful.tag.viewnext, {description = 'view next', group = 'tag'}),
  awful.key({modkey}, 'Escape', awful.tag.history.restore, {description = 'go back', group = 'tag'}),
  -- Default client focus
  awful.key(
    {modkey},
    'd',
    function()
      awful.client.focus.byidx(1)
    end,
    {description = 'focus next by index', group = 'client'}
  ),
  awful.key(
    {modkey},
    'a',
    function()
      awful.client.focus.byidx(-1)
    end,
    {description = 'focus previous by index', group = 'client'}
  ),
  awful.key(
    {modkey},
    'r',
    function()
      _G.screen.primary.left_panel:toggle(true)
    end,
    {description = 'show main menu', group = 'awesome'}
  ),
  awful.key({modkey}, 'u', awful.client.urgent.jumpto, {description = 'jump to urgent client', group = 'client'}),
  awful.key(
    {altkey},
    'Tab',
    function()
      --awful.client.focus.history.previous()
      awful.client.focus.byidx(1)
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end,
    {description = 'Switch to next window', group = 'client'}
  ),
  --awful.key(
  --  {altkey, 'Shift'},
  --  'Tab',
  --  function()
  --    --awful.client.focus.history.previous()
  --    awful.client.focus.byidx(-1)
  --    if _G.client.focus then
  --      _G.client.focus:raise()
  --    end
  --  end,
  --  {description = 'Switch to previous window', group = 'client'}
  --),
  -- Programms
  awful.key(
    {},
    'XF86Calculator',
    function()
      awful.spawn(apps.default.lock)
    end,
    {description = 'Lock the screen', group = 'awesome'}
  ),
  --awful.key(
  --  {},
  --  'XF86Display',
  --  function()
  --  	awful.spawn.easy_async("xrandr", function(out)
  --  		for line in out:gmatch("[^\n]*") do
  --  			con = string.match(line, "^([^ ]+) connected ")
  --  			if con then
  --  				res = string.match(line, " connected [^0-9]*(%d+x%d+)")
  --  				if con and res then
  --  					awful.spawn(home_dir .. "/.screenlayout/int-mon.sh", false)
  --  				else
  --  					awful.spawn(home_dir .. "/.screenlayout/two-mon-auto.sh", false)
  --  				end
  --  			end
  --  		end 
  --  	end)
  --  end,
  --  {description = 'подключение монитора', group = 'awesome'}
  --),
  awful.key(
    {modkey},
    'Print',
    function()
      awful.util.spawn_with_shell(apps.default.delayed_screenshot)
    end,
    {description = 'Mark an area and screenshot it 10 seconds later (clipboard)', group = 'screenshots (clipboard)'}
  ),
  --awful.key(
  --  {modkey},
  --  'p',
  --  function()
  --    awful.util.spawn_with_shell(apps.default.screenshot)
  --  end,
  --  {description = 'Take a screenshot of your active monitor and copy it to clipboard', group = 'screenshots (clipboard)'}
  --),
  awful.key(
    {altkey, 'Shift'},
    'Print',
    function()
      awful.util.spawn_with_shell(apps.default.region_screenshot)
    end,
    {description = 'Mark an area and screenshot it to your clipboard', group = 'screenshots (clipboard)'}
  ),
  --awful.key(
  --  {modkey},
  --  'c',
  --  function()
  --    awful.util.spawn(apps.default.editor)
  --  end,
  --  {description = 'open a text/code editor', group = 'launcher'}
  --),
  awful.key(
    {modkey},
    'b',
    function()
      awful.util.spawn(apps.default.browser)
    end,
    {description = 'open a browser', group = 'launcher'}
  ),
  -- Standard program
  awful.key({modkey, 'Control'}, 'r', _G.awesome.restart, {description = 'reload awesome', group = 'awesome'}),
  awful.key({modkey, 'Control'}, 'q', _G.awesome.quit, {description = 'quit awesome', group = 'awesome'}),
  awful.key(
    {altkey, 'Shift'},
    'Right',
    function()
      awful.tag.incmwfact(0.05)
    end,
    {description = 'increase master width factor', group = 'layout'}
  ),
  awful.key(
    {altkey, 'Shift'},
    'Left',
    function()
      awful.tag.incmwfact(-0.05)
    end,
    {description = 'decrease master width factor', group = 'layout'}
  ),
  awful.key(
    {altkey, 'Shift'},
    'Down',
    function()
      awful.client.incwfact(0.05)
    end,
    {description = 'decrease master height factor', group = 'layout'}
  ),
  awful.key(
    {altkey, 'Shift'},
    'Up',
    function()
      awful.client.incwfact(-0.05)
    end,
    {description = 'increase master height factor', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'Left',
    function()
      awful.tag.incnmaster(1, nil, true)
    end,
    {description = 'increase the number of master clients', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'Right',
    function()
      awful.tag.incnmaster(-1, nil, true)
    end,
    {description = 'decrease the number of master clients', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'Left',
    function()
      awful.tag.incncol(1, nil, true)
    end,
    {description = 'increase the number of columns', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'Right',
    function()
      awful.tag.incncol(-1, nil, true)
    end,
    {description = 'decrease the number of columns', group = 'layout'}
  ),
  awful.key(
    {modkey},
    'space',
    function()
      awful.layout.inc(1)
    end,
    {description = 'select next', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'space',
    function()
      awful.layout.inc(-1)
    end,
    {description = 'select previous', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'space',
    awful.client.floating.toggle,
    {description = 'toggle floating', group = 'client'}
  ),
  awful.key(
    {modkey},
    't',
	function()
      local c = client.focus
		c.ontop = not c.ontop
	end,
    {description = 'toggle keep on top', group = 'client'}
  ),
  awful.key(
    {modkey},
    'n',
    function()
		local c = client.focus
		-- The client currently has the input focus, so it cannot be minimized, since minimized clients can't have the focus.
		c.minimized = true
	end,
    {description = 'minimize', group = 'client'}
  ),
  awful.key(
    {modkey},
    'm',
    function()
		local c = client.focus
		-- The client currently has the input focus, so it cannot be minimized, since minimized clients can't have the focus.
		c.maximized = not c.maximized
		c:raise()
	end,
    {description = 'minimize', group = 'client'}
  ),
  awful.key(
    {modkey, 'Control'},
    'n',
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        _G.client.focus = c
        c:raise()
      end
    end,
    {description = 'restore minimized', group = 'client'}
  ),
  awful.key(
    {modkey, 'Control'},
    'i',
    function()
		local c = client.focus
		local geom = c:geometry()

		local t = ""
		if c.class    then t = t .. "<b>Class</b>: "    .. c.class    .. "\n" end
		if c.instance then t = t .. "<b>Instance</b>: " .. c.instance .. "\n" end
		if c.role     then t = t .. "<b>Role</b>: "     .. c.role     .. "\n" end
		if c.name     then t = t .. "<b>Name</b>: "     .. c.name     .. "\n" end
		if c.type     then t = t .. "<b>Type</b>: "     .. c.type     .. "\n" end
		if geom.width and geom.height and geom.x and geom.y then
			t = t .. "<b>Dimensions</b>: <b>x</b>:" .. geom.x .. "<b> y</b>:" .. geom.y .. "<b> w</b>:" .. geom.width .. "<b> h</b>:" .. geom.height
		end

		naughty.notify({
			text = t,
			timeout = 60
		})
    end,
    {description = 'window information', group = 'client'}
  ),
  --Dropdown application
  awful.key(
    {modkey},
    '`',
    function()
		_G.toggle_quake()
    end,
    {description = 'dropdown application', group = 'launcher'}
  ),
  -- Widgets popups
  --[[awful.key(
    {altkey},
    'h',
    function()
      if beautiful.fs then
        beautiful.fs.show(7)
      end
    end,
    {description = 'show filesystem', group = 'widgets'}
  ),
  awful.key(
    {altkey},
    'w',
    function()
      if beautiful.weather then
        beautiful.weather.show(7)
      end
    end,
    {description = 'show weather', group = 'widgets'}
  ),--]]
  -- Brightness
  awful.key(
    {},
    'XF86MonBrightnessUp',
    function()
      awful.spawn('xbacklight -inc 6')
    end,
    {description = '+6%', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86MonBrightnessDown',
    function()
      awful.spawn('xbacklight -dec 6')
    end,
    {description = '-6%', group = 'hotkeys'}
  ),
  -- ALSA volume control
  awful.key(
    {},
    'XF86AudioRaiseVolume',
    function()
      awful.spawn.easy_async('pamixer --allow-boost --get-volume -i 4', show_volume)
    end,
    {description = 'volume up', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioLowerVolume',
    function()
      awful.spawn.easy_async('pamixer --allow-boost --get-volume -d 4', show_volume)
    end,
    {description = 'volume down', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioMute',
    function()
      awful.spawn('pamixer -t')
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioNext',
    function()
      --
    end,
    {description = 'audio next', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86PowerDown',
    function()
      --
    end,
    {description = 'power down', group = 'hotkeys'}
  ),
  awful.key(
    {modkey},
    --'XF86Explorer',
    'F12',
    function()
      _G.exit_screen_show()
    end,
    {description = 'power off menu', group = 'hotkeys'}
  ),
  -- Open default program for tag
  awful.key(
    {modkey, 'Control'},
    't',
    function()
      awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
    end,
    {description = 'open default program for tag/workspace', group = 'tag'}
  ),
  -- Custom hotkeys
  -- Lutris hotkey
  awful.key(
    {modkey},
    'g',
    function()
      awful.util.spawn_with_shell('lutris')
    end
  ),
  -- System Monitor hotkey
  awful.key(
    {},
    'XF86Display',
    function()
      --awful.util.spawn_with_shell('mate-system-monitor')
    end
  ),
  -- File Manager
  awful.key(
    {modkey},
    'e',
    function()
      awful.util.spawn(apps.default.files)
    end,
    {description = 'filebrowser', group = 'hotkeys'}
  )
  -- Emoji Picker
  --awful.key(
  --  {modkey},
  --  'a',
  --  function()
  --    awful.util.spawn_with_shell('ibus emoji')
  --  end,
  --  {description = 'Open the ibus emoji picker to copy an emoji to your clipboard', group = 'hotkeys'}
  --)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
  local descr_view, descr_toggle, descr_move, descr_toggle_focus
  if i == 1 or i == 9 then
    descr_view = {description = 'view tag #', group = 'tag'}
    descr_toggle = {description = 'toggle tag #', group = 'tag'}
    descr_move = {description = 'move focused client to tag #', group = 'tag'}
    descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'tag'}
  end
  globalKeys =
    awful.util.table.join(
    globalKeys,
    -- View tag only.
    awful.key(
      {modkey},
      '#' .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      descr_view
    ),
    -- Toggle tag display.
    awful.key(
      {modkey, 'Control'},
      '#' .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      descr_toggle
    ),
    -- Move client to tag.
    awful.key(
      {modkey, 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:move_to_tag(tag)
          end
        end
      end,
      descr_move
    ),
    -- Toggle tag on focused client.
    awful.key(
      {modkey, 'Control', 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:toggle_tag(tag)
          end
        end
      end,
      descr_toggle_focus
    )
  )
end

return globalKeys
