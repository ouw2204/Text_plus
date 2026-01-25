---
sidebar_position: 5
---

# API Reference

Complete API documentation for Text+.

## TextPlus

The main module for creating and managing animated text.

### TextPlus.new

Creates a new Text+ object.

```lua
TextPlus.new(Content: string, DefaultSettings: DefaultSettingsType?) -> PlayableType
```

**Parameters:**
- `Content` (string) - The text content with optional styling syntax
- `DefaultSettings` (DefaultSettingsType?) - Optional default settings table

**Returns:** PlayableType - A Text+ object with playback methods

**Example:**
```lua
-- Basic usage
local text = TextPlus.new("Hello World!")

-- With default settings
local text = TextPlus.new("Styled text", {
    Size = 18,
    Color = Color3.fromRGB(255, 255, 0),
    Style = "Pop"
})
```

---

### TextPlus.RegisterId

Registers a reusable ID that can be referenced in text content.

```lua
TextPlus.RegisterId(Id: string, Content: any) -> boolean?
```

**Parameters:**
- `Id` (string) - The ID name to register
- `Content` (any) - The value or function to associate with the ID

**Returns:** boolean? - Returns true on success, nil on failure

**Example:**
```lua
-- Static value
TextPlus.RegisterId("username", "Player1")

-- Dynamic function
TextPlus.RegisterId("coins", function(self)
    return tostring(player.Coins.Value)
end)

-- Use in text
local text = TextPlus.new("Hello #username! You have #coins coins.")
```

---

### TextPlus.UnRegisterId

Removes a registered ID.

```lua
TextPlus.UnRegisterId(Id: string) -> nil
```

**Parameters:**
- `Id` (string) - The ID to unregister

**Example:**
```lua
TextPlus.UnRegisterId("username")
```

---

### TextPlus.RegisterStyle

Registers a custom animation style.

```lua
TextPlus.RegisterStyle(Id: string, Function: AnimationFunction) -> nil
```

**Parameters:**
- `Id` (string) - The style name
- `Function` - Animation function with signature:

```lua
function(
    Letter: TextLabel,
    Progress: number,
    Transparency: number,
    StrokeTransparency: number,
    Color: Color3,
    StrokeColor: Color3,
    Size: UDim2,
    Position: UDim2,
    Amplitude: number?,
    Reversing: boolean?
) -> ()
```

**Example:**
```lua
TextPlus.RegisterStyle("Shake", function(Letter, Progress, Transparency, StrokeTransparency, Color, StrokeColor, Size, Position, Amplitude)
    local shake = (Amplitude or 3) * math.sin(Progress * 20)
    Letter.Position = Position + UDim2.fromOffset(shake, 0)
    Letter.TextTransparency = Transparency
end)
```

---

### TextPlus.UnRegisterStyle

Removes a custom animation style.

```lua
TextPlus.UnRegisterStyle(Id: string) -> nil
```

**Parameters:**
- `Id` (string) - The style name to remove

---

### TextPlus.Format

Formats content into Text+ syntax string.

```lua
TextPlus.Format(Content: FormatContentType) -> string
```

**Parameters:**
- `Content` (FormatContentType) - A table of formatting properties

**Returns:** string - Formatted parameter string

**Example:**
```lua
local params = TextPlus.Format({
    Color = Color3.fromRGB(255, 0, 0),
    Size = 24,
    Style = "Pop"
})
-- Returns: "Color = rgb(255,0,0),Size = 24,Style = Pop"

-- Use in dynamic text construction
local text = TextPlus.new("[Hello]<" .. params .. ">")
```

---

## PlayableType

The object returned by `TextPlus.new()`. Provides methods for controlling text playback.

### Play

Plays the text animation inside a parent frame.

```lua
PlayableType:Play(Parent: Frame | CanvasGroup) -> PlayableType
```

**Parameters:**
- `Parent` - The GUI frame to render text into

**Returns:** self - For method chaining

**Example:**
```lua
local text = TextPlus.new("Hello World!")
text:Play(myFrame)
```

---

### Wait

Yields until the animation completes.

```lua
PlayableType:Wait() -> (PlayableType, Container?)
```

**Returns:**
- self - The Text+ object
- Container - The container Frame or CanvasGroup

**Example:**
```lua
text:Play(frame)
text:Wait()
print("Animation finished!")
```

---

### Print

Instantly displays all text without animation.

```lua
PlayableType:Print(Parent: Frame | CanvasGroup) -> Vector2
```

**Parameters:**
- `Parent` - The GUI frame to render text into

**Returns:** Vector2 - The content size (width, height)

**Example:**
```lua
local size = text:Print(frame)
print("Text size:", size.X, "x", size.Y)
```

---

### Stop

Stops the current animation.

```lua
PlayableType:Stop() -> nil
```

**Example:**
```lua
text:Play(frame)
task.wait(1)
text:Stop()
```

---

### Destroy

Cleans up the Text+ object and releases resources.

```lua
PlayableType:Destroy() -> nil
```

**Example:**
```lua
text:Destroy()
```

---

### GetIdValue

