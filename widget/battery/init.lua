-------------------------------------------------
-- Battery Widget for Awesome Window Manager
-- Shows the battery status using the ACPI tool
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

_G.battery_persent=0

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/battery/icons/'

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.fixed.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(14), dpi(14), 4, 4))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('xfce4-power-manager-settings')
      end
    )
  )
)

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
--local battery_popup =
--  awful.tooltip(
--  {
--    objects = {widget_button},
--    mode = 'outside',
--    align = 'left',
--    preferred_positions = {'right', 'left', 'top', 'bottom'}
--  }
--)

local function battery_popup()
  naughty.notify {
    icon = PATH_TO_ICONS .. 'popup/' .. tostring(_G.battery_persent) .. '.svg',
    icon_size = dpi(200),
    timeout = 15,
    hover_timeout = 0.5,
    position = 'bottom_left',
    --bg = '#d32f2f',
    --fg = '#EEE9EF',
    width = 240
  }
end

widget_button:connect_signal('mouse::enter', battery_popup)

-- To use colors from beautiful theme put
-- following lines in rc.lua before require("battery"):
--beautiful.tooltip_fg = beautiful.fg_normal
--beautiful.tooltip_bg = beautiful.bg_normal

local function show_battery_warning()
  naughty.notify {
    icon = PATH_TO_ICONS .. 'battery-alert.svg',
    icon_size = dpi(48),
    text = 'Huston, we have a problem',
    title = 'Battery is dying',
    timeout = 5,
    hover_timeout = 0.5,
    position = 'bottom_left',
    bg = '#d32f2f',
    fg = '#EEE9EF',
    width = 248
  }
end

local last_battery_check = os.time()

function battery_status()
	awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT1/uevent | tr '\n' ' '",
		function(s)
			local batteryIconName = 'battery'

			local status = string.match(s, 'POWER_SUPPLY_STATUS=(%a+)')
			local charge_str = string.match(s, 'POWER_SUPPLY_CAPACITY=(%d+)')
			local charge = tonumber(charge_str)
			_G.battery_persent = charge

			if (charge >= 0 and charge < 20) then
			  if status ~= 'Charging' and os.difftime(os.time(), last_battery_check) > 300 then
				-- if 5 minutes have elapsed since the last warning
				last_battery_check = _G.time()

				show_battery_warning()
			  end
			end

			if status == 'Charging' or status == 'Full' or status == 'Unknown' then
			  batteryIconName = batteryIconName .. '-charging'
			end

			local roundedCharge = math.floor(charge / 10) * 10
			if (roundedCharge == 0) then
			  batteryIconName = batteryIconName .. '-outline'
			elseif (roundedCharge ~= 100) then
			  batteryIconName = batteryIconName .. '-' .. roundedCharge
			end

			widget.icon:set_image(PATH_TO_ICONS .. batteryIconName .. '.svg')
			-- Update popup text
			--battery_popup.text = string.gsub(s, '$', '')
			collectgarbage('collect')
		end)
end

local battery_timer = gears.timer({timeout = 1})
battery_timer:connect_signal("timeout", function() battery_status() end)
battery_timer:start()

return widget_button
