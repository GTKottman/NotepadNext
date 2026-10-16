-- Binbows Gothic theme for Notepad Next (loaded by our patched build at startup).
-- Colours come from ~/.config/halloween/gothic-witchy/palette.json.
-- Every language style is remapped by hue, so all languages pick up the theme.

local C = {
    bg        = 0x0e0b14, -- page
    gutter    = 0x0a0810, -- line number margin
    line      = 0x1f1829, -- current line
    select    = 0x5b2a86, -- selection
    text      = 0xe6dcc6, -- normal text
    muted     = 0xb3a9bd,
    comment   = 0x8a7f9c,
    dim       = 0x6e6180, -- line numbers
    guide     = 0x3a2e4a, -- indent guides, whitespace
    caret     = 0xb48cff,
    keyword   = 0xb48cff, -- blue in Notepad++
    operator  = 0xc9b3e8, -- navy
    type      = 0xa89dff, -- purple
    string    = 0x9be55a, -- grey strings -> witchy green
    number    = 0xf0b45a, -- orange
    red       = 0xe8687a,
    teal      = 0x95e6c2,
    pink      = 0xf1b7c3,
}

-- Scintilla wants BGR; rgb() from init.lua converts 0xRRGGBB
local function bgr(x) return rgb(x) end

local function remap(bgrColour)
    local r = bgrColour & 0xFF
    local g = (bgrColour >> 8) & 0xFF
    local b = (bgrColour >> 16) & 0xFF
    local mx, mn = math.max(r, g, b), math.min(r, g, b)
    local light = (mx + mn) / 510
    local sat = mx - mn

    if sat < 40 then
        if light < 0.25 then return C.text end   -- black text
        if light < 0.7 then return C.string end  -- grey (strings in Notepad++ styles)
        return C.muted
    end

    local h
    if mx == r then h = ((g - b) / sat) % 6
    elseif mx == g then h = (b - r) / sat + 2
    else h = (r - g) / sat + 4 end
    h = h * 60

    if h < 20 or h >= 340 then return C.red end
    if h < 70 then return C.number end
    if h < 170 then return C.comment end         -- green comments
    if h < 200 then return C.teal end
    if h < 250 then
        if light < 0.3 then return C.operator end
        return C.keyword
    end
    if h < 290 then return C.type end
    return C.pink
end

local baseSetStyle = SetStyle
function SetStyle(L)
    baseSetStyle(L)
    if L.styles then
        for _, style in pairs(L.styles) do
            editor.StyleFore[style.id] = bgr(remap(style.fgColor))
            editor.StyleBack[style.id] = bgr(C.bg)
        end
    end
end

local function applyEditorColours()
    editor.StyleFore[32] = bgr(C.text)      -- STYLE_DEFAULT
    editor.StyleBack[32] = bgr(C.bg)
    editor.StyleFore[33] = bgr(C.dim)       -- STYLE_LINENUMBER
    editor.StyleBack[33] = bgr(C.gutter)
    editor.StyleFore[34] = bgr(C.string)    -- STYLE_BRACELIGHT
    editor.StyleBack[34] = bgr(C.line)
    editor.StyleBold[34] = true
    editor.StyleFore[35] = bgr(C.red)       -- STYLE_BRACEBAD
    editor.StyleBack[35] = bgr(C.bg)
    editor.StyleFore[36] = bgr(C.muted)     -- STYLE_CONTROLCHAR
    editor.StyleBack[36] = bgr(C.bg)
    editor.StyleFore[37] = bgr(C.guide)     -- STYLE_INDENTGUIDE
    editor.StyleBack[37] = bgr(C.bg)
    editor.StyleFore[38] = bgr(C.text)      -- STYLE_CALLTIP
    editor.StyleBack[38] = bgr(C.line)

    editor.CaretFore = bgr(C.caret)
    editor.CaretLineBack = bgr(C.line)
    editor:SetSelBack(true, bgr(C.select))
    editor:SetSelFore(true, bgr(C.text))
    editor:SetWhitespaceFore(true, bgr(C.guide))
    editor.EdgeColour = bgr(C.guide)
    editor:SetFoldMarginColour(true, bgr(C.gutter))
    editor:SetFoldMarginHiColour(true, bgr(C.gutter))

    -- fold markers (SC_MARKNUM_FOLDEREND..FOLDEROPEN = 25..31)
    for m = 25, 31 do
        editor.MarkerFore[m] = bgr(C.gutter)
        editor.MarkerBack[m] = bgr(C.dim)
    end
end

local baseSetLanguage = SetLanguage
function SetLanguage(languageName)
    baseSetLanguage(languageName)
    applyEditorColours()
end