Gets the value of a registered ID.

```lua
PlayableType:GetIdValue(Id: string) -> string?
```

**Parameters:**
- `Id` (string) - The ID to look up

**Returns:** string? - The ID value or nil

**Example:**
```lua
TextPlus.RegisterId("score", "100")
local value = text:GetIdValue("score") -- "100"
```

---

### GetContentSize

Calculates the size the text would occupy without playing.

```lua
PlayableType:GetContentSize(Parent: Frame | CanvasGroup) -> Vector2?
```

**Parameters:**
- `Parent` - The GUI frame to measure against

**Returns:** Vector2? - The content dimensions

**Example:**
```lua
local size = text:GetContentSize(frame)
if size then
    print("Would be:", size.X, "x", size.Y)
end
```

---

### From

Copies properties from an existing TextLabel.

```lua
PlayableType:From(TextLabel: TextLabel, Exclusions: (string | {string})?) -> PlayableType
```

**Parameters:**
- `TextLabel` - Source TextLabel to copy from
- `Exclusions` - Properties to exclude from copying

**Returns:** self - For method chaining

**Copied Properties:**
- TextSize → Size
- TextColor3 → Color
- TextTransparency → Transparency
- TextStrokeColor3 → StrokeColor
- TextStrokeTransparency → StrokeTransparency
- FontFace → FontFace
- TextXAlignment → XAlignment
- TextYAlignment → YAlignment

**Example:**
```lua
local templateLabel = script.Parent.Template
local text = TextPlus.new("Hello!")
    :From(templateLabel)
    :Play(frame)

-- With exclusions
text:From(templateLabel, "Color")
text:From(templateLabel, {"Color", "Size"})
```

---

## Types

### DefaultSettingsType

Settings table for `TextPlus.new()`.

```lua
type DefaultSettingsType = {
    Size: number?,                    -- Text size in pixels (default: 14)
    Color: Color3?,                   -- Text color (default: white)
    Wrapped: boolean?,                -- Enable text wrapping to next line (default: true)
    Font: Enum.Font?,                 -- Font enum (default: SourceSans)
    FontFace: Font?,                  -- Custom FontFace for advanced fonts
    Overfill: boolean?,               -- Allow text beyond container bounds
    Transparency: number?,            -- Text transparency 0-1 (default: 0 = opaque)
    Scaled: boolean?,                 -- Scale based on container height (auto-enabled if Scale set)
    XAlignment: Enum.TextXAlignment?, -- Horizontal alignment (default: Left)
    YAlignment: Enum.TextYAlignment?, -- Vertical alignment (default: Top)
    Step: number?,                    -- Base delay between character reveals in seconds (default: 0.015)
    Chunks: number?,                  -- Characters revealed per step (default: 1)
    Speed: number?,                   -- Typewriter speed multiplier, higher = faster (default: 1)
    Scale: number?,                   -- Text size as % of container height (auto-enables Scaled)
    Style: StyleType?,                -- Animation style name or config table
    StepFactor: number?,              -- Animation progress speed multiplier (default: 1)
    Amplitude: number?,               -- Variable for animation intensity (Y offset, size, etc) (default: 1)
    StrokeColor: Color3?,             -- Text outline color (default: black)
    UseCanvas: boolean?,              -- Use CanvasGroup for better effects (default: false)
    StrokeTransparency: number?,      -- Stroke visibility 0-1 (default: 1 = invisible)
    ContentScaled: boolean?,          -- Scale letters to fit word bounds (default: true)
    LetterStepped: ((Content, Char, Word) -> ())?, -- Called when each letter appears
    OnFinished: ((Content) -> ())?,   -- Called when animation completes
    WordStepped: ((Content, Word) -> ())?,  -- Called when each word appears
}
```

### StyleType

Animation style configuration.

```lua
type StyleType = string | {string} | {
    Style: string,
    ["repeat"]: number?,
    stepfactor: number?,
    looped: boolean?,
    reverse: boolean?,
    delaytime: number?,
    amplitude: number?
}
```

### FormatContentType

Input for `TextPlus.Format()`.

```lua
type FormatContentType = {
    Image: string?,
    Font: (Enum.Font | string)?,
    FontFace: (Font | string)?,
    Color: Color3?,
    Step: number?,
    Chunks: number?,
    Scale: number?,
    Size: number?,
    Transparency: number?,
    Style: StyleType?,
    Amplitude: number?,
    Speed: number?,
    StepFactor: number?,
    StrokeColor: Color3?,
    StrokeTransparency: number?
}
```

---

## Callbacks

### LetterStepped

Called when each letter is revealed.

```lua
local text = TextPlus.new("Hello!", {
    LetterStepped = function(content, char, word)
        print("Letter:", char, "in word:", word)
    end
})
```

### WordStepped

Called when each word is revealed.

```lua
local text = TextPlus.new("Hello World!", {
    WordStepped = function(content, word)
        print("Word:", word)
    end
})
```

### OnFinished

Called when the animation completes.

```lua
local text = TextPlus.new("Hello!", {
    OnFinished = function(content)
        print("Done!")
    end
})
```
