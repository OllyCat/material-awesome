local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_slider = require('widget.material.slider')
local mat_icon_button = require('widget.material.icon-button')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')
local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi

local slider =
  wibox.widget {
  read_only = false,
  widget = mat_slider
}

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/volume/icons/'
_G.vol_id = nil

function show_volume(vol)
  v = tostring(5 * (vol // 5))
  v = string.gsub(v, '%.%d+', '')
  _G.vol_id = naughty.notify {
	icon = PATH_TO_ICONS .. v .. '.svg',
	icon_size = dpi(250),
	timeout = 5,
	hover_timeout = 0.5,
	position = 'bottom_left',
	--bg = '#d32f2f',
	--fg = '#EEE9EF',
	width = 320,
	replaces_id = _G.vol_id
  }.id
end

slider:connect_signal(
  'property::value',
  function()
    spawn('pamixer --set-volume ' .. slider.value)
  end
)

watch(
  [[bash -c "pamixer --get-volume --get-mute"]],
  1,
  function(_, stdout)
    local mute = string.match(stdout, '^%a+')
    local volume = string.match(stdout, '%d+')
    slider:set_value(tonumber(volume))
    collectgarbage('collect')
  end
)

local icon =
  wibox.widget {
  image = icons.volume,
  widget = wibox.widget.imagebox
}

local button = mat_icon_button(icon)

local volume_setting =
  wibox.widget {
  button,
  slider,
  widget = mat_list_item
}

return volume_setting
