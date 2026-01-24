---
sidebar_position: 1
---

# Text+

A rich text rendering module for Roblox by MountainDouw.

Text+ allows you to create animated, styled text with support for custom fonts, colors, animations, and more. Perfect for dialogue systems, UI effects, and dynamic text displays.

## Features

- **Animated Text** - Built-in animation styles like Fade, Pop, Rise, Drop, Wiggle, Shrink, and Rainbow
- **Rich Styling** - Customize colors, fonts, sizes, transparency, and stroke effects
- **ID System** - Register reusable content and dynamic values
- **Custom Animations** - Create your own animation styles
- **Scaling Support** - Automatic text scaling based on container size
- **Typewriter Effect** - Character-by-character text reveal with customizable speed

## Quick Example

```lua
local TextPlus = require(path.to.TextPlus)

-- Create animated text with styling
local text = TextPlus.new("Hello [World]<Color=rgb(255,0,0),Style=Pop>!")

-- Play in a frame
text:Play(myFrame)

-- Wait for animation to complete
text:Wait()
```

## Next Steps

- [Quick Start Guide](quickstart.md) - Get up and running quickly
- [Text Syntax](text-syntax.md) - Learn the Text+ formatting syntax
- [Animation Styles](animations.md) - Explore built-in animations
- [API Reference](api-reference.md) - Complete API documentation
