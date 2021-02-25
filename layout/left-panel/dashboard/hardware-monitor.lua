local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')

return wibox.widget {
  wibox.widget {
    wibox.widget {
      text = 'Hardware monitor',
      font = 'Roboto medium 12',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widget.cpu.cpu-meter'),
  require('widget.ram.ram-meter'),
  require('widget.temperature.temperature-meter'),
  wibox.widget {
    wibox.widget {
      text = '\t/',
      font = 'Roboto medium 10',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widget.harddrive.harddrive-root'),
  wibox.widget {
    wibox.widget {
      text = '\t/home/old',
      font = 'Roboto medium 10',
      widget = wibox.widget.textbox
    },
    widget = mat_list_item
  },
  require('widget.harddrive.harddrive-home'),
  layout = wibox.layout.fixed.vertical
}
