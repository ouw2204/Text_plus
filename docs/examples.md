---
sidebar_position: 6
---

# Examples

Practical examples demonstrating Text+ features.

## Responsive Scaled UI

Create text that automatically scales with the container size:

```lua
local TextPlus = require(path.to.TextPlus)

-- Create a responsive header
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0.15, 0)  -- Full width, 15% height
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = screenGui

local header = TextPlus.new("[Welcome to My Game]<Style=Pop>", {
    Scale = 0.6,  -- 60% of container height
    XAlignment = Enum.TextXAlignment.Center,
    YAlignment = Enum.TextYAlignment.Center,
    Font = Enum.Font.GothamBold,
    Color = Color3.fromRGB(255, 255, 255)
})

header:Play(headerFrame)
```

### Multi-Size Scaled Text

Mix different scale factors in the same text:

```lua
local text = TextPlus.new(
    "[BIG]<Scale=1.0> and [small]<Scale=0.4> text together",
    {
        Scale = 0.6,  -- Default scale
        XAlignment = Enum.TextXAlignment.Center
    }
)

text:Play(frame)
```

### Responsive Game HUD

```lua
local TextPlus = require(path.to.TextPlus)

-- Health bar label that scales with HUD size
local hudFrame = Instance.new("Frame")
hudFrame.Size = UDim2.new(0.3, 0, 0.05, 0)
hudFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
hudFrame.Parent = screenGui

TextPlus.RegisterId("hp", function()
    return tostring(math.floor(player.Character.Humanoid.Health))
end)

local healthText = TextPlus.new("[HP: #hp]<Color=rgb(255,100,100)>", {
    Scale = 0.7,
    Font = Enum.Font.GothamBold,
    YAlignment = Enum.TextYAlignment.Center
})

healthText:Print(hudFrame)

-- Update periodically
while true do
    healthText:Print(hudFrame)
    task.wait(0.1)
end
```

## Dialogue System

Create a typewriter-style dialogue system:

```lua
local TextPlus = require(path.to.TextPlus)
local dialogueFrame = script.Parent.DialogueFrame

local function showDialogue(speaker, message)
    -- Clear previous text
    for _, child in dialogueFrame:GetChildren() do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local text = TextPlus.new(
        "[" .. speaker .. "]<Color=rgb(255,255,0),Style=Pop>: " .. message,
        {
            Size = 16,
            Font = Enum.Font.Gotham,
            Speed = 0.03
        }
    )

    text:Play(dialogueFrame)
    text:Wait()

    return text
end

-- Usage
local dialogue = showDialogue("NPC", "Welcome to the [shop]<Color=rgb(0,255,0)>!")
task.wait(2)
dialogue:Destroy()
```

## Dynamic Player Stats

Display player stats with dynamic IDs:

```lua
local TextPlus = require(path.to.TextPlus)
local player = game.Players.LocalPlayer
local statsFrame = script.Parent.StatsFrame

-- Register dynamic IDs
TextPlus.RegisterId("health", function()
    return tostring(math.floor(player.Character.Humanoid.Health))
end)

TextPlus.RegisterId("maxHealth", function()
    return tostring(player.Character.Humanoid.MaxHealth)
end)

TextPlus.RegisterId("coins", function()
    return tostring(player.leaderstats.Coins.Value)
end)

-- Create stats display
local statsText = TextPlus.new(
    "[Health]<Color=rgb(255,0,0)>: #health/#maxHealth | [Coins]<Color=rgb(255,215,0)>: #coins",
    {
        Size = 14,
        Font = Enum.Font.GothamBold
    }
)

statsText:Print(statsFrame)
```

## Notification System

Animated notifications with different severity levels:

```lua
local TextPlus = require(path.to.TextPlus)

local function notify(message, level)
    local colors = {
        info = "rgb(100,150,255)",
        success = "rgb(100,255,100)",
        warning = "rgb(255,200,100)",
        error = "rgb(255,100,100)"
    }

    local styles = {
        info = "Fade",
        success = "Pop",
        warning = "Wiggle",
        error = "Pop"
    }

    local color = colors[level] or colors.info
    local style = styles[level] or styles.info

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0.3, 0, 0, 40)
    notifFrame.Position = UDim2.new(0.35, 0, 0, 10)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notifFrame.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui

    local text = TextPlus.new(
        "[" .. message .. "]<Color=" .. color .. ",Style=" .. style .. ">",
        {
            Size = 14,
            XAlignment = Enum.TextXAlignment.Center,
            YAlignment = Enum.TextYAlignment.Center
        }
    )

    text:Play(notifFrame)
    text:Wait()

    task.wait(2)
    notifFrame:Destroy()
    text:Destroy()
end

-- Usage
notify("Settings saved!", "success")
notify("Low health!", "warning")
notify("Connection lost", "error")
```

## Title Screen

Animated title with multiple effects:

