local P = game:GetService("Players")
local LP = P.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local RE = RS:WaitForChild("RE")

-- Variáveis de Controle
local AntiSitConn
local AntiMatarConn
local SusTargetPos = nil
_G.AutoDetectSus = false

task.spawn(function()
    repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    pcall(function()
        RE["1RPNam1eTex1t"]:FireServer(table.unpack({[1] = "RolePlayName", [2] = "🔥Fogo Hub user🔥"}))
        RE["1RPNam1eColo1r"]:FireServer(table.unpack({[1] = "PickingRPNameColor", [2] = Color3.new(1, 0.5, 0)}))
        RE["1RPNam1eColo1r"]:FireServer(table.unpack({[1] = "PickingRPBioColor", [2] = Color3.new(1, 0.5, 0)}))
    end)
end)

local function FalarNoChat(mensagem)
    local tcs = game:GetService("TextChatService")
    if tcs.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = tcs:FindFirstChild("TextChannels") and tcs.TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:SendAsync(mensagem) end
    else
        local sayRemote = RS:FindFirstChild("SayMessageRequest", true)
        if sayRemote then sayRemote:FireServer(mensagem, "All") end
    end
end

-- Loading Screen
local LoadingGui = Instance.new("ScreenGui", CG)
LoadingGui.Name = "FogoLoading"
LoadingGui.IgnoreGuiInset = true 
LoadingGui.DisplayOrder = 999999 

local BG = Instance.new("Frame", LoadingGui)
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BG.ZIndex = 999999

local Title = Instance.new("TextLabel", BG)
Title.Text = "🔥 Fogo Hub 🔥"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Position = UDim2.new(0, 0, 0.4, 0)
Title.TextColor3 = Color3.fromRGB(255, 100, 0)
Title.TextScaled = true
Title.Font = Enum.Font.FredokaOne
Title.BackgroundTransparency = 1
Title.ZIndex = 1000000

local Fill = Instance.new("Frame", BG)
Fill.Size = UDim2.new(0, 0, 0.03, 0)
Fill.Position = UDim2.new(0.25, 0, 0.55, 0)
Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Fill.ZIndex = 1000000

task.spawn(function()
    TS:Create(Fill, TweenInfo.new(5.5), {Size = UDim2.new(0.5, 0, 0.03, 0)}):Play()
    task.wait(6)
    LoadingGui:Destroy()
end)

getgenv().Target = ""
local selecionadoParaTP = ""
local DropdownTP
_G.NomeColoridoAtivo = false
_G.GlitchAtivo = false
_G.AutoUnban = false
_G.VelocidadeCor = 0.002

task.spawn(function()
    local hue = 0
    while task.wait() do
        if _G.NomeColoridoAtivo then
            hue = hue + _G.VelocidadeCor
            if hue > 1 then hue = 0 end
            pcall(function()
                RE["1RPNam1eColo1r"]:FireServer("PickingRPNameColor", Color3.fromHSV(hue, 1, 1))
            end)
        elseif _G.GlitchAtivo then
            pcall(function()
                RE["1RPNam1eColo1r"]:FireServer("PickingRPNameColor", Color3.new(math.random(), math.random(), math.random()))
            end)
            RunService.RenderStepped:Wait()
        end
    end
end)

local function FogoKill()
    local targetPlayer = P:FindFirstChild(getgenv().Target)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local char = LP.Character
    local root = char.HumanoidRootPart
    local oldPos = root.CFrame
    workspace.FallenPartsDestroyHeight = -math.huge
    
    RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
    task.wait(0.2)
    
    RE["1Too1l"]:InvokeServer("PickingTools", "Couch")
    local tool = LP.Backpack:WaitForChild("Couch", 5)
    
    if tool then
        tool.Parent = char
        local seat = tool:FindFirstChild("Seat1")
        if seat then seat.Disabled = true end
        
        local start = tick()
        while tick() - start < 4 do
            local tRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local tHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not tRoot or not tHum or tHum.Sit then break end
            
            -- Rotação para garantir o assento
            local rot = CFrame.Angles(math.rad(math.random(0,360)), math.rad(math.random(0,360)), math.rad(math.random(0,360)))
            root.CFrame = tRoot.CFrame * rot * CFrame.new(0, 0, 0.7)
            task.wait()
        end
        
        if targetPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
            -- Teleporte para o Void (-835)
            root.CFrame = CFrame.new(145.51, -835.00, 21.58)
            task.wait(0.2) -- Tempo para o servidor registrar a queda
            tool.Parent = workspace
            task.wait(0.1)
            root.CFrame = oldPos
            RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
        else
            -- Se não sentou, volta por segurança
            root.CFrame = oldPos
            RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
        end
    end
