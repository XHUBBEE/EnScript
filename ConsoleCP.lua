local LogService = game:GetService("LogService")
local ConsoleCP = game:GetService("CoreGui")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = ConsoleCP
screenGui.Name = "RealTimeConsoleUI"

-- สร้าง Frame หลัก
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui
frame.Active = true  -- เปิดใช้งานการลาก
frame.Draggable = true  -- ทำให้ลากได้

-- สร้าง Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Parent = frame

-- สร้างปุ่ม "X" (ปิด)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -20, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.Parent = titleBar

-- สร้างปุ่ม "-" (ย่อ)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -40, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Text = "-"
minimizeButton.Parent = titleBar

-- สร้าง TextBox สำหรับแสดง Console
local consoleBox = Instance.new("TextBox")
consoleBox.Size = UDim2.new(0.95, 0, 0.65, 0)
consoleBox.Position = UDim2.new(0.025, 0, 0.1, 0)
consoleBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
consoleBox.TextColor3 = Color3.fromRGB(255, 255, 255)
consoleBox.TextSize = 10
consoleBox.MultiLine = true
consoleBox.ClearTextOnFocus = false
consoleBox.TextWrapped = true
consoleBox.Text = ""
consoleBox.Parent = frame

-- สร้างปุ่ม "คัดลอกทั้งหมด"
local copyAllButton = Instance.new("TextButton")
copyAllButton.Size = UDim2.new(0.3, 0, 0.15, 0)
copyAllButton.Position = UDim2.new(0.025, 0, 0.8, 0)
copyAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
copyAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyAllButton.Text = "คัดลอกทั้งหมด"
copyAllButton.Parent = frame

-- สร้างปุ่ม "คัดลอกล่าสุด"
local copyLastButton = Instance.new("TextButton")
copyLastButton.Size = UDim2.new(0.3, 0, 0.15, 0)
copyLastButton.Position = UDim2.new(0.35, 0, 0.8, 0)
copyLastButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
copyLastButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyLastButton.Text = "คัดลอกล่าสุด"
copyLastButton.Parent = frame

-- สร้างปุ่ม "เคลียร์"
local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.3, 0, 0.15, 0)
clearButton.Position = UDim2.new(0.675, 0, 0.8, 0)
clearButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.Text = "เคลียร์"
clearButton.Parent = frame

-- ตัวแปรเก็บข้อความทั้งหมดและข้อความล่าสุด
local consoleText = ""
local latestMessage = ""

-- ฟังก์ชันสำหรับแสดง Notification
local function showNotification(message)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0.95, 0, 0, 20)
    notification.Position = UDim2.new(0.025, 0, 0, 25)  -- ใต้ Title Bar
    notification.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Text = message
    notification.TextSize = 14
    notification.Parent = frame

    -- ลบ Notification หลังจาก 2 วินาที
    spawn(function()
        wait(2)
        notification:Destroy()
    end)
end

-- ฟังก์ชันสำหรับอัพเดท Console
local function updateConsole(text)
    consoleText = consoleText .. text .. "\n"
    consoleBox.Text = consoleText
    consoleBox.CursorPosition = -1  -- เลื่อนไปด้านล่าง
end

-- ฟังก์ชันสำหรับเคลียร์ Console
local function clearConsole()
    consoleText = ""
    latestMessage = ""
    consoleBox.Text = ""
end

-- ดึงข้อมูลจาก LogService แบบเรียลไทม์
LogService.MessageOut:Connect(function(message, messageType)
    local prefix = ""
    if messageType == Enum.MessageType.MessageOutput then
        prefix = "[Output] "
    elseif messageType == Enum.MessageType.MessageInfo then
        prefix = "[Info] "
    elseif messageType == Enum.MessageType.MessageWarning then
        prefix = "[Warning] "
    elseif messageType == Enum.MessageType.MessageError then
        prefix = "[Error] "
    end
    local fullMessage = prefix .. message
    latestMessage = fullMessage  -- เก็บข้อความล่าสุด
    updateConsole(fullMessage)
end)

-- การจัดการปุ่ม "คัดลอกทั้งหมด"
copyAllButton.MouseButton1Click:Connect(function()
    setclipboard(consoleBox.Text)
    showNotification("คัดลอกทั้งหมดสำเร็จแล้ว")
end)

-- การจัดการปุ่ม "คัดลอกล่าสุด"
copyLastButton.MouseButton1Click:Connect(function()
    setclipboard(latestMessage)
    showNotification("คัดลอกล่าสุดสำเร็จแล้ว")
end)

-- การจัดการปุ่ม "เคลียร์"
clearButton.MouseButton1Click:Connect(function()
    clearConsole()
end)

-- การจัดการปุ่ม "ปิด"
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- การจัดการปุ่ม "ย่อ"
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        frame.Size = UDim2.new(0, 400, 0, 300)
        consoleBox.Visible = true
        copyAllButton.Visible = true
        copyLastButton.Visible = true
        clearButton.Visible = true
        minimizeButton.Text = "-"
        isMinimized = false
    else
        frame.Size = UDim2.new(0, 400, 0, 20)
        consoleBox.Visible = false
        copyAllButton.Visible = false
        copyLastButton.Visible = false
        clearButton.Visible = false
        minimizeButton.Text = "+"
        isMinimized = true
    end
end)