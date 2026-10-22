-- IRIS for installed Hyprland 0.56 Lua API. Loaded last; existing apps untouched.
local home = os.getenv("HOME")
local bin = home .. "/.local/bin/"
local function bind(key, command)
    hl.unbind(key)
    hl.bind(key, hl.dsp.exec_cmd(command))
end
-- Hot path stays inside the compositor until systemd starts Kitty.
function iris_leave_dashboard()
    hl.exec_cmd(bin .. "iris-dashboard hide")
end
function iris_open_terminal(role)
    iris_leave_dashboard()
    hl.exec_cmd("systemd-run --user --quiet --collect --service-type=exec --property=ExitType=cgroup --property=PartOf=graphical-session.target --slice=app-graphical.slice --description=IRIS-terminal -- kitty --single-instance --instance-group iris-interactive --class iris-" .. role)
end
hl.unbind("SUPER + Return")
hl.unbind("SUPER + SHIFT + Return")
hl.bind("SUPER + Return", function() iris_open_terminal("float") end)
hl.bind("SUPER + SHIFT + Return", function() iris_open_terminal("tile") end)
bind("SUPER + space", bin .. "iris-launcher")
bind("SUPER + R", bin .. "iris-launcher")
bind("SUPER + W", bin .. "iris workstation-zen")
bind("SUPER + D", bin .. "iris workstation-editor")
bind("SUPER + E", bin .. "iris dolphin")
bind("SUPER + CTRL + P", bin .. "iris spotify-launcher")
bind("SUPER + S", bin .. "iris-terminal scratch")
bind("SUPER + G", bin .. "iris-dashboard toggle")
bind("SUPER + SHIFT + G", bin .. "iris-dashboard clock")
bind("SUPER + CTRL + G", bin .. "iris-dashboard identity")
bind("SUPER + F1", "kitty --single-instance --instance-group iris-interactive --class iris-float less " .. home .. "/.config/iris/KEYBINDINGS.md")
-- MRU: repeated Alt+Tab returns to the last focused visible window.
hl.unbind("ALT + Tab")
function iris_focus_recent()
    local active = hl.get_active_window()
    local monitor = hl.get_active_monitor()
    local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not ws or not monitor then return end
    local candidates = {}
    for _, w in ipairs(hl.get_windows()) do
        if w.mapped and not w.hidden and (not active or w.address ~= active.address)
            and w.workspace and w.workspace.id == ws.id then
            table.insert(candidates, w)
        end
    end
    table.sort(candidates, function(a,b) return a.focus_history_id < b.focus_history_id end)
    if candidates[1] then hl.dispatch(hl.dsp.focus({window=candidates[1]})) end
end
hl.bind("ALT + Tab", iris_focus_recent)
-- Alt+Shift+Tab retains the existing stable reverse traversal for >2 windows.
hl.config({decoration={blur={size=3,passes=1,vibrancy=0.0},dim_special=0.0},
    binds={hide_special_on_workspace_change=true}})
hl.window_rule({name="iris-floating-terminal",match={class="^iris-float$"},
    float=true,size="monitor_w*0.46 monitor_h*0.42"})
hl.window_rule({name="iris-scratch-geometry",match={class="^iris-scratch$"},
    float=true,size="monitor_w*0.56 monitor_h*0.50",center=true})
hl.window_rule({name="iris-tiled-terminal",match={class="^iris-tile$"},float=false})
hl.window_rule({name="iris-terminal-glass",match={class="^iris-.*$"},
    opacity="1.0 override 1.0 override",opaque=false,no_blur=false,rounding=12})
hl.window_rule({name="iris-scratch-workspace",match={class="^iris-scratch$"},workspace="special:magic silent"})
-- Current workspace stays available for editor/browser/terminal development.
hl.window_rule({name="iris-music-workspace",match={class="^(Spotify|spotify)$"},workspace="8 silent"})
hl.layer_rule({name="iris-launcher-glass",match={namespace="^launcher$"},blur=true,ignore_alpha=0.05})