end

-- RAYFIELD INTERFACE
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Fogo Hub | Brookhaven RP",
    LoadingTitle = "Fogo Hub V4.3",
    LoadingSubtitle = "by KiBenBlox & Eduardo",
})

local TabNome = Window:CreateTab("Nome", 4483362458)
TabNome:CreateSlider({
    Name = "Velocidade", Range = {0.001, 0.02}, Increment = 0.0005, CurrentValue = 0.002, 
    Callback = function(v) _G.VelocidadeCor = v end
})
TabNome:CreateToggle({
    Name = "Ativar Nome Colorido", CurrentValue = false, 
    Callback = function(v) _G.NomeColoridoAtivo = v end
})
TabNome:CreateToggle({
    Name = "Glitch no nome (EPILEPSIA)", CurrentValue = false, 
    Callback = function(v) _G.GlitchAtivo = v end
})

local TabTroll = Window:CreateTab("Troll", 6862780932)
local DropTroll = TabTroll:CreateDropdown({
    Name = "Selecionar Player", Options = {}, 
    Callback = function(o) getgenv().Target = o[1] end
})
TabTroll:CreateButton({
    Name = "Atualizar Lista", 
    Callback = function()
        local p = {}
        for _, v in pairs(P:GetPlayers()) do if v ~= LP then table.insert(p, v.Name) end end
        DropTroll:Refresh(p, true)
    end
})
TabTroll:CreateButton({
    Name = "Matar Player", 
    Callback = function() if getgenv().Target ~= "" then FogoKill() end end
})