```lua
local TextPlus = require(path.to.TextPlus)
local titleFrame = script.Parent.TitleFrame

local titleText = TextPlus.new(
    "[EPIC]<Color=rgb(255,215,0),Size=48,Style=Pop> [ADVENTURE]<Color=rgb(200,200,255),Size=48,Style=Fade>",
    {
        XAlignment = Enum.TextXAlignment.Center,
        YAlignment = Enum.TextYAlignment.Center,
        Speed = 0.08
    }
)

titleText:Play(titleFrame)
titleText:Wait()

-- Subtitle
local subtitleText = TextPlus.new(
    "[Press any key to start]<Style=Wiggle,Amplitude=2>",
    {
        Size = 18,
        Color = Color3.fromRGB(180, 180, 180),
        XAlignment = Enum.TextXAlignment.Center
    }
)

subtitleText:Play(subtitleFrame)
```

## Chat Bubble

Animated chat bubbles above characters:

```lua
local TextPlus = require(path.to.TextPlus)

local function createChatBubble(character, message)
    local head = character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = head
    billboard.Parent = head

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local text = TextPlus.new(message, {
        Size = 14,
        Color = Color3.fromRGB(30, 30, 30),
        XAlignment = Enum.TextXAlignment.Center,
        YAlignment = Enum.TextYAlignment.Center,
        Speed = 0.04
    })

    text:Play(frame)
    text:Wait()

    task.wait(3)
    billboard:Destroy()
    text:Destroy()
end

-- Usage
createChatBubble(workspace.NPC, "Hello there, [traveler]<Color=rgb(100,150,255)>!")
```

## Loading Screen

Progress text with percentage:

```lua
local TextPlus = require(path.to.TextPlus)
local loadingFrame = script.Parent.LoadingFrame

TextPlus.RegisterId("progress", "0")

local loadingText = TextPlus.new(
    "[Loading]<Style=Wiggle>... #progress%",
    {
        Size = 20,
        XAlignment = Enum.TextXAlignment.Center
    }
)

-- Update progress
for i = 0, 100, 10 do
    TextPlus.RegisterId("progress", tostring(i))
    loadingText:Print(loadingFrame)
    task.wait(0.5)
end

loadingText:Destroy()
```

## Item Pickup

Floating item pickup text:

```lua
local TextPlus = require(path.to.TextPlus)

local function showItemPickup(itemName, rarity)
    local rarityColors = {
        common = "rgb(200,200,200)",
        uncommon = "rgb(100,255,100)",
        rare = "rgb(100,150,255)",
        epic = "rgb(200,100,255)",
        legendary = "rgb(255,200,100)"
    }

    local color = rarityColors[rarity] or rarityColors.common

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 30)
    frame.Position = UDim2.new(0.5, -150, 0.7, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui

    local text = TextPlus.new(
        "+ [" .. itemName .. "]<Color=" .. color .. ",Style=Rise>",
        {
            Size = 18,
            Font = Enum.Font.GothamBold,
            XAlignment = Enum.TextXAlignment.Center
        }
    )

    text:Play(frame)
    text:Wait()

    task.wait(1.5)
    frame:Destroy()
    text:Destroy()
end

-- Usage
showItemPickup("Diamond Sword", "legendary")
showItemPickup("Health Potion", "common")
```

## Countdown Timer

Animated countdown:

```lua
local TextPlus = require(path.to.TextPlus)
local timerFrame = script.Parent.TimerFrame

local function countdown(seconds)
    for i = seconds, 1, -1 do
        -- Clear previous
        for _, child in timerFrame:GetChildren() do
            if child:IsA("Frame") then child:Destroy() end
        end

        local color = i <= 3 and "rgb(255,100,100)" or "rgb(255,255,255)"
        local style = i <= 3 and "Wiggle" or "Pop"

        local text = TextPlus.new(
            "[" .. tostring(i) .. "]<Color=" .. color .. ",Size=64,Style=" .. style .. ">",
            {
                XAlignment = Enum.TextXAlignment.Center,
                YAlignment = Enum.TextYAlignment.Center
            }
        )

        text:Play(timerFrame)
        task.wait(1)
        text:Destroy()
    end

    -- GO!
    local goText = TextPlus.new(
        "[GO!]<Color=rgb(100,255,100),Size=72,Style=Pop>",
        {
            XAlignment = Enum.TextXAlignment.Center,
            YAlignment = Enum.TextYAlignment.Center
        }
    )

    goText:Play(timerFrame)
    goText:Wait()
    task.wait(1)
    goText:Destroy()
end

countdown(5)
```

## Copy Properties from Template

Use existing TextLabel as a style template:

```lua
local TextPlus = require(path.to.TextPlus)

-- Assume there's a styled TextLabel in the UI
local templateLabel = script.Parent.StyleTemplate

local text = TextPlus.new("This uses the template's style!")
text:From(templateLabel)  -- Copy all properties
text:Play(targetFrame)

-- Or exclude certain properties
local text2 = TextPlus.new("Custom color, template font")
text2:From(templateLabel, {"Color", "Size"})  -- Keep template font, but not color/size
text2:Play(targetFrame)
```

## Inline Images

Display images within text:

```lua
local TextPlus = require(path.to.TextPlus)

-- Coin icon (replace with actual asset ID)
local coinIcon = "123456789"
local heartIcon = "987654321"

local text = TextPlus.new(
    "You earned [#]<Img=" .. coinIcon .. "> 100 coins! [#]<Img=" .. heartIcon .. "> +10 HP",
    {
        Size = 16
    }
)

text:Play(frame)
```
