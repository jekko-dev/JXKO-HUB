-- JXKO HUB | Break and Steal an Egg | Auto Break
-- Uses equipped pickaxe Tool:Activate(), no guessed remote calls.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local old=player.PlayerGui:FindFirstChild("JXKO_EggBreak")
if old then old:Destroy() end
local active=false
local interval=.22
local running=true
local function getTool()
 local c=player.Character
 if not c then return nil end
 for _,v in ipairs(c:GetChildren()) do
  if v:IsA("Tool") and (v.Name:lower():find("pick") or v.Name:lower():find("axe")) then return v end
 end
 return c:FindFirstChildOfClass("Tool")
end
local gui=Instance.new("ScreenGui")
gui.Name="JXKO_EggBreak";gui.ResetOnSpawn=false;gui.Parent=player.PlayerGui
local frame=Instance.new("Frame")
frame.Size=UDim2.fromOffset(260,205);frame.Position=UDim2.new(.5,-130,.5,-100)
frame.BackgroundColor3=Color3.fromRGB(19,24,39);frame.Active=true;frame.Draggable=true;frame.Parent=gui
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,12)
local stroke=Instance.new("UIStroke",frame)
stroke.Color=Color3.fromRGB(72,110,230);stroke.Thickness=2
local function btn(label,y)
 local b=Instance.new("TextButton",frame)
 b.Size=UDim2.fromOffset(238,36);b.Position=UDim2.fromOffset(11,y)
 b.BackgroundColor3=Color3.fromRGB(40,62,115)
 b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=13;b.Text=label
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
 return b
end
local title=Instance.new("TextLabel",frame)
title.Size=UDim2.fromOffset(215,32);title.Position=UDim2.fromOffset(9,4)
title.Text="JXKO HUB | AUTO BREAK";title.BackgroundTransparency=1
title.Font=Enum.Font.GothamBold;title.TextSize=14;title.TextColor3=Color3.new(1,1,1)
local close=Instance.new("TextButton",frame)
close.Size=UDim2.fromOffset(28,27);close.Position=UDim2.fromOffset(227,5)
close.Text="X";close.TextColor3=Color3.new(1,1,1)
close.BackgroundColor3=Color3.fromRGB(175,52,65)
local toggle=btn("AUTO BREAK : OFF",40)
local slower=btn("SPEED -",83)
slower.Size=UDim2.fromOffset(112,36)
local faster=btn("SPEED +",83)
faster.Size=UDim2.fromOffset(112,36);faster.Position=UDim2.fromOffset(137,83)
local status=Instance.new("TextLabel",frame)
status.Size=UDim2.fromOffset(238,70);status.Position=UDim2.fromOffset(11,126)
status.BackgroundTransparency=1;status.TextWrapped=true
status.TextColor3=Color3.fromRGB(175,197,239);status.TextSize=12
status.Font=Enum.Font.Gotham
local function refresh()
 toggle.Text="AUTO BREAK : "..(active and "ON" or "OFF")
 status.Text=string.format("Interval: %.2fs\nEquip pickaxe and stand near an egg.\nUses normal tool activation.",interval)
end
toggle.MouseButton1Click:Connect(function() active=not active;refresh() end)
slower.MouseButton1Click:Connect(function() interval=math.min(1,interval+.05);refresh() end)
faster.MouseButton1Click:Connect(function() interval=math.max(.1,interval-.05);refresh() end)
task.spawn(function()
 while running do
  if active then
   local tool=getTool()
   if tool then pcall(function() tool:Activate() end) end
  end
  task.wait(interval)
 end
end)
close.MouseButton1Click:Connect(function() running=false;active=false;gui:Destroy() end)
refresh()
