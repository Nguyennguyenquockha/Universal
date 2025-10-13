-- // Kha UI Library V2
local TweenService = game:GetService("TweenService")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

function Library:CreateWindow(Title)
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "KhaUILibrary"
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 280, 0, 320)
    Main.Position = UDim2.new(0.05, 0, 0.4, 0)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Main.Parent = ScreenGui
    Main.Active = true
    Main.Draggable = true
    Main.ClipsDescendants = true
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 10)

    local TitleBar = Instance.new("TextLabel", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    TitleBar.Text = Title or "Kha UI"
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.TextSize = 18
    TitleBar.BorderSizePixel = 0
    local tbCorner = Instance.new("UICorner", TitleBar)
    tbCorner.CornerRadius = UDim.new(0, 10)

    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, 0, 0, 35)
    TabHolder.Position = UDim2.new(0, 0, 0, 35)
    TabHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabHolder.BorderSizePixel = 0
    local thCorner = Instance.new("UICorner", TabHolder)
    thCorner.CornerRadius = UDim.new(0, 8)

    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local PageHolder = Instance.new("Frame", Main)
    PageHolder.Size = UDim2.new(1, 0, 1, -70)
    PageHolder.Position = UDim2.new(0, 0, 0, 70)
    PageHolder.BackgroundTransparency = 1

    local Pages = {}

    local function SwitchTab(name)
        for n, page in pairs(Pages) do
            page.Visible = (n == name)
        end
    end

    local Window = {}

    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton", TabHolder)
        TabButton.Size = UDim2.new(0, 90, 1, 0)
        TabButton.Text = name
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        local c = Instance.new("UICorner", TabButton)
        c.CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 4
        Page.Visible = false
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 6)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        Pages[name] = Page

        TabButton.MouseButton1Click:Connect(function()
            for _, btn in pairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 85)}):Play()
            SwitchTab(name)
        end)

        if not next(Pages) then
            Page.Visible = true
        elseif #TabHolder:GetChildren() == 2 then
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 85)}):Play()
        end

        local Tab = {}

        function Tab:CreateButton(name, callback)
            local Button = Instance.new("TextButton", Page)
            Button.Size = UDim2.new(0.9, 0, 0, 30)
            Button.Text = name
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            local c = Instance.new("UICorner", Button)
            c.CornerRadius = UDim.new(0, 6)
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
                task.wait(0.15)
                TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
                pcall(callback)
            end)
        end

        function Tab:CreateToggle(name, default, callback)
            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(0.9, 0, 0, 30)
            Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            local c = Instance.new("UICorner", Frame)
            c.CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleBtn = Instance.new("TextButton", Frame)
            ToggleBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
            ToggleBtn.Position = UDim2.new(0.72, 0, 0.15, 0)
            ToggleBtn.Text = ""
            ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
            local cc = Instance.new("UICorner", ToggleBtn)
            cc.CornerRadius = UDim.new(1, 0)

            local state = default
            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)}):Play()
                pcall(callback, state)
            end)
        end

        function Tab:CreateSlider(name, min, max, default, callback)
            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(0.9, 0, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            local c = Instance.new("UICorner", Frame)
            c.CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", Frame)
            Label.Text = name .. ": " .. default
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 5, 0, 2)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Bar = Instance.new("Frame", Frame)
            Bar.Size = UDim2.new(0.9, 0, 0, 6)
            Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            local bc = Instance.new("UICorner", Bar)
            bc.CornerRadius = UDim.new(0, 4)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            local fc = Instance.new("UICorner", Fill)
            fc.CornerRadius = UDim.new(0, 4)

            local Dragging = false
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                end
            end)
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            game:GetService("RunService").RenderStepped:Connect(function()
                if Dragging then
                    local mouse = game:GetService("UserInputService"):GetMouseLocation().X
                    local abs = (mouse - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
                    abs = math.clamp(abs, 0, 1)
                    Fill.Size = UDim2.new(abs, 0, 1, 0)
                    local value = math.floor(min + (max - min) * abs)
                    Label.Text = name .. ": " .. value
                    pcall(callback, value)
                end
            end)
        end

        function Tab:CreateDropdown(name, options, callback)
            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(0.9, 0, 0, 35)
            Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            local c = Instance.new("UICorner", Frame)
            c.CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Drop = Instance.new("TextButton", Frame)
            Drop.Size = UDim2.new(0.25, 0, 0.7, 0)
            Drop.Position = UDim2.new(0.72, 0, 0.15, 0)
            Drop.Text = "▼"
            Drop.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            local cc = Instance.new("UICorner", Drop)
            cc.CornerRadius = UDim.new(1, 0)

            local ListFrame = Instance.new("Frame", Frame)
            ListFrame.Size = UDim2.new(1, 0, 0, 0)
            ListFrame.Position = UDim2.new(0, 0, 1, 0)
            ListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            ListFrame.BorderSizePixel = 0
            ListFrame.ClipsDescendants = true

            local Layout = Instance.new("UIListLayout", ListFrame)
            Layout.Padding = UDim.new(0, 3)
            Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            for _, opt in pairs(options) do
                local Btn = Instance.new("TextButton", ListFrame)
                Btn.Size = UDim2.new(0.9, 0, 0, 25)
                Btn.Text = opt
                Btn.Font = Enum.Font.Gotham
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                local b = Instance.new("UICorner", Btn)
                b.CornerRadius = UDim.new(0, 6)

                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(ListFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    pcall(callback, opt)
                end)
            end

            local opened = false
            Drop.MouseButton1Click:Connect(function()
                opened = not opened
                local targetSize = opened and UDim2.new(1, 0, 0, #options * 30) or UDim2.new(1, 0, 0, 0)
                TweenService:Create(ListFrame, TweenInfo.new(0.25), {Size = targetSize}):Play()
            end)
        end

        return Tab
    end

    return Window
end

return Libraryu
