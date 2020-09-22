local filesystem = require('gears.filesystem')

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local rofi_command = 'env /usr/bin/rofi -dpi ' .. get_dpi() .. ' -width ' .. with_dpi(400) .. ' -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi.rasi -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'terminator',
    rofi = rofi_command,
    lock = 'i3lock -i /home/olly/backup/pics/background/wave01.jpg',
    quake = 'terminator',
    screenshot = 'flameshot full -p ~/screenshots',
    region_screenshot = 'flameshot gui -p ~/screenshots',
    delayed_screenshot = 'flameshot full -p ~/screenshots -d 5000',
    browser = 'google-chrome-stable',
    editor = 'gvim', -- gui text editor
    social = '/home/olly/bin/Telegram/Telegram',
    game = rofi_command,
    files = 'Thunar',
    music = rofi_command 
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
	'xgamma -rgamma 0.91 -ggamma 0.72 -bgamma 0.70',
    'picom --config ' .. filesystem.get_configuration_dir() .. '/configuration/picom.conf',
    'nm-applet --indicator', -- wifi
    'pasystray', -- shows an audiocontrol applet in systray when installed.
    'blueman-applet', -- Bluetooth tray icon
    --'numlockx on', -- enable numlock
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    'xfce4-power-manager', -- Power manager
    'flameshot',
    -- '/usr/bin/barrier',
    -- '~/.local/bin/wallpaper', -- wallpaper-reddit script
	'clipit',
	'remmina -i',
	'redshift-gtk',
	'stardict',
	'udiskie -s',
	'~/bin/xinput.sh',
	'~/bin/kbdd',
    -- Add applications that need to be killed between reloads
    -- to avoid multipled instances, inside the awspawn script
    '~/.config/awesome/configuration/awspawn' -- Spawn "dirty" apps that can linger between sessions
  }
}
