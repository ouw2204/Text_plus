---
sidebar_position: 2
---

# Quick Start

Get started with Text+ in just a few steps.

## Setup

1. Install Text+ via Wally, GitHub, or the Roblox Creator Marketplace
2. Require the module in your script:

```lua
local TextPlus = require(path.to.TextPlus)
```

## Basic Usage

### Creating Text

Create a new Text+ object with content:

```lua
local text = TextPlus.new("Hello World!")
```

### Playing Text

Play the text animation inside a Frame or CanvasGroup:

```lua
-- Create a frame to hold the text
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Parent = screenGui

-- Play the text
text:Play(frame)
```

### Waiting for Completion

Wait for the animation to finish:

```lua
text:Play(frame)
text:Wait()
print("Text animation complete!")
```

## Adding Styles

Use the `[Content]<Parameters>` syntax to style specific portions of text:

```lua
-- Red colored text
local text = TextPlus.new("Hello [World]<Color=rgb(255,0,0)>!")

-- Pop animation
local text = TextPlus.new("[Welcome]<Style=Pop> to the game!")

-- Multiple properties
local text = TextPlus.new("[Important]<Color=rgb(255,255,0),Size=24,Style=Wiggle> message")
```

## Default Settings

Configure default settings for all text:

```lua
local text = TextPlus.new("Hello World!", {
    Size = 18,
    Color = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    Speed = 0.05,
    Style = "Fade"
})
```

### Available Default Settings

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| Size | number | 14 | Text size in pixels |
| Color | Color3 | White | Text color |
| Font | Enum.Font | SourceSans | Font enum |
| FontFace | Font | nil | FontFace for custom fonts |
| Transparency | number | 0 | Text transparency (0 = opaque, 1 = invisible) |
| Wrapped | boolean | true | Enable text wrapping to next line |
| Scaled | boolean | false | Scale text based on container height (auto-enabled if Scale is set) |
| Scale | number | nil | Text size as percentage of container height (0-1), auto-enables Scaled |
| XAlignment | TextXAlignment | Left | Horizontal text alignment |
| YAlignment | TextYAlignment | Top | Vertical text alignment |
| Speed | number | 1 | Multiplier for animation speed (higher = faster typewriter effect) |
| Step | number | 0.015 | Base time delay between each character reveal (seconds) |
| Chunks | number | 1 | Number of characters revealed at once per step |
| Style | string/table | nil | Animation style name or configuration table |
| StrokeColor | Color3 | Black | Color of text outline/stroke |
| StrokeTransparency | number | 1 | Stroke visibility (0 = visible, 1 = invisible) |
| StepFactor | number | 1 | Multiplier for animation progress speed within styles |
| Amplitude | number | 1 | Variable used by some animations to control effect intensity (e.g. Y offset, size change) |
| Overfill | boolean | nil | Allow text to extend beyond container bounds |
| UseCanvas | boolean | false | Use CanvasGroup instead of Frame for better visual effects |
| ContentScaled | boolean | true | Scale individual letters to fit within word bounds |
| LetterStepped | function | nil | Called with (content, char, word) when each letter appears |
| WordStepped | function | nil | Called with (content, word) when each word appears |
| OnFinished | function | nil | Called with (content) when animation completes |

## Scaled Text

The `Scale` property makes text automatically scale based on the container's height. This is useful for responsive UIs where text should resize with the parent frame.

Setting `Scale` automatically enables scaling - you don't need to set `Scaled = true` separately.

### Using the Scale Factor

The `Scale` property controls how large the text is relative to the container. Values typically range from 0 to 1:

```lua
-- Small scaled text (35% of container height)
local text = TextPlus.new("Small", {
    Scale = 0.35
})

-- Large scaled text (80% of container height)
local text = TextPlus.new("Large", {
    Scale = 0.8
})
```

When scaling is enabled, the text size is calculated based on the parent frame's height (capped at 100 pixels).

### Per-Section Scaling

You can also apply scaling to specific sections using the syntax:

```lua
local text = TextPlus.new("Normal text [BIG TEXT]<Scale=1.5> normal again", {
    Scale = 0.5
})
```

### Scaled Text Example

```lua
-- Responsive title that scales with window size
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(0.8, 0, 0.2, 0)  -- 80% width, 20% height
titleFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
titleFrame.Parent = screenGui

local title = TextPlus.new("[GAME TITLE]<Style=Pop>", {
    Scale = 0.7,
    XAlignment = Enum.TextXAlignment.Center,
    YAlignment = Enum.TextYAlignment.Center,
    Font = Enum.Font.GothamBold
})

title:Play(titleFrame)
```

## Instant Text (Print)

Display text instantly without animation:

```lua
local contentSize = text:Print(frame)
print("Content size:", contentSize)
```

## Cleanup

Always destroy Text+ objects when done:

```lua
text:Destroy()
```

## Next Steps

- Learn the full [Text Syntax](text-syntax.md)
- Explore [Animation Styles](animations.md)
- See the complete [API Reference](api-reference.md)