-- Fast subtle opening, still animated. No launch delays or resident prewarming.
hl.animation({leaf="windowsIn",enabled=true,speed=1.2,bezier="easeOutQuint",style="popin 98%"})
hl.animation({leaf="fadeIn",enabled=true,speed=1.0,bezier="almostLinear"})

-- Loose composition: random positions, allowing overlap without exact stacking.
local function iris_scatter_window(w)
    local m=w.monitor
    if not m or not w.workspace then return end
    local mw,mh=m.width/m.scale,m.height/m.scale
    local left,top=m.x+32,m.y+36
    local spanX=math.max(0,mw-w.size.x-64)
    local spanY=math.max(0,mh-w.size.y-72)
    local best,bestScore=nil,math.huge
    for attempt=1,24 do
        local p={left+math.random()*spanX,top+math.random()*spanY}
        local score=0
        for _,other in ipairs(hl.get_windows()) do
            if other.address~=w.address and other.mapped and other.floating
                and other.workspace and other.workspace.id==w.workspace.id then
                local dx,dy=math.abs(p[1]-other.at.x),math.abs(p[2]-other.at.y)
                -- Reject near-identical origins, while keeping natural overlap.
                score=score+math.max(0,140-dx)*math.max(0,95-dy)
            end
        end
        if score<bestScore then best,bestScore=p,score end
        if score==0 then break end
    end
    hl.dispatch(hl.dsp.window.move({window=w,x=math.floor(best[1]),y=math.floor(best[2]),relative=false}))
end
hl.on("window.open", function(w)
    if w.class=="iris-float" then iris_scatter_window(w) end
end)

-- Explicit cleanup action: arrange only casual floating terminals here.
function iris_tidy_terminals()
    local m=hl.get_active_monitor()
    local ws=hl.get_active_special_workspace() or hl.get_active_workspace()
    if not m or not ws then return end
    local windows={}
    for _,w in ipairs(hl.get_windows()) do
        if w.class=="iris-float" and w.mapped and w.floating and w.monitor
            and w.monitor.id==m.id and w.workspace and w.workspace.id==ws.id then
            table.insert(windows,w)
        end
    end
    table.sort(windows,function(a,b) return a.stable_id<b.stable_id end)
    local n=#windows
    if n==0 then return end
    local cols=math.ceil(math.sqrt(n))
    local rows=math.ceil(n/cols)
    local mw,mh=m.width/m.scale,m.height/m.scale
    local cw,ch=(mw-48)/cols,(mh-56)/rows
    local width=math.floor(math.min(mw*0.46,cw-20))
    local height=math.floor(math.min(mh*0.42,ch-20))
    for i,w in ipairs(windows) do
        local col,row=(i-1)%cols,math.floor((i-1)/cols)
        local x=m.x+24+col*cw+(cw-width)/2
        local y=m.y+28+row*ch+(ch-height)/2
        hl.dispatch(hl.dsp.window.resize({window=w,x=width,y=height,relative=false}))
        hl.dispatch(hl.dsp.window.move({window=w,x=math.floor(x),y=math.floor(y),relative=false}))
    end
end
hl.unbind("SUPER + CTRL + Return")
hl.bind("SUPER + CTRL + Return", iris_tidy_terminals)

-- Floating IRIS panels share the existing single-pass compositor blur.
hl.layer_rule({name="iris-shell-glass",match={namespace="^iris-(topbar|rail)$"},blur=true,ignore_alpha=0.05})

-- Print captures the visible frame immediately, including hover panels.
-- Cropped captures select from frozen pixels; lock captures render the lock UI.
for _, key in ipairs({"Print", "CTRL + Print", "SHIFT + Print", "SUPER + SHIFT + S"}) do hl.unbind(key) end
hl.bind("Print", hl.dsp.exec_cmd(bin .. "workstation-screenshot region"), {locked=true})
hl.bind("CTRL + Print", hl.dsp.exec_cmd(bin .. "workstation-screenshot full"), {locked=true})
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(bin .. "workstation-screenshot annotate"), {locked=true})
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(bin .. "workstation-screenshot region"), {locked=true})
