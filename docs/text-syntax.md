---
sidebar_position: 3
---

# Text Syntax

Text+ uses a special syntax to apply styling and animations to specific parts of your text.

## Basic Format

```
[Content]<Parameter=Value,Parameter2=Value2>
```

- `[Content]` - The text to style (required)
- `<Parameters>` - Comma-separated styling parameters (optional)

## Examples

```lua
-- Style a single word
"Hello [World]<Color=rgb(255,0,0)>!"

-- Style multiple words
"[Hello World]<Style=Pop>"

-- Multiple styled sections
"[Red]<Color=rgb(255,0,0)> and [Blue]<Color=rgb(0,0,255)>"

-- Combine multiple parameters
"[Important]<Color=rgb(255,255,0),Size=24,Style=Wiggle>"
```

## Available Parameters

### Color

Set the text color using RGB values:

```lua
"[Text]<Color=rgb(255,0,0)>"     -- Red
"[Text]<Color=rgb(0,255,0)>"     -- Green
"[Text]<Color=rgb(0,0,255)>"     -- Blue
"[Text]<Color=rgb(255,255,0)>"   -- Yellow
```

### Size

Set the text size in pixels:

```lua
"[Small]<Size=12>"
"[Normal]<Size=14>"
"[Large]<Size=24>"
"[Huge]<Size=48>"
```

### Font

Use a Roblox font enum name:

```lua
"[Text]<Font=GothamBold>"
"[Text]<Font=SourceSansBold>"
"[Text]<Font=Cartoon>"
```

### FontFace

Use a custom FontFace with family, weight, and style:

```lua
"[Text]<FontFace=(rbxasset://fonts/families/GothamSSm.json,Bold,Normal)>"
```

### Transparency

Set text transparency (0 = opaque, 1 = invisible):

```lua
"[Faded]<Transparency=0.5>"
"[Ghost]<Transparency=0.8>"
```

### Style

Apply an animation style:

```lua
"[Text]<Style=Pop>"
"[Text]<Style=Fade>"
"[Text]<Style=Wiggle>"
```

See [Animation Styles](animations.md) for all available styles.

### StrokeColor

Set the text stroke/outline color:

```lua
"[Text]<StrokeColor=rgb(0,0,0)>"  -- Black outline
```

### StrokeTransparency

Set stroke transparency:

```lua
"[Text]<StrokeColor=rgb(0,0,0),StrokeTransparency=0.5>"
```

### Scale

Set a scale factor (used with Scaled setting):

```lua
"[Text]<Scale=1.5>"
```

### Speed

Control animation speed for this section:

```lua
"[Slow text]<Speed=0.1>"
"[Fast text]<Speed=0.02>"
```

### Step

Characters revealed per step:

```lua
"[Text]<Step=2>"  -- Reveal 2 characters at a time
```

### Chunks

Group characters into chunks:

```lua
"[Text]<Chunks=3>"
```

### Amplitude

Animation amplitude (for styles like Wiggle):

```lua
"[Text]<Style=Wiggle,Amplitude=10>"
```

### Img

Display an image (Roblox asset ID):

```lua
"[#]<Img=123456789>"
```

## ID References

Use `#` followed by an ID to insert registered content:

```lua
-- Register an ID
TextPlus.RegisterId("player", "Steve")

-- Use in text
local text = TextPlus.new("Welcome, #player!")
-- Output: "Welcome, Steve!"
```

### Dynamic IDs

Register functions for dynamic content:

```lua
TextPlus.RegisterId("health", function(self)
    return tostring(player.Health)
end)

local text = TextPlus.new("Health: #health HP")
```

## Images

Display images inline with text using the `Img` parameter and `#` placeholder:

```lua
"Check this out [#]<Img=123456789>"
```

The `#` acts as a placeholder that gets replaced with the image.

## Advanced Style Configuration

Styles can be configured with additional options:

```lua
-- Basic style
"[Text]<Style=Pop>"

-- Style with options using parentheses
"[Text]<Style=(Pop,repeat=3,looped=true)>"

-- Multiple styles
"[Text]<Style=(Fade,Pop)>"
```

### Style Options

| Option | Type | Description |
|--------|------|-------------|
| repeat | number | Number of animation repeats |
| looped | boolean | Loop the animation |
| reverse | boolean | Reverse the animation |
| delaytime | number | Delay between repeats |
| stepfactor | number | Animation step factor |
| amplitude | number | Animation amplitude |

## Combining Parameters

Combine multiple parameters with commas:

```lua
"[Styled Text]<Color=rgb(255,0,0),Size=24,Style=Pop,Speed=0.05>"
```

## Escaping

To display literal brackets, use plain text outside of styled sections:

```lua
"This is [styled]<Color=rgb(255,0,0)> and this is plain [text]"
```

Note: Text not in `[]<>` syntax is rendered with default settings.
