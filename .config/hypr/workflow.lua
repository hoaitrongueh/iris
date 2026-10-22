local home = os.getenv('HOME')
hl.bind('SUPER + Q', hl.dsp.window.close())
hl.bind('SUPER + C', hl.dsp.exec_cmd('caelestia clipboard'))
hl.bind('SUPER + CTRL + L', hl.dsp.global('caelestia:lock'))
hl.bind('SUPER + SHIFT + S', hl.dsp.exec_cmd(home .. '/.local/bin/workstation-screenshot region'))
hl.bind('SUPER + CTRL + S', hl.dsp.window.move({workspace = 'special:magic'}))
hl.bind('SUPER + CTRL + J', hl.dsp.layout('togglesplit'))
hl.bind('ALT + Tab', hl.dsp.exec_cmd(home .. '/.local/bin/workstation-cycle'))
hl.bind('ALT + SHIFT + Tab', hl.dsp.exec_cmd(home .. '/.local/bin/workstation-cycle --reverse'))
for key, direction in pairs({H='left', J='down', K='up', L='right'}) do
    hl.bind('SUPER + ' .. key, hl.dsp.focus({direction = direction}))
    hl.bind('SUPER + SHIFT + ' .. key, hl.dsp.window.move({direction = direction}))
end

hl.monitor({output = '', mode = 'preferred', position = 'auto', scale = 1})
hl.workspace_rule({workspace = 'w[tv1]', gaps_out = 0, gaps_in = 0})
hl.config({input = {repeat_rate = 35, repeat_delay = 300, touchpad = {tap_to_click = true}}})
