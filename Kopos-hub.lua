-- // KOPOS HUB - ELITE EDITION [FIXED TP SYSTEM] // --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kopos Hub | Elite Pro v6",
   LoadingTitle = "Cargando Kopos Hub...",
   LoadingSubtitle = "by Diftklee",
   ConfigurationSaving = { Enabled = true, FileName = "KoposConfig" },
   KeySystem = false
})

-- // TABS // --
local MainTab = Window:CreateTab("Movement & Fly", 4483362458)
local CombatTab = Window:CreateTab("Combat & Aim", 4483362458)
local MacroTab = Window:CreateTab("Macro / Clicker", 4483362458)
local VisualsTab = Window:CreateTab("Visuals & Players", 4483362458)
local MiscTab = Window:CreateTab("Misc & Godmode", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Mouse = LocalPlayer:GetMouse()
local SavedPos = nil

-- // 1. MOVEMENT & FLY // --
MainTab:CreateSlider({
   Name = "WalkSpeed", Range = {16, 250}, Increment = 1, Suffix = "Speed", CurrentValue = 16,
   Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end,
})

MainTab:CreateSlider({
   Name = "JumpPower", Range = {50, 500}, Increment = 1, Suffix = "Power", CurrentValue = 50,
   Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end end,
})

-- Fly Reparado
local flying = false
local bv, bg
MainTab:CreateToggle({
   Name = "Volar (Fly)", CurrentValue = false,
   Callback = function(v)
      flying = v
      local char = LocalPlayer.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local hrp = char.HumanoidRootPart
      if flying then
         bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.new(0,0,0)
         bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.CFrame = hrp.CFrame
         task.spawn(function()
            while flying and hrp.Parent do
               local cam = workspace.CurrentCamera; local moveDir = Vector3.new(0,0,0)
               if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
               bv.Velocity = moveDir * 50; bg.CFrame = cam.CFrame; task.wait()
            end
            if bv then bv:Destroy() end; if bg then bg:Destroy() end
         end)
      else if bv then bv:Destroy() end; if bg then bg:Destroy() end end
   end,
})

-- // 2. COMBAT // --
local aimlockEnabled = false
CombatTab:CreateToggle({
   Name = "Aimlock", CurrentValue = false, Callback = function(v) aimlockEnabled = v end,
})

RunService.RenderStepped:Connect(function()
   if aimlockEnabled then
      local closest = nil; local dist = math.huge
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
               local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
               if d < dist then dist = d; closest = p end
            end
         end
      end
      if closest and closest.Character:FindFirstChild("Head") then
         workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
      end
   end
end)

-- // 3. MACRO // --
MacroTab:CreateToggle({
   Name = "Auto Clicker", CurrentValue = false,
   Callback = function(v)
      _G.Macro = v
      task.spawn(function()
         while _G.Macro do
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait()
            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
            task.wait(0.05)
         end
      end)
   end,
})

-- // 4. VISUALS & TP // --
VisualsTab:CreateToggle({
   Name = "Player ESP", CurrentValue = false,
   Callback = function(v)
      _G.ESP = v
      while _G.ESP do
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("KoposESP") then
               local h = Instance.new("Highlight", p.Character); h.Name = "KoposESP"; h.FillColor = Color3.fromRGB(0, 255, 255)
            end
         end
         task.wait(1)
      end
      for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("KoposESP") then p.Character.KoposESP:Destroy() end end
   end,
})

local selectedPlayer = nil
local Dropdown = VisualsTab:CreateDropdown({
   Name = "Seleccionar Jugador",
   Options = {"Esperando lista..."},
   Callback = function(Option) selectedPlayer = Option end,
})

VisualsTab:CreateButton({
   Name = "Teleportar a Jugador",
   Callback = function()
      if selectedPlayer and Players:FindFirstChild(selectedPlayer) then
         LocalPlayer.Character.HumanoidRootPart.CFrame = Players[selectedPlayer].Character.HumanoidRootPart.CFrame
      else
         Rayfield:Notify({Title = "Error", Content = "Selecciona un jugador en el menú primero.", Duration = 3})
      end
   end,
})

VisualsTab:CreateButton({
   Name = "Actualizar Lista",
   Callback = function()
      local list = {}
      for _, p in pairs(Players:GetPlayers()) do table.insert(list, p.Name) end
      Dropdown:Refresh(list, true)
      Rayfield:Notify({Title = "Kopos Hub", Content = "Lista actualizada", Duration = 2})
   end,
})

-- // 5. MISC // --
MiscTab:CreateToggle({ Name = "Godmode", CurrentValue = false, Callback = function(v) _G.Godmode = v end })
RunService.Heartbeat:Connect(function()
   if _G.Godmode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.Health = 999999
   end
end)

Rayfield:LoadConfiguration()
