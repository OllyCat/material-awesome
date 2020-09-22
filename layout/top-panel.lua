local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

local home_dir = os.getenv("HOME")

-- Keyboard map indicator and switcher
local kbdimage = wibox.widget.imagebox()
kbdimage:set_image(home_dir .. "/.icons/flags/Eng.png")
local kbd_widget = wibox.container.margin(kbdimage, dpi(8), dpi(8), dpi(8), dpi(8))

function mykey_update(...)
      local data = {...}
       local layout = data[2]
       lts = {
             [0] = home_dir .. "/.icons/flags/Eng.png",
             [1] = home_dir .. "/.icons/flags/Rus.png",
             [2] = home_dir .. "/.icons/flags/not_set.png",
             [3] = home_dir .. "/.icons/flags/not_set.png",
             [4] = home_dir .. "/.icons/flags/not_set.png",
             [5] = home_dir .. "/.icons/flags/not_set.png",
             [6] = home_dir .. "/.icons/flags/not_set.png",
             [7] = home_dir .. "/.icons/flags/not_set.png",
             [8] = home_dir .. "/.icons/flags/not_set.png",
             [9] = home_dir .. "/.icons/flags/not_set.png"
       }
       kbdimage:set_image(lts[layout])
       return
end

dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", mykey_update)
-- keyboard indicator }}}

-- Clock / Calendar 24h format
--local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 9">%d.%m.%Y\n     %H:%M</span>')
local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 10">%H:%M</span>')

-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
  screen = s,
  start_sunday = false,
  week_numbers = true
})
month_calendar:attach(textclock)

local clock_widget = wibox.container.margin(textclock, dpi(8), dpi(8), dpi(8), dpi(8))

local add_button = mat_icon_button(mat_icon(icons.plus, dpi(24)))
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
      end
    )
  )
)

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
  local layoutBox = clickable_container(awful.widget.layoutbox(s))
  layoutBox:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        3,
        function()
          awful.layout.inc(-1)
        end
      ),
      awful.button(
        {},
        4,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        5,
        function()
          awful.layout.inc(-1)
        end
      )
    )
  )
  return layoutBox
end

local TopPanel = function(s, offset)
  local offsetx = 0
  if offset == true then
    offsetx = dpi(48)
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(48),
      width = s.geometry.width - offsetx,
      x = s.geometry.x + offsetx,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(48)
      }
    }
  )

  panel:struts(
    {
      top = dpi(48)
    }
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Create a taglist widget
      TaskList(s),
      add_button
    },
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Clock
      clock_widget,
	  -- Lang indicator
	  kbd_widget, 
      -- Layout box
      LayoutBox(s)
    }
  }

  return panel
end

return TopPanel
