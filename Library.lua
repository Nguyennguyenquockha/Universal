local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

--[[ Cấu hình giao diện chung ]]
local Theme = {
	Main = Color3.fromRGB(30, 30, 35),
	Header = Color3.fromRGB(25, 25, 30),
	Accent = Color3.fromRGB(0, 170, 255), -- Màu chủ đạo (Xanh dương)
	Text = Color3.fromRGB(240, 240, 240),
	TextDark = Color3.fromRGB(150, 150, 150),
	Element = Color3.fromRGB(40, 40, 45)
}

--[[ Hàm hỗ trợ (Utilities) ]]
local function MakeDraggable(topbar, main)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

--[[ Main Library Logic ]]
function Library:Window(titleText)
	local UI = {}
	
	-- Tạo ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MyModernUI"
	ScreenGui.ResetOnSpawn = false
	
	-- Kiểm tra môi trường (Exploit hay Roblox Studio)
	if gethui then
		ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = CoreGui
	else
		ScreenGui.Parent = Player:WaitForChild("PlayerGui")
	end

	-- Khung chính
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = Theme.Main
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
	MainFrame.Size = UDim2.new(0, 500, 0, 350)
	MainFrame.Parent = ScreenGui
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = MainFrame

	-- Thanh tiêu đề (Header)
	local Header = Instance.new("Frame")
	Header.BackgroundColor3 = Theme.Header
	Header.Size = UDim2.new(1, 0, 0, 40)
	Header.Parent = MainFrame
	
	local HeaderCorner = Instance.new("UICorner")
	HeaderCorner.CornerRadius = UDim.new(0, 8)
	HeaderCorner.Parent = Header
	
	-- Fix góc dưới của Header để không bị tròn
	local FixHeader = Instance.new("Frame")
	FixHeader.BackgroundColor3 = Theme.Header
	FixHeader.BorderSizePixel = 0
	FixHeader.Position = UDim2.new(0, 0, 1, -5)
	FixHeader.Size = UDim2.new(1, 0, 0, 5)
	FixHeader.Parent = Header

	local Title = Instance.new("TextLabel")
	Title.Text = titleText or "UI Library"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextColor3 = Theme.Text
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(0, 200, 1, 0)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Header

	-- Nút Close và Minimize
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Theme.Text
	CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	CloseBtn.Position = UDim2.new(1, -35, 0, 8)
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.Parent = Header
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
	
	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "-"
	MinBtn.TextColor3 = Theme.Text
	MinBtn.BackgroundColor3 = Theme.Element
	MinBtn.Position = UDim2.new(1, -65, 0, 8)
	MinBtn.Size = UDim2.new(0, 24, 0, 24)
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.Parent = Header
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

	local Minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		if Minimized then
			MainFrame:TweenSize(UDim2.new(0, 500, 0, 40), "Out", "Quad", 0.3, true)
			-- Ẩn các phần tử bên dưới
			for _, v in pairs(MainFrame:GetChildren()) do
				if v.Name == "Container" then v.Visible = false end
			end
		else
			MainFrame:TweenSize(UDim2.new(0, 500, 0, 350), "Out", "Quad", 0.3, true)
			task.wait(0.2)
			for _, v in pairs(MainFrame:GetChildren()) do
				if v.Name == "Container" then v.Visible = true end
			end
		end
	end)

	MakeDraggable(Header, MainFrame)

	-- Container chứa Tab và Elements
	local Container = Instance.new("ScrollingFrame")
	Container.Name = "Container"
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.new(0, 10, 0, 50)
	Container.Size = UDim2.new(1, -20, 1, -60)
	Container.ScrollBarThickness = 2
	Container.Parent = MainFrame
	
	local UIList = Instance.new("UIListLayout")
	UIList.Padding = UDim.new(0, 8)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Parent = Container

	-- Tự động resize canvas
	UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
	end)

	--[[ Các Component ]]
	
	-- 1. Notification System
	function UI:Notification(title, text, duration)
		local NoteFrame = Instance.new("Frame")
		NoteFrame.Size = UDim2.new(0, 250, 0, 70)
		NoteFrame.Position = UDim2.new(1, 20, 1, -90) -- Bắt đầu ở ngoài màn hình
		NoteFrame.BackgroundColor3 = Theme.Header
		NoteFrame.Parent = ScreenGui
		Instance.new("UICorner", NoteFrame)
		
		local NoteTitle = Instance.new("TextLabel")
		NoteTitle.Text = title
		NoteTitle.Font = Enum.Font.GothamBold
		NoteTitle.TextColor3 = Theme.Accent
		NoteTitle.BackgroundTransparency = 1
		NoteTitle.Size = UDim2.new(1, -10, 0, 25)
		NoteTitle.Position = UDim2.new(0, 10, 0, 5)
		NoteTitle.TextXAlignment = Enum.TextXAlignment.Left
		NoteTitle.Parent = NoteFrame

		local NoteText = Instance.new("TextLabel")
		NoteText.Text = text
		NoteText.Font = Enum.Font.Gotham
		NoteText.TextColor3 = Theme.Text
		NoteText.BackgroundTransparency = 1
		NoteText.Size = UDim2.new(1, -10, 0, 35)
		NoteText.Position = UDim2.new(0, 10, 0, 30)
		NoteText.TextXAlignment = Enum.TextXAlignment.Left
		NoteText.TextWrapped = true
		NoteText.Parent = NoteFrame

		-- Animation vào
		NoteFrame:TweenPosition(UDim2.new(1, -270, 1, -90), "Out", "Back", 0.5)
		
		task.delay(duration or 3, function()
			NoteFrame:TweenPosition(UDim2.new(1, 20, 1, -90), "In", "Quad", 0.5)
			task.wait(0.6)
			NoteFrame:Destroy()
		end)
	end

	-- 2. Button
	function UI:Button(text, callback)
		local BtnFrame = Instance.new("Frame")
		BtnFrame.BackgroundColor3 = Theme.Element
		BtnFrame.Size = UDim2.new(1, 0, 0, 35)
		BtnFrame.Parent = Container
		Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)

		local Btn = Instance.new("TextButton")
		Btn.Text = text
		Btn.Font = Enum.Font.GothamSemibold
		Btn.TextColor3 = Theme.Text
		Btn.Size = UDim2.new(1, 0, 1, 0)
		Btn.BackgroundTransparency = 1
		Btn.Parent = BtnFrame

		Btn.MouseButton1Click:Connect(function()
			-- Hiệu ứng click
			TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
			task.wait(0.1)
			TweenService:Create(BtnFrame, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Element}):Play()
			pcall(callback)
		end)
	end

	-- 3. Toggle (Switch Style)
	function UI:Toggle(text, default, callback)
		local Toggled = default or false
		
		local ToggleFrame = Instance.new("Frame")
		ToggleFrame.BackgroundColor3 = Theme.Element
		ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
		ToggleFrame.Parent = Container
		Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

		local Label = Instance.new("TextLabel")
		Label.Text = text
		Label.Font = Enum.Font.GothamSemibold
		Label.TextColor3 = Theme.Text
		Label.Size = UDim2.new(0.7, 0, 1, 0)
		Label.Position = UDim2.new(0, 10, 0, 0)
		Label.BackgroundTransparency = 1
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = ToggleFrame

		-- Switch Background (Cục bầu dục)
		local SwitchBg = Instance.new("Frame")
		SwitchBg.Size = UDim2.new(0, 40, 0, 20)
		SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
		SwitchBg.BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(60, 60, 65)
		SwitchBg.Parent = ToggleFrame
		local SwitchCorner = Instance.new("UICorner", SwitchBg)
		SwitchCorner.CornerRadius = UDim.new(1, 0)

		-- Switch Circle (Cục tròn bên trong)
		local SwitchCircle = Instance.new("Frame")
		SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
		SwitchCircle.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SwitchCircle.Parent = SwitchBg
		Instance.new("UICorner", SwitchCircle).CornerRadius = UDim.new(1, 0)

		local TriggerBtn = Instance.new("TextButton")
		TriggerBtn.Text = ""
		TriggerBtn.BackgroundTransparency = 1
		TriggerBtn.Size = UDim2.new(1, 0, 1, 0)
		TriggerBtn.Parent = ToggleFrame

		TriggerBtn.MouseButton1Click:Connect(function()
			Toggled = not Toggled
			
			-- Animations
			if Toggled then
				TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
				TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
			else
				TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
				TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
			end
			
			pcall(callback, Toggled)
		end)
	end

	-- 4. Slider
	function UI:Slider(text, min, max, default, callback)
		local Value = default or min
		
		local SliderFrame = Instance.new("Frame")
		SliderFrame.BackgroundColor3 = Theme.Element
		SliderFrame.Size = UDim2.new(1, 0, 0, 50)
		SliderFrame.Parent = Container
		Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

		local Label = Instance.new("TextLabel")
		Label.Text = text
		Label.Font = Enum.Font.GothamSemibold
		Label.TextColor3 = Theme.Text
		Label.Size = UDim2.new(1, 0, 0, 25)
		Label.Position = UDim2.new(0, 10, 0, 0)
		Label.BackgroundTransparency = 1
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = SliderFrame

		local ValueLabel = Instance.new("TextLabel")
		ValueLabel.Text = tostring(Value)
		ValueLabel.Font = Enum.Font.Gotham
		ValueLabel.TextColor3 = Theme.TextDark
		ValueLabel.Size = UDim2.new(0, 50, 0, 25)
		ValueLabel.Position = UDim2.new(1, -60, 0, 0)
		ValueLabel.BackgroundTransparency = 1
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
		ValueLabel.Parent = SliderFrame

		local SliderBar = Instance.new("Frame")
		SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
		SliderBar.Size = UDim2.new(1, -20, 0, 6)
		SliderBar.Position = UDim2.new(0, 10, 0, 35)
		SliderBar.Parent = SliderFrame
		Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

		local Fill = Instance.new("Frame")
		Fill.BackgroundColor3 = Theme.Accent
		Fill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
		Fill.Parent = SliderBar
		Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

		local TriggerBtn = Instance.new("TextButton")
		TriggerBtn.Text = ""
		TriggerBtn.BackgroundTransparency = 1
		TriggerBtn.Size = UDim2.new(1, 0, 1, 0)
		TriggerBtn.Position = UDim2.new(0, 0, -3, 0) -- Phủ lên toàn bộ vùng slider
		TriggerBtn.Parent = SliderBar

		local isDragging = false

		local function UpdateSlider(input)
			local SizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
			local NewValue = math.floor(min + ((max - min) * SizeX))
			
			TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
			ValueLabel.Text = tostring(NewValue)
			pcall(callback, NewValue)
		end

		TriggerBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				isDragging = true
				UpdateSlider(input)
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				UpdateSlider(input)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				isDragging = false
			end
		end)
	end

	-- 5. TextBox
	function UI:TextBox(text, placeholder, callback)
		local BoxFrame = Instance.new("Frame")
		BoxFrame.BackgroundColor3 = Theme.Element
		BoxFrame.Size = UDim2.new(1, 0, 0, 35)
		BoxFrame.Parent = Container
		Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)
		
		local Label = Instance.new("TextLabel")
		Label.Text = text
		Label.Font = Enum.Font.GothamSemibold
		Label.TextColor3 = Theme.Text
		Label.Size = UDim2.new(0.4, 0, 1, 0)
		Label.Position = UDim2.new(0, 10, 0, 0)
		Label.BackgroundTransparency = 1
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = BoxFrame

		local Input = Instance.new("TextBox")
		Input.Text = ""
		Input.PlaceholderText = placeholder or "Nhập..."
		Input.PlaceholderColor3 = Theme.TextDark
		Input.TextColor3 = Theme.Accent
		Input.Font = Enum.Font.Gotham
		Input.BackgroundTransparency = 1
		Input.Size = UDim2.new(0.5, -10, 1, 0)
		Input.Position = UDim2.new(0.5, 0, 0, 0)
		Input.TextXAlignment = Enum.TextXAlignment.Right
		Input.Parent = BoxFrame
		
		Input.FocusLost:Connect(function(enterPressed)
			pcall(callback, Input.Text)
		end)
	end

	-- 6. Dropdown
	function UI:Dropdown(text, options, default, callback)
		local DropFrame = Instance.new("Frame")
		DropFrame.BackgroundColor3 = Theme.Element
		DropFrame.Size = UDim2.new(1, 0, 0, 35)
		DropFrame.Parent = Container
		DropFrame.ClipsDescendants = true -- Quan trọng để tạo hiệu ứng mở rộng
		Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
		
		local Opened = false
		local Count = #options
		local DropSize = 35 + (Count * 30)

		local Label = Instance.new("TextLabel")
		Label.Text = text .. " : " .. (default or "...")
		Label.Font = Enum.Font.GothamSemibold
		Label.TextColor3 = Theme.Text
		Label.Size = UDim2.new(1, -30, 0, 35)
		Label.Position = UDim2.new(0, 10, 0, 0)
		Label.BackgroundTransparency = 1
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = DropFrame
		
		local Arrow = Instance.new("TextLabel")
		Arrow.Text = "v"
		Arrow.Font = Enum.Font.GothamBold
		Arrow.TextColor3 = Theme.TextDark
		Arrow.Size = UDim2.new(0, 30, 0, 35)
		Arrow.Position = UDim2.new(1, -30, 0, 0)
		Arrow.BackgroundTransparency = 1
		Arrow.Parent = DropFrame

		local Trigger = Instance.new("TextButton")
		Trigger.Text = ""
		Trigger.BackgroundTransparency = 1
		Trigger.Size = UDim2.new(1, 0, 0, 35)
		Trigger.Parent = DropFrame

		-- List Options
		local OptionList = Instance.new("Frame")
		OptionList.BackgroundTransparency = 1
		OptionList.Position = UDim2.new(0, 0, 0, 35)
		OptionList.Size = UDim2.new(1, 0, 0, DropSize - 35)
		OptionList.Parent = DropFrame
		
		local ListLayout = Instance.new("UIListLayout")
		ListLayout.Parent = OptionList
		ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		for _, opt in pairs(options) do
			local OptBtn = Instance.new("TextButton")
			OptBtn.Text = opt
			OptBtn.Font = Enum.Font.Gotham
			OptBtn.TextColor3 = Theme.TextDark
			OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			OptBtn.Size = UDim2.new(1, 0, 0, 30)
			OptBtn.Parent = OptionList
			
			OptBtn.MouseButton1Click:Connect(function()
				Label.Text = text .. " : " .. opt
				Opened = false
				DropFrame:TweenSize(UDim2.new(1, 0, 0, 35), "Out", "Quad", 0.3)
				Arrow.Rotation = 0
				pcall(callback, opt)
			end)
		end

		Trigger.MouseButton1Click:Connect(function()
			Opened = not Opened
			if Opened then
				DropFrame:TweenSize(UDim2.new(1, 0, 0, DropSize), "Out", "Quad", 0.3)
				Arrow.Rotation = 180
			else
				DropFrame:TweenSize(UDim2.new(1, 0, 0, 35), "Out", "Quad", 0.3)
				Arrow.Rotation = 0
			end
		end)
	end
	
	-- Config System (Đơn giản)
	-- Trả về một table các giá trị nếu bạn muốn tích hợp lưu trữ
	UI.Config = {}

	return UI
end

return Library
