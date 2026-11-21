-- JXKO HUB | BREAK STEAL AN EGG
-- Universal client-side egg finder; no server bypass
local Players=game:GetService("Players")
local Run=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local P=Players.LocalPlayer
local old=P.PlayerGui:FindFirstChild("JXKO_EGG_HUB")
if old then old:Destroy() end
local alive=true
local esp=false
local farm=false
local collect=false
local speedOn=false
local jumpOn=false
local speed=24
local jumpHeight=12
local eggs={}
local marks={}
local connections={}
local function char()
 local c=P.Character
 if not c then return end
 return c:FindFirstChildOfClass("Humanoid"),c:FindFirstChild("HumanoidRootPart")
end
local function eggPart(o)
 if o:IsA("BasePart") then return o end
 if o:IsA("Model") then return o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart",true) end
end
local function isEgg(o)
 local name=o.Name:lower()
 return name=="egg" or name:match("^egg[%s_%-%d]") or name:match("[%s_%-]egg$") or name:match("^rareegg") or name:match("^goldegg")
end
local function scan()
 table.clear(eggs)
 local seen={}
 for _,o in ipairs(workspace:GetDescendants()) do
  if (o:IsA("BasePart") or o:IsA("Model")) and isEgg(o) then
   local part=eggPart(o)
   if part and not seen[part] then
    seen[part]=true
    table.insert(eggs,{object=o,part=part})
   end
  end
 end
 return #eggs
end
local function nearest()
 local _,root=char()
 if not root then return nil end
 local best,dist=nil,math.huge
 for _,item in ipairs(eggs) do
  if item.part.Parent then
   local d=(root.Position-item.part.Position).Magnitude
   if d<dist then best=item;dist=d end
  end
 end
 return best,dist
end
local g=Instance.new("ScreenGui")
g.Name="JXKO_EGG_HUB";g.ResetOnSpawn=false;g.Parent=P.PlayerGui
local f=Instance.new("Frame")
f.Size=UDim2.fromOffset(292,400);f.Position=UDim2.new(.5,-146,.5,-200)
f.BackgroundColor3=Color3.fromRGB(18,23,38)
f.BorderSizePixel=0;f.Active=true;f.Draggable=true;f.Parent=g
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
local stroke=Instance.new("UIStroke",f)
stroke.Color=Color3.fromRGB(75,125,245);stroke.Thickness=2
local title=Instance.new("TextLabel",f)
title.Size=UDim2.new(1,-48,0,40);title.Position=UDim2.fromOffset(10,0)
title.Text="JXKO HUB | STEAL AN EGG";title.Font=Enum.Font.GothamBold
title.TextSize=14;title.TextColor3=Color3.new(1,1,1)
title.TextXAlignment=Enum.TextXAlignment.Left;title.BackgroundTransparency=1
local close=Instance.new("TextButton",f)
close.Size=UDim2.fromOffset(30,28);close.Position=UDim2.new(1,-36,0,6)
close.Text="X";close.Font=Enum.Font.GothamBold
close.BackgroundColor3=Color3.fromRGB(170,50,65)
close.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",close).CornerRadius=UDim.new(0,7)
local sc=Instance.new("ScrollingFrame",f)
sc.Position=UDim2.fromOffset(10,43);sc.Size=UDim2.new(1,-20,1,-88)
sc.BackgroundTransparency=1;sc.ScrollBarThickness=4
sc.AutomaticCanvasSize=Enum.AutomaticSize.Y;sc.CanvasSize=UDim2.new()
local layout=Instance.new("UIListLayout",sc)
layout.Padding=UDim.new(0,6)
local status=Instance.new("TextLabel",f)
status.Position=UDim2.new(0,10,1,-42);status.Size=UDim2.new(1,-20,0,37)
status.BackgroundTransparency=1;status.TextWrapped=true
status.TextColor3=Color3.fromRGB(160,205,255)
status.TextSize=12;status.Font=Enum.Font.Gotham
local function msg(t)
 status.Text=t
 print("[JXKO EGG] "..t)
end
local function button(label,fn)
 local b=Instance.new("TextButton",sc)
 b.Size=UDim2.new(1,-5,0,38)
 b.BackgroundColor3=Color3.fromRGB(40,62,115)
 b.Text=label;b.TextColor3=Color3.new(1,1,1)
 b.Font=Enum.Font.GothamBold;b.TextSize=12
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
 b.MouseButton1Click:Connect(function() if alive then fn(b) end end)
 return b
end
local function clearMarks()
 for _,h in pairs(marks) do h:Destroy() end
 table.clear(marks)
