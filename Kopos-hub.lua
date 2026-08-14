-- // KOPOS HUB - ELITE EDITION [FINAL V8: TP + NAME ESP] // --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kopos Hub | Elite Pro v8",
   LoadingTitle = "Cargando Kopos Hub...",
   LoadingSubtitle = "by Diftklee",
   ConfigurationSaving = { Enabled = true, FileName = "KoposConfig" },
   KeySystem = false
})

-- // TABS // --
local MainTab = Window:CreateTab("Movement", 4483362458)
local CombatTab = Window:CreateTab("Combat & Aim", 4483362458)
local MacroTab = Window:CreateTab("Macro", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local OptionsTab = Window:CreateTab("Options & Misc", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- // 1. MOVEMENT // --
MainTab:CreateSlider({
   Name = "WalkSpeed", Range = {16, 250}, Increment = 1, Suffix = "Speed", CurrentValue = 16,
   Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end,
})

MainTab:CreateSlider({
   Name = "JumpPower", Range = {50, 500}, Increment = 1, Suffix = "Power", CurrentValue = 50,
   Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.UseJumpPower = true; LocalPlayer.Character.Humanoid.JumpPower = v end end,
})

-- // 2. COMBAT // --
CombatTab:CreateToggle({ Name = "Aimlock", CurrentValue = false, Callback = function(v) _G.Aimlock = v end })
RunService.RenderStepped:Connect(function()
   if _G.Aimlock then
      local closest = nil; local dist = math.huge
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
               local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
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
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(); VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(0.05)
         end
      end)
   end,
})

-- // 4. VISUALS (ESP CON NOMBRES MEJORADO) // --
VisualsTab:CreateToggle({
   Name = "ESP + Nombres", CurrentValue = false,
   Callback = function(v)
      _G.ESP = v
      while _G.ESP do
         for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("KoposNameTag") then
               -- Crear Highlight
               local h = Instance.new("Highlight", p.Character); h.Name = "KoposESP"; h.FillColor = Color3.fromRGB(0, 255, 255)
               -- Crear Etiqueta de Nombre
               local billboard = Instance.new("BillboardGui", p.Character.Head); billboard.Name = "KoposNameTag"
               billboard.Size = UDim2.new(0, 100, 0, 50); billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.AlwaysOnTop = true
               local label = Instance.new("TextLabel", billboard); label.Size = UDim2.new(1, 0, 1, 0); label.Text = p.Name; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.BackgroundTransparency = 1
            end
         end
         task.wait(1)
      end
      for _, p in pairs(Players:GetPlayers()) do 
         if p.Character and p.Character:FindFirstChild("KoposESP") then p.Character.KoposESP:Destroy() end
         if p.Character and p.Character.Head and p.Character.Head:FindFirstChild("KoposNameTag") then p.Character.Head.KoposNameTag:Destroy() end
      end
   end,
})

-- // 5. OPTIONS (NOCLIP + TP) // --
OptionsTab:CreateToggle({
   Name = "Noclip", CurrentValue = false,
   Callback = function(v)
      _G.Noclip = v
      RunService.Stepped:Connect(function()
         if _G.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
         end
      end)
   end,
})

local selectedPlayer = nil
local Dropdown = OptionsTab:CreateDropdown({ Name = "Seleccionar Jugador", Options = {"Actualiza la lista"}, Callback = function(Option) selectedPlayer = Option end })

OptionsTab:CreateButton({
   Name = "Teleportar a Jugador",
   Callback = function()
      local Target = Players:FindFirstChild(selectedPlayer)
      if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
         Rayfield:Notify({Title = "Kopos Hub", Content = "Teletransportado a: " .. Target.Name, Duration = 3})
      else
         Rayfield:Notify({Title = "Error", Content = "Selecciona un jugador válido.", Duration = 3})
      end
   end,
})

OptionsTab:CreateButton({
   Name = "Actualizar Lista",
   Callback = function()
      local list = {}
      for _, p in pairs(Players:GetPlayers()) do table.insert(list, p.Name) end
      Dropdown:Refresh(list, true)
   end,
})

Rayfield:LoadConfiguration()
