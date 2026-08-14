-- // KOPOS HUB - ELITE EDITION [RAYFIELD UI PRO] // --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kopos Hub | Elite Pro",
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
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(v)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = v
      end
   end,
})

MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Callback = function(v)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = v
      end
   end,
})

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(v)
      _G.Noclip = v
      RunService.Stepped:Connect(function()
         if _G.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.CanCollide = false end
            end
         end
      end)
   end,
})

-- Sistema de Vuelo (Fly)
local flying = false
local bv, bg
MainTab:CreateToggle({
   Name = "Volar (Fly)",
   CurrentValue = false,
   Callback = function(v)
      flying = v
      local char = LocalPlayer.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      
      if flying then
         bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Velocity = Vector3.new(0, 0, 0)
         
         bg = Instance.new("BodyGyro", char.HumanoidRootPart)
         bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
         bg.CFrame = char.HumanoidRootPart.CFrame
         
         task.spawn(function()
            while flying and char and char:FindFirstChild("HumanoidRootPart") do
               local cam = workspace.CurrentCamera
               local moveDir = Vector3.new()
               if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
               bv.Velocity = moveDir * 50
               bg.CFrame = cam.CFrame
               task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
         end)
      else
         if bv then bv:Destroy() end
         if bg then bg:Destroy() end
      end
   end,
})

-- // 2. COMBAT & AIMLOCK // --
local aimlockEnabled = false
CombatTab:CreateToggle({
   Name = "Aimlock (Apunta al más cercano)",
   CurrentValue = false,
   Callback = function(v)
      aimlockEnabled = v
   end,
})

RunService.RenderStepped:Connect(function()
   if aimlockEnabled then
      local closestPlayer = nil
      local shortestDistance = math.huge
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
               local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
               if dist < shortestDistance then
                  shortestDistance = dist
                  closestPlayer = p
               end
            end
         end
      end
      if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
         workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.Head.Position)
      end
   end
end)

-- // 3. MACRO / AUTOCLICKER // --
local macroEnabled = false
local clickDelay = 0.05

MacroTab:CreateToggle({
   Name = "Auto Clicker (Macro)",
   CurrentValue = false,
   Callback = function(v)
      macroEnabled = v
      task.spawn(function()
         while macroEnabled do
            pcall(function()
               VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
               task.wait()
               VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
            task.wait(clickDelay)
         end
      end)
   end,
})

MacroTab:CreateSlider({
   Name = "Velocidad de Macro (CPS)",
   Range = {1, 50},
   Increment = 1,
   Suffix = "CPS",
   CurrentValue = 20,
   Callback = function(v)
      clickDelay = 1 / v
   end,
})

-- // 4. VISUALS & PLAYERS // --
VisualsTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(v)
      _G.ESP = v
      task.spawn(function()
         while _G.ESP do
            for _, p in pairs(Players:GetPlayers()) do
               if p ~= LocalPlayer and p.Character then
                  if not p.Character:FindFirstChild("KoposESP") then
                     local h = Instance.new("Highlight", p.Character)
                     h.Name = "KoposESP"
                     h.FillColor = Color3.fromRGB(0, 255, 255)
                  end
               end
            end
            task.wait(1)
         end
         for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("KoposESP") then
               p.Character.KoposESP:Destroy()
            end
         end
      end)
   end,
})

local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end

local Dropdown = VisualsTab:CreateDropdown({
   Name = "Teleportar a Jugador",
   Options = PlayerList,
   CurrentOption = "",
   Callback = function(Option)
      local Target = Players:FindFirstChild(Option)
      if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
      end
   end,
})

VisualsTab:CreateButton({
   Name = "Actualizar Lista de Jugadores",
   Callback = function()
      PlayerList = {}
      for _, p in pairs(Players:GetPlayers()) do table.insert(PlayerList, p.Name) end
      Dropdown:Refresh(PlayerList)
   end,
})

-- // 5. MISC & GODMODE // --
MiscTab:CreateToggle({
   Name = "Godmode (Vida Infinita / HP Alto)",
   CurrentValue = false,
   Callback = function(v)
      _G.Godmode = v
   end,
})

RunService.Heartbeat:Connect(function()
   if _G.Godmode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.MaxHealth = 999999
      LocalPlayer.Character.Humanoid.Health = 999999
   end
end)

MiscTab:CreateButton({
   Name = "Guardar Checkpoint",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         SavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
         Rayfield:Notify({Title = "Kopos Hub", Content = "Checkpoint Guardado!", Duration = 3})
      end
   end,
})

MiscTab:CreateButton({
   Name = "Ir al Checkpoint",
   Callback = function()
      if SavedPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPos
      end
   end,
})

MiscTab:CreateToggle({
   Name = "Click TP (Ctrl + Click)",
   CurrentValue = false,
   Callback = function(v)
      _G.ClickTP = v
      UserInputService.InputBegan:Connect(function(input, gpe)
         if not gpe and _G.ClickTP and input.UserInputType == Enum.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local pos = Mouse.Hit.Position
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            end
         end
      end)
   end,
})

Rayfield:LoadConfiguration()