end
local function refreshESP()
 clearMarks()
 if not esp then return end
 for _,item in ipairs(eggs) do
  if item.object.Parent then
   local h=Instance.new("Highlight")
   h.Name="JXKO_EGG_ESP"
   h.Adornee=item.object
   h.FillColor=Color3.fromRGB(255,200,40)
   h.OutlineColor=Color3.new(1,1,1)
   h.FillTransparency=.55
   h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
   h.Parent=g
   table.insert(marks,h)
  end
 end
end
button("SCAN EGGS",function()
 msg("Objects found: "..scan())
 refreshESP()
end)
button("EGG ESP : OFF",function(b)
 esp=not esp
 b.Text="EGG ESP : "..(esp and "ON" or "OFF")
 scan();refreshESP()
end)
button("TELEPORT NEAREST EGG",function()
 scan()
 local item=nearest()
 local _,root=char()
 if item and root then
  root.CFrame=CFrame.new(item.part.Position+Vector3.new(0,4,0))
  msg("Teleported near "..item.object.Name)
 else msg("No egg object detected") end
end)
button("AUTO FARM : OFF",function(b)
 farm=not farm
 b.Text="AUTO FARM : "..(farm and "ON" or "OFF")
 msg(farm and "Auto farm enabled" or "Auto farm disabled")
end)
button("AUTO COLLECT : OFF",function(b)
 collect=not collect
 b.Text="AUTO COLLECT : "..(collect and "ON" or "OFF")
 msg("Auto collect: "..(collect and "ON" or "OFF"))
end)
button("WALK SPEED -",function()
 speed=math.max(8,speed-4);msg("Speed: "..speed)
end)
button("WALK SPEED +",function()
 speed=math.min(100,speed+4);msg("Speed: "..speed)
end)
button("SPEED : OFF",function(b)
 speedOn=not speedOn;b.Text="SPEED : "..(speedOn and "ON" or "OFF")
end)
button("JUMP HEIGHT -",function()
 jumpHeight=math.max(2,jumpHeight-2);msg("Jump: "..jumpHeight)
end)
button("JUMP HEIGHT +",function()
 jumpHeight=math.min(80,jumpHeight+2);msg("Jump: "..jumpHeight)
end)
button("JUMP : OFF",function(b)
 jumpOn=not jumpOn;b.Text="JUMP : "..(jumpOn and "ON" or "OFF")
end)
local defaultSpeed,defaultJump,defaultUse
local function apply()
 local hum=char()
 if not hum then return end
 if defaultSpeed==nil then
  defaultSpeed=hum.WalkSpeed
  defaultJump=hum.JumpHeight
  defaultUse=hum.UseJumpPower
 end
 if speedOn then hum.WalkSpeed=speed end
 if jumpOn then hum.UseJumpPower=false;hum.JumpHeight=jumpHeight end
end
local heartbeat=Run.Heartbeat:Connect(function()
 if alive then apply() end
end)
table.insert(connections,heartbeat)
local function interact(item)
 -- ProximityPrompt must be in range; server may reject interactions
 local prompt=item.object:FindFirstChildWhichIsA("ProximityPrompt",true)
 if not prompt then
  prompt=item.part:FindFirstChildWhichIsA("ProximityPrompt",true)
 end
 if prompt and prompt.Enabled then
  local _,root=char()
  if root and (root.Position-prompt.Parent.Position).Magnitude<=prompt.MaxActivationDistance+2 then
   if type(fireproximityprompt)=="function" then
    pcall(fireproximityprompt,prompt)
   end
  end
 end
end
local worker=task.spawn(function()
 while alive do
  if farm or collect then
   scan()
   local item,dist=nearest()
   local hum,root=char()
   if item and hum and root and hum.Health>0 then
    if farm and dist>7 then
     hum:MoveTo(item.part.Position)
    elseif collect then
     interact(item)
    end
   end
  end
  task.wait(.7)
 end
end)
local respawn=P.CharacterAdded:Connect(function()
 defaultSpeed=nil;defaultJump=nil;defaultUse=nil
end)
table.insert(connections,respawn)
close.MouseButton1Click:Connect(function()
 alive=false;farm=false;collect=false;esp=false
 clearMarks()
 for _,c in ipairs(connections) do c:Disconnect() end
 local hum=char()
 if hum then
  if defaultSpeed then hum.WalkSpeed=defaultSpeed end
  if defaultJump then hum.JumpHeight=defaultJump end
  if defaultUse~=nil then hum.UseJumpPower=defaultUse end
 end
 g:Destroy()
end)
msg("Ready | Found "..scan().." egg objects")
