-- JXKO FLY GUI | Roblox Mobile + PC
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local old=player.PlayerGui:FindFirstChild("JXKO_FLY_GUI")
if old then old:Destroy() end
local enabled=false
local speed=55
local up,down=false,false
local bv,bg
local connection
local gui=Instance.new("ScreenGui")
gui.Name="JXKO_FLY_GUI";gui.ResetOnSpawn=false;gui.Parent=player.PlayerGui
local frame=Instance.new("Frame")
frame.Size=UDim2.fromOffset(240,255)
frame.Position=UDim2.new(.5,-120,.45,-127)
frame.BackgroundColor3=Color3.fromRGB(18,23,39)
frame.BorderSizePixel=0;frame.Active=true;frame.Draggable=true;frame.Parent=gui
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,14)
local outline=Instance.new("UIStroke",frame)
outline.Color=Color3.fromRGB(69,112,245);outline.Thickness=2
local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,-42,0,36);title.Position=UDim2.fromOffset(9,3)
title.BackgroundTransparency=1;title.Text="JXKO | FLY GUI";title.Font=Enum.Font.GothamBold
title.TextSize=16;title.TextXAlignment=Enum.TextXAlignment.Left
title.TextColor3=Color3.new(1,1,1)
local function button(label,x,y,w,h)
 local b=Instance.new("TextButton",frame)
 b.Size=UDim2.fromOffset(w,h);b.Position=UDim2.fromOffset(x,y)
 b.BackgroundColor3=Color3.fromRGB(43,63,119)
 b.Text=label;b.TextColor3=Color3.new(1,1,1)
 b.Font=Enum.Font.GothamBold;b.TextSize=14
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
 return b
end
local close=button("X",204,6,30,28)
local toggle=button("FLY : OFF",12,46,216,40)
local minus=button("-",12,94,45,36)
local speedLabel=Instance.new("TextLabel",frame)
speedLabel.Position=UDim2.fromOffset(63,94);speedLabel.Size=UDim2.fromOffset(114,36)
speedLabel.BackgroundTransparency=1;speedLabel.Font=Enum.Font.GothamBold
speedLabel.TextColor3=Color3.new(1,1,1);speedLabel.TextSize=15
local plus=button("+",183,94,45,36)
local upButton=button("UP",12,140,104,43)
local downButton=button("DOWN",124,140,104,43)
local hint=Instance.new("TextLabel",frame)
hint.Position=UDim2.fromOffset(10,191);hint.Size=UDim2.fromOffset(220,55)
hint.BackgroundTransparency=1;hint.TextWrapped=true
hint.Text="Joystick / WASD untuk bergerak\nTahan UP atau DOWN untuk vertikal"
hint.TextColor3=Color3.fromRGB(175,190,218)
hint.Font=Enum.Font.Gotham;hint.TextSize=11
local function refresh()
 speedLabel.Text="SPEED : "..speed
 toggle.Text=enabled and "FLY : ON" or "FLY : OFF"
 toggle.BackgroundColor3=enabled and Color3.fromRGB(30,138,112) or Color3.fromRGB(43,63,119)
end
local function cleanup()
 if connection then connection:Disconnect();connection=nil end
 if bv then bv:Destroy();bv=nil end
 if bg then bg:Destroy();bg=nil end
 local c=player.Character
 local hum=c and c:FindFirstChildOfClass("Humanoid")
 if hum then hum.PlatformStand=false;hum.AutoRotate=true end
 up=false;down=false
end
local function stop()
 enabled=false;cleanup();refresh()
end
local function start()
 cleanup()
 local c=player.Character
 local hum=c and c:FindFirstChildOfClass("Humanoid")
 local root=c and c:FindFirstChild("HumanoidRootPart")
 if not hum or not root or hum.Health<=0 then enabled=false;refresh();return end
 enabled=true;hum.PlatformStand=true;hum.AutoRotate=false
 bv=Instance.new("BodyVelocity")
 bv.Name="JXKO_FlyVelocity";bv.MaxForce=Vector3.new(1e8,1e8,1e8)
 bv.P=10000;bv.Velocity=Vector3.zero;bv.Parent=root
 bg=Instance.new("BodyGyro")
 bg.Name="JXKO_FlyGyro";bg.MaxTorque=Vector3.new(1e8,1e8,1e8)
 bg.P=10000;bg.D=500;bg.CFrame=root.CFrame;bg.Parent=root
 connection=RunService.RenderStepped:Connect(function()
  if not enabled or not root.Parent or hum.Health<=0 then stop();return end
  local camera=workspace.CurrentCamera
  if not camera then return end
  local move=hum.MoveDirection
  local vertical=(up and 1 or 0)-(down and 1 or 0)
  local direction=move+Vector3.new(0,vertical,0)
  if direction.Magnitude>1 then direction=direction.Unit end
  bv.Velocity=direction*speed
  local look=camera.CFrame.LookVector
  local flat=Vector3.new(look.X,0,look.Z)
  if flat.Magnitude>.001 then bg.CFrame=CFrame.lookAt(root.Position,root.Position+flat.Unit) end
 end)
 refresh()
end
toggle.MouseButton1Click:Connect(function() if enabled then stop() else start() end end)
minus.MouseButton1Click:Connect(function() speed=math.max(5,speed-10);refresh() end)
plus.MouseButton1Click:Connect(function() speed=math.min(250,speed+10);refresh() end)
local function hold(button,setter)
 button.InputBegan:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then setter(true) end
 end)
 button.InputEnded:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then setter(false) end
 end)
end
hold(upButton,function(v) up=v end)
hold(downButton,function(v) down=v end)
local keyConn=UIS.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.KeyCode==Enum.KeyCode.E then up=true end
 if input.KeyCode==Enum.KeyCode.Q then down=true end
end)
local keyEndConn=UIS.InputEnded:Connect(function(input)
 if input.KeyCode==Enum.KeyCode.E then up=false end
 if input.KeyCode==Enum.KeyCode.Q then down=false end
end)
local respawnConn=player.CharacterAdded:Connect(function()
 if enabled then stop() end
end)
close.MouseButton1Click:Connect(function()
 stop();keyConn:Disconnect();keyEndConn:Disconnect();respawnConn:Disconnect();gui:Destroy()
end)
refresh()