-- ABA VIGILANTE (NOVA)
local TabVig = Window:CreateTab("Casais Sus", 10734950037)
TabVig:CreateToggle({
    Name = "Auto-detectar coisas 18+",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoDetectSus = Value
        task.spawn(function()
            while _G.AutoDetectSus do
                pcall(function()
                    local lots = workspace:FindFirstChild("001_Lots")
                    if lots then
                        for _, lot in pairs(lots:GetChildren()) do
                            for _, obj in pairs(lot:GetDescendants()) do
                                if obj:IsA("Model") and string.find(string.lower(obj.Name), "bed") then
                                    local playersNear = {}
                                    for _, p in pairs(P:GetPlayers()) do
                                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                            local dist = (p.Character.HumanoidRootPart.Position - obj:GetModelCFrame().Position).Magnitude
                                            if dist < 5 then
                                                table.insert(playersNear, p)
                                            end
                                        end
                                    end
                                    
                                    if #playersNear >= 2 then
                                        local hasMale = false
                                        local hasFemale = false
                                        for _, pNear in pairs(playersNear) do
                                            local hum = pNear.Character:FindFirstChildOfClass("Humanoid")
                                            local desc = hum and hum:FindFirstChildOfClass("HumanoidDescription")
                                            if desc then
                                                if desc.Height >= 1 then hasMale = true end
                                                if desc.Height < 1 or desc.Width < 1 then hasFemale = true end
                                            end
                                        end
                                        
                                        if hasMale and hasFemale then
                                            SusTargetPos = obj:GetModelCFrame()
                                            Rayfield:Notify({
                                                Title = "Fogo Hub",
                                                Content = "Possível coisas 18+ detectadas! Clique em Teleportar para conferir.",
                                                Duration = 8,
                                                Image = 10734950037,
                                            })
                                            task.wait(10) -- Cooldown da notificação
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
})

TabVig:CreateButton({
    Name = "Teleportar para o caso",
    Callback = function()
        if SusTargetPos then
            LP.Character.HumanoidRootPart.CFrame = SusTargetPos * CFrame.new(0, 3, 5)
        else
            Rayfield:Notify({
                Title = "Fogo Hub",
                Content = "Nenhum caso recente detectado.",
                Duration = 3,
            })
        end
    end
})

local TabCasa = Window:CreateTab("Casa", 170940873)
TabCasa:CreateToggle({
    Name = "Auto Desbanir", CurrentValue = false, 
    Callback = function(v)
        _G.AutoUnban = v
        task.spawn(function()
            while _G.AutoUnban do
                pcall(function()
                    local lots = workspace:FindFirstChild("001_Lots")
                    if lots then
                        for _, obj in pairs(lots:GetDescendants()) do
                            if obj.Name:find("BannedBlock") or obj.Name:find("PropBlocker") then obj:Destroy() end
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    end
})

local TabMan = Window:CreateTab("Mandrakes", 4483362458)
local mandrakeTerms = {"juliet", "mizuno", "oakley", "mandrak", "kenner", "edgar", "r1200", "lacoste", "shox", "kiss", "abs", "tanquinho", "faded", "pochete", "reflexivo", "cria", "nike", "adidas", "oakly", "corrente", "grillz", "fingerless", "gloves", "balaclava", "tatto", "tatuagem", "time", "braço", "team"}
TabMan:CreateButton({
    Name = "Detectar Mandrakes",
    Callback = function()
        local nomesParaLista = {}
        local totalFound = 0
        for _, player in pairs(P:GetPlayers()) do
            if player ~= LP and player.Character then
                local isMandrake = false
                pcall(function()
                    for _, obj in pairs(player.Character:GetDescendants()) do
                        if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") then
                            local nLower = string.lower(obj.Name)
                            for _, term in pairs(mandrakeTerms) do
                                if string.find(nLower, term) then isMandrake = true break end
                            end
                        end
                        if isMandrake then break end
                    end
                end)
                if isMandrake then
                    totalFound = totalFound + 1
                    table.insert(nomesParaLista, player.Name)
                    local hl = player.Character:FindFirstChild("MHighlight") or Instance.new("Highlight", player.Character)
                    hl.Name = "MHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
        if totalFound > 0 then
            DropdownTP:Refresh(nomesParaLista, true)
            FalarNoChat("⚠️ " .. totalFound .. " MANDRAKES DETECTADOS ⚠️")
        else
            DropdownTP:Refresh({"Nenhum"}, true)
            Rayfield:Notify({Title = "Fogo Hub", Content = "Nenhum mandrake encontrado", Duration = 5, Image = 4483362458})
        end
    end
})

TabMan:CreateButton({
    Name = "Limpar Marcadores", 
    Callback = function()
        for _, p in pairs(P:GetPlayers()) do 
            if p.Character and p.Character:FindFirstChild("MHighlight") then p.Character.MHighlight:Destroy() end 
        end
    end
})

TabMan:CreateButton({
    Name = "Teleportar para Selecionado", 
    Callback = function()
        local t = P:FindFirstChild(selecionadoParaTP)
        if t and t.Character then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end
    end
})

DropdownTP = TabMan:CreateDropdown({
    Name = "Selecionar Mandrake", Options = {"Nenhum"}, 
    Callback = function(o) selecionadoParaTP = o[1] end
})

-- ABA DE PROTEÇÃO
local TabProt = Window:CreateTab("Proteção", 4483362458)
TabProt:CreateToggle({
    Name = "Anti-Sit",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            AntiSitConn = RunService.Heartbeat:Connect(function()
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    if hum.Sit then hum.Sit = false hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
                end
            end)
        else
            if AntiSitConn then AntiSitConn:Disconnect() AntiSitConn = nil end
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end
        end
    end
})

TabProt:CreateToggle({
    Name = "Anti-Matar",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            AntiMatarConn = RunService.Stepped:Connect(function()
                pcall(function() LP.Character.HumanoidRootPart.CanTouch = false end)
            end)
        else
            if AntiMatarConn then AntiMatarConn:Disconnect() AntiMatarConn = nil end
            pcall(function() LP.Character.HumanoidRootPart.CanTouch = true end)
        end
    end
})

-- Adicione isso na TabProt
TabProt:CreateToggle({
    Name = "Anti-Void",
    CurrentValue = false,
    Callback = function(Value)
        _G.AntiVoid = Value
        task.spawn(function()
            while _G.AntiVoid do
                pcall(function()
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        -- Se você cair abaixo de -50 (fora do mapa)
                        if LP.Character.HumanoidRootPart.Position.Y < -50 then
                            -- Te joga de volta pra uma altura segura no centro do mapa
                            LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0) 
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

local list = {}
for _, v in pairs(P:GetPlayers()) do if v ~= LP then table.insert(list, v.Name) end end
DropTroll:Refresh(list, false)
