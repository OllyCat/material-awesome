local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
		border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = client_keys,
        buttons = client_buttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        floating = false,
        maximized = false,
        above = false,
        below = false,
        ontop = false,
        sticky = false,
        maximized_horizontal = false,
        maximized_vertical = false
    }
  },
  {
    rule_any = {name = {'QuakeTerminal'}},
    properties = {skip_decoration = true}
  },
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
		  "plugin-container",
		  "xjadeo",
		  "ardour_mixer",
        },
        class = {
		"Anki",
		"Stardict",
		"Steam",
		"MPlayer",
		"mplayer2",
		"mpv",
		"feh",
		"Tk",
		"Ekiga", "ekiga",
		"Linphone", "linphone",
		"Blink", "blink",
		"Zoiper", "zoiper",
		"Fdclock",
		"zenity", "Zenity", "Yad",
		"Eviacam",
		"qjackctl",
		"Vkeybd.tcl",
		"Jack-keyboard",
		"Jack_mixer",
		"qsynth",
		"Pavumeter",
		"net-whn-loki-common-Main", -- для явавской морды Loki render менеджера blender
		"processing-app-Base",
        "Arandr",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "Yad",
        "Solaar",
        "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
		  "XBindKey",
		  "Ripple Desktop Wallet",
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = {
		  placement = awful.placement.centered,
		  floating = true,
		  drawBackdrop = true,
		  skip_decoration = true
	  }
  },
    -- for wine
    { rule_any = { class = {
	    ".exe",
	    "Wine",
	    },
	 },
      properties = {
		  --screen = 1,
		  --tag = "7",
		  placement = awful.placement.centered,
		  floating = true,
		  drawBackdrop = true,
		  skip_decoration = true,
	  }
  },
    -- Set Browser to always map on the tag named "1"
    { rule_any = { class = {
	    "firefox",
		"Navigator",
		"Vimperator",
	    "Google-chrome" },
	 },
      properties = {
		  --screen = 1,
		  tag = "1"
	  }
  },
    -- terminal to 2 tag
    { rule_any = { class = {
	    "xterm",
	    "Terminator",
	    "Gnome-terminal",
	    "Xfce4-terminal" },
	 },
      properties = {
		  --screen = 1,
		  tag = "2"
	  }
  },
    -- мессенджеры во 3-ой tag
    { rule_any = { class = {
	    "ViberPC",
	    -- "zoom",
	    "Telegram",
		"discord",
		"Teams",
		},
	 },
      properties = {
		  screen = 1,
		  tag = "3",
		  floating = false
	  }
  },

    { rule_any = { class = {
	    "Ekiga",
	    "Skype",
	    "Linphone video",
	    "Linphone",
	    },
	 },
      properties = {
		  screen = 1,
		  tag = "3",
		  floating = true
	  }
  },
  -- Titlebars
  {
    rule_any = {type = {'dialog'}, class = {'Wicd-client.py', 'calendar.google.com'}},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true,
      shape = function()
        return function(cr, w, h)
          gears.shape.rounded_rect(cr, w, h, 8)
        end
      end,
      skip_decoration = true
    }
  }
}
