---
sidebar_position: 4
---

# Animation Styles

Text+ comes with several built-in animation styles that bring your text to life.

## Built-in Styles

### Default

The standard text reveal animation. Text fades in as it appears.

```lua
"[Text]<Style=Default>"
```

### Fade

Smooth fade-in effect. Letters gradually become visible.

```lua
"[Fading text]<Style=Fade>"
```

### Pop

Letters pop in with a scale effect, starting larger and settling to normal size.

```lua
"[Pop in]<Style=Pop>"
```

### Rise

Letters rise up from below their final position.

```lua
"[Rising text]<Style=Rise>"
```

### Drop

Letters drop down from above their final position.

```lua
"[Dropping text]<Style=Drop>"
```

### Wiggle

Letters wiggle side to side continuously. Great for emphasizing text.

```lua
"[Wiggly text]<Style=Wiggle>"
```

Use `Amplitude` to control wiggle intensity:

```lua
"[Subtle wiggle]<Style=Wiggle,Amplitude=2>"
"[Strong wiggle]<Style=Wiggle,Amplitude=15>"
```

### Shrink

Letters start small and grow to their normal size.

```lua
"[Growing text]<Style=Shrink>"
```

### Rainbow

Letters cycle through rainbow colors continuously.

```lua
"[Colorful text]<Style=Rainbow>"
```

## Style Options

Configure styles with additional options:

```lua
"[Text]<Style=(StyleName,option=value)>"
```

### Available Options

| Option | Type | Description |
|--------|------|-------------|
| repeat | number | Number of times to repeat the animation |
| looped | boolean | Continuously loop the animation |
| reverse | boolean | Play animation in reverse |
| delaytime | number | Delay between animation cycles |
| stepfactor | number | Controls animation timing |
| amplitude | number | Animation intensity (for Wiggle) |

### Examples

```lua
-- Loop the pop animation
"[Text]<Style=(Pop,looped=true)>"

-- Repeat wiggle 3 times
"[Text]<Style=(Wiggle,repeat=3)>"

-- Reverse the rise animation
"[Text]<Style=(Rise,reverse=true)>"

-- Combine options
"[Text]<Style=(Pop,looped=true,delaytime=0.5)>"
```

## Multiple Styles

Apply multiple styles to the same text:

```lua
"[Text]<Style=(Fade,Pop)>"
```

## Custom Animations

Create your own animation styles using `RegisterStyle`:

```lua
TextPlus.RegisterStyle("Bounce", function(Letter, Progress, Transparency, StrokeTransparency, Color, StrokeColor, Size, Position, Amplitude, Reversing)
    -- Letter: The TextLabel being animated
    -- Progress: Animation progress (0-1)
    -- Transparency: Current transparency value
    -- StrokeTransparency: Current stroke transparency
    -- Color: Current text color
    -- StrokeColor: Current stroke color
    -- Size: Original size (UDim2)
    -- Position: Original position (UDim2)
    -- Amplitude: Amplitude setting
    -- Reversing: Whether animation is reversing

    local bounce = math.abs(math.sin(Progress * math.pi * 2)) * (Amplitude or 5)
    Letter.Position = Position + UDim2.fromOffset(0, -bounce)
    Letter.TextTransparency = Transparency
    Letter.TextStrokeTransparency = StrokeTransparency
end)

-- Use the custom style
"[Bouncing text]<Style=Bounce>"
```

### Animation Function Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| Letter | TextLabel | The label being animated |
| Progress | number | Animation progress (0 to 1) |
| Transparency | number | Target transparency |
| StrokeTransparency | number | Target stroke transparency |
| Color | Color3 | Target text color |
| StrokeColor | Color3 | Target stroke color |
| Size | UDim2 | Original/default size |
| Position | UDim2 | Original/default position |
| Amplitude | number? | Optional amplitude value |
| Reversing | boolean? | True if animation is reversing |

### Removing Custom Styles

```lua
TextPlus.UnRegisterStyle("Bounce")
```

## Combining with Other Properties

Styles work with all other text properties:

```lua
-- Red text with pop animation
"[Alert]<Color=rgb(255,0,0),Style=Pop>"

-- Large wiggling text
"[Important]<Size=32,Style=Wiggle,Amplitude=8>"

-- Fading text with stroke
"[Outlined]<Style=Fade,StrokeColor=rgb(0,0,0),StrokeTransparency=0>"
```

## Per-Section Styling

Different sections can have different styles:

```lua
"[Hello]<Style=Pop> [World]<Style=Fade,Color=rgb(0,255,0)>!"
```

## Default Style

Set a default style for all text in the constructor:

```lua
local text = TextPlus.new("All text pops!", {
    Style = "Pop"
})

-- Override default for specific sections
local text = TextPlus.new("[Default pop] but [this fades]<Style=Fade>", {
    Style = "Pop"
})
```
