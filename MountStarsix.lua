-- JXKO HUB | Mount Starsix
local P=game:GetService("Players").LocalPlayer
local H=game:GetService("HttpService")
local R=game:GetService("RunService")
local old=P.PlayerGui:FindFirstChild("JXKO_MountStarsix")
if old then old:Destroy() end
local file="JXKO_MountStarsix_CP.json"
local cp,summit,selected={},nil,1
local walk,jump,play,alive=false,false,false,true
local function char()
 local c=P.Character
 if c then return c:FindFirstChildOfClass("Humanoid"),c:FindFirstChild("HumanoidRootPart") end
end
local function save()
 if type(writefile)~="function" then return false end
 local d={cp={},summit=summit and {summit.X,summit.Y,summit.Z} or nil}
 for i,p in pairs(cp) do d.cp[tostring(i)]={p.X,p.Y,p.Z} end
 return pcall(function() writefile(file,H:JSONEncode(d)) end)
end
if type(readfile)=="function" and type(isfile)=="function" and isfile(file) then
 pcall(function()
  local d=H:JSONDecode(readfile(file))
  for i,p in pairs(d.cp or {}) do
   local n=tonumber(i)
   if n and n>=1 and n<=25 then cp[n]=Vector3.new(p[1],p[2],p[3]) end
  end
  if d.summit then summit=Vector3.new(unpack(d.summit)) end
 end)
end
local function scan()
 local found=0
 for _,o in ipairs(workspace:GetDescendants()) do
  local name=o.Name:lower()
  local n=tonumber(name:match("^cp[%s_%-]*(%d+)$") or name:match("^checkpoint[%s_%-]*(%d+)$"))
  local pos=o:IsA("BasePart") and o.Position or (o:IsA("Model") and o:GetPivot().Position)
  if pos and n and n>=1 and n<=25 then
   if not cp[n] then found=found+1 end
   cp[n]=pos
  elseif pos and (name=="summit" or name=="summitpart" or name=="summitplate") then summit=pos end
 end
 save()
 return found
end
local g=Instance.new("ScreenGui",P.PlayerGui)
g.Name="JXKO_MountStarsix";g.ResetOnSpawn=false
local f=Instance.new("Frame",g)
f.Size=UDim2.fromOffset(290,390);f.Position=UDim2.new(.5,-145,.5,-195)
f.BackgroundColor3=Color3.fromRGB(18,21,35);f.Active=true;f.Draggable=true
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
local t=Instance.new("TextLabel",f)
t.Size=UDim2.new(1,-42,0,38);t.Position=UDim2.fromOffset(10,0)
t.Text="JXKO HUB | MOUNT STARSIX";t.TextColor3=Color3.new(1,1,1)
t.TextSize=14;t.Font=Enum.Font.GothamBold;t.BackgroundTransparency=1
local x=Instance.new("TextButton",f)
x.Size=UDim2.fromOffset(30,28);x.Position=UDim2.new(1,-35,0,5)
x.Text="X";x.TextColor3=Color3.new(1,1,1);x.BackgroundColor3=Color3.fromRGB(175,55,70)
local s=Instance.new("ScrollingFrame",f)
s.Position=UDim2.fromOffset(10,40);s.Size=UDim2.new(1,-20,1,-82)
s.BackgroundTransparency=1;s.ScrollBarThickness=3;s.AutomaticCanvasSize=Enum.AutomaticSize.Y
s.CanvasSize=UDim2.new()
local l=Instance.new("UIListLayout",s);l.Padding=UDim.new(0,6)
local st=Instance.new("TextLabel",f)
st.Size=UDim2.new(1,-20,0,35);st.Position=UDim2.new(0,10,1,-38)
st.Text="Ready";st.TextColor3=Color3.fromRGB(155,195,255)
st.TextSize=12;st.TextWrapped=true;st.BackgroundTransparency=1
local function msg(v) st.Text=v;print("[JXKO HUB] "..v) end
local function button(label,fn)
 local b=Instance.new("TextButton",s)
 b.Size=UDim2.new(1,-4,0,37);b.Text=label;b.Font=Enum.Font.GothamBold
 b.TextSize=12;b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(42,58,105)
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
 b.MouseButton1Click:Connect(function() if alive then fn(b) end end)
 return b
end
button("SCAN CHECKPOINT",function()
 local n=scan();local total=0
 for _ in pairs(cp) do total=total+1 end
 msg("CP baru: "..n.." | total: "..total)
end)
button("CP -",function() selected=math.max(1,selected-1);msg("CP "..selected) end)
button("CP +",function() selected=math.min(25,selected+1);msg("CP "..selected) end)
button("SIMPAN CP SAAT INI",function()
 local _,root=char()
 if root then cp[selected]=root.Position;msg(save() and "CP tersimpan permanen" or "CP tersimpan sesi ini") end
end)
local function tp(p)
 local hum,root=char()
 if not hum or not root or not p then return false end
 hum:Move(Vector3.zero,false);root.CFrame=CFrame.new(p+Vector3.new(0,4,0))
 return true
end
button("TELEPORT CP",function() msg(tp(cp[selected]) and ("Teleport CP "..selected) or "CP belum ditemukan") end)
button("SIMPAN SUMMIT SAAT INI",function()
 local _,root=char()
 if root then summit=root.Position;save();msg("Summit tersimpan") end
end)
button("TELEPORT SUMMIT",function() msg(tp(summit) and "Teleport summit" or "Summit belum ditemukan") end)
button("AUTO WALK: OFF",function(b) walk=not walk;b.Text="AUTO WALK: "..(walk and "ON" or "OFF") end)
button("AUTO JUMP: OFF",function(b) jump=not jump;b.Text="AUTO JUMP: "..(jump and "ON" or "OFF") end)
local function walkTo(p)
 local start=os.clock()
 while alive and play and os.clock()-start<50 do
  local hum,root=char()
  if not hum or not root or hum.Health<=0 then return false end
  if (root.Position-p).Magnitude<6 then return true end
  hum:MoveTo(p)
  if jump and hum.FloorMaterial~=Enum.Material.Air then hum.Jump=true end
  task.wait(.3)
 end
 return false
end
button("AUTO PLAY / SUMMIT: OFF",function(b)
 play=not play;b.Text="AUTO PLAY / SUMMIT: "..(play and "ON" or "OFF")
 if not play then return end
 task.spawn(function()
  for i=selected,25 do
   if not play or not alive then break end
   if not cp[i] then msg("CP "..i.." belum tersedia");break end
   msg("Berjalan ke CP "..i)
   if not walkTo(cp[i]) then msg("Rute gagal di CP "..i);break end
  end
  if play and summit then msg(walkTo(summit) and "Rute selesai; win server tidak dijamin" or "Gagal menuju summit") end
  play=false;if alive then b.Text="AUTO PLAY / SUMMIT: OFF" end
 end)
end)
local connection=R.Heartbeat:Connect(function()
 if not alive or play then return end
 local hum,root=char()
 if not hum or not root or hum.Health<=0 then return end
 if walk then hum:Move(root.CFrame.LookVector,false) end
 if jump and hum.FloorMaterial~=Enum.Material.Air then hum.Jump=true end
end)
x.MouseButton1Click:Connect(function()
 alive=false;play=false;walk=false;jump=false;connection:Disconnect();g:Destroy()
end)
msg("Siap | CP baru: "..scan().." | CP 1-25")
