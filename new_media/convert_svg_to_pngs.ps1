function New-EigenverftPngIcons {
<#
.SYNOPSIS
Generates PNG icon sizes from an SVG using ImageMagick, including optional maskable variants.

.DESCRIPTION
Renders a set of regular PNG sizes and a set of Blazor-prefixed PNG sizes from a source SVG.
Optionally generates maskable PNGs (solid background, no alpha) for selected sizes.

.PARAMETER MagickPath
Full path to magick.exe (ImageMagick).

.PARAMETER InFile
Full path to the input SVG file.

.PARAMETER OutDir
Output directory where PNGs will be written.

.PARAMETER BaseFileName
Base output file name without extension and without size suffix.
Example output: {BaseFileName}_{Prefix}{Size}x{Size}.png

.PARAMETER RegularSizes
List of square icon sizes to generate without a prefix.

.PARAMETER BlazorSizes
List of square icon sizes to generate with the PrefixForBlazor.

.PARAMETER PrefixForBlazor
Filename prefix to apply for Blazor sizes (defaults to "blazor_").

.PARAMETER MaskableSizes
List of sizes (typically subset of BlazorSizes) that should additionally generate a "_maskable" output.

.PARAMETER MaskableBackground
Background color for maskable PNGs. Common choices: white, black, #ffffff, etc.

.PARAMETER OversampleFactor
Rasterization multiplier applied before downscaling (Size * OversampleFactor).
Higher values can improve downscale quality but increase render time.
#>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$MagickPath = 'C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe',

        [Parameter()]
        [string]$InFile     = 'C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_light_centered_1024_1024_no_border.svg',

        [Parameter()]
        [string]$OutDir     = 'C:\dev\github.com\eigenverft\eigenverft\new_media',

        [Parameter()]
        [string]$BaseFileName = 'eigenverft-logo-v8_light_no_border',

        [Parameter()]
        [int[]]$RegularSizes = @(16, 32, 48, 64, 128, 256),

        [Parameter()]
        [int[]]$BlazorSizes = @(72, 144, 150, 192, 310, 512),

        [Parameter()]
        [string]$PrefixForBlazor = 'blazor_',

        [Parameter()]
        [int[]]$MaskableSizes = @(192, 512),

        [Parameter()]
        [string]$MaskableBackground = 'white',

        [Parameter()]
        [ValidateRange(1, 64)]
        [int]$OversampleFactor = 16
    )

    if (-not (Test-Path -LiteralPath $MagickPath)) { throw "magick.exe not found at: $MagickPath" }
    if (-not (Test-Path -LiteralPath $InFile))     { throw "Input SVG not found at: $InFile" }
    if (-not (Test-Path -LiteralPath $OutDir))     { New-Item -ItemType Directory -Path $OutDir | Out-Null }

    function Invoke-Magick {
<#
.SYNOPSIS
Invokes ImageMagick and throws on non-zero exit code.
.PARAMETER Args
Argument list passed to magick.exe.
.PARAMETER Context
Short label used in error messages.
#>
        param(
            [Parameter(Mandatory)][string[]]$Argsx,
            [Parameter(Mandatory)][string]$Context
        )

        & $MagickPath @Argsx
        if ($LASTEXITCODE -ne 0) {
            throw "ImageMagick failed ($Context). ExitCode=$LASTEXITCODE"
        }
    }

    function Invoke-RenderPng {
<#
.SYNOPSIS
Renders a transparent PNG of a given size.
.PARAMETER Size
Square size in pixels (e.g., 32 means 32x32).
.PARAMETER Prefix
Optional filename prefix (e.g., "blazor_"). May be empty.
#>
        param(
            [Parameter(Mandatory)][int]$Size,
            [Parameter()][AllowEmptyString()][string]$Prefix = ''
        )

        $dim  = "{0}x{0}" -f $Size
        $rast = $Size * $OversampleFactor
        $outFile = Join-Path $OutDir ("{0}_{1}{2}.png" -f $BaseFileName, $Prefix, $dim)

        $argsx = @(
            '-background', 'none',
            '-define', "svg:width=$rast",
            '-define', "svg:height=$rast",
            $InFile,
            '-alpha', 'on',
            '-colorspace', 'sRGB',
            '-virtual-pixel', 'transparent',
            '-filter', 'Lanczos',
            '-resize', $dim,
            '-strip',
            ("PNG32:{0}" -f $outFile)
        )

        Invoke-Magick -Args $argsx -Context "png $outFile"
    }

    function Invoke-RenderMaskablePng {
<#
.SYNOPSIS
Renders a maskable PNG of a given size (solid background, no alpha).
.PARAMETER Size
Square size in pixels (e.g., 512 means 512x512).
.PARAMETER Prefix
Optional filename prefix (e.g., "blazor_"). May be empty.
#>
        param(
            [Parameter(Mandatory)][int]$Size,
            [Parameter()][AllowEmptyString()][string]$Prefix = ''
        )

        $dim  = "{0}x{0}" -f $Size
        $rast = $Size * $OversampleFactor
        $outFile = Join-Path $OutDir ("{0}_{1}{2}_maskable.png" -f $BaseFileName, $Prefix, $dim)

        $argsx = @(
            '-background', $MaskableBackground,
            '-define', "svg:width=$rast",
            '-define', "svg:height=$rast",
            $InFile,
            '-colorspace', 'sRGB',
            '-filter', 'Lanczos',
            '-resize', $dim,
            '-alpha', 'remove',
            '-alpha', 'off',
            '-strip',
            ("PNG32:{0}" -f $outFile)
        )

        Invoke-Magick -Args $argsx -Context "maskable $outFile"
    }

    foreach ($s in $RegularSizes) {
        Invoke-RenderPng -Size $s -Prefix ''
    }

    foreach ($s in $BlazorSizes) {
        Invoke-RenderPng -Size $s -Prefix $PrefixForBlazor

        if ($MaskableSizes -contains $s) {
            Invoke-RenderMaskablePng -Size $s -Prefix $PrefixForBlazor
        }
    }
}

function New-EigenverftFaviconIco {
<#
.SYNOPSIS
Creates a multi-size favicon.ico from an SVG using temporary PNGs.

.DESCRIPTION
Generates temporary PNGs via New-EigenverftPngIcons, combines them into an ICO, then deletes temp files.

.PARAMETER MagickPath
Full path to magick.exe (ImageMagick).

.PARAMETER InFile
Full path to the input SVG file.

.PARAMETER OutDir
Directory for the output ICO (used when OutFile is not provided).

.PARAMETER BaseFileName
Base name used to derive a default OutFile when OutFile is not provided.
Default OutFile pattern: {OutDir}\{BaseFileName}_favicon.ico

.PARAMETER OutFile
Full path to the output favicon .ico file. If omitted, it is derived from OutDir and BaseFileName.

.PARAMETER Sizes
Icon sizes to include in the ICO. Default: 16, 32, 48.

.PARAMETER OversampleFactor
Rasterization multiplier applied before downscaling (Size * OversampleFactor).
#>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$MagickPath = 'C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe',

        [Parameter(Mandatory)]
        [string]$InFile,

        [Parameter()]
        [string]$OutDir = (Split-Path -Parent $InFile),

        [Parameter(Mandatory)]
        [string]$BaseFileName,

        [Parameter()]
        [string]$OutFile,

        [Parameter()]
        [int[]]$Sizes = @(16, 32, 48),

        [Parameter()]
        [ValidateRange(1, 64)]
        [int]$OversampleFactor = 16
    )

    if (-not (Test-Path -LiteralPath $MagickPath)) { throw "magick.exe not found at: $MagickPath" }
    if (-not (Test-Path -LiteralPath $InFile))     { throw "Input SVG not found at: $InFile" }

    if ([string]::IsNullOrWhiteSpace($OutFile)) {
        if (-not (Test-Path -LiteralPath $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
        $OutFile = Join-Path $OutDir ("{0}_favicon.ico" -f $BaseFileName)
    }
    else {
        $outDirResolved = Split-Path -Parent $OutFile
        if (-not (Test-Path -LiteralPath $outDirResolved)) { New-Item -ItemType Directory -Path $outDirResolved | Out-Null }
    }

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("eigenverft-favicon-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    $tmpBase = "tmp_favicon_" + [guid]::NewGuid().ToString("N")

    try {
        New-EigenverftPngIcons `
            -MagickPath $MagickPath `
            -InFile $InFile `
            -OutDir $tempDir `
            -BaseFileName $tmpBase `
            -RegularSizes $Sizes `
            -BlazorSizes @() `
            -MaskableSizes @() `
            -OversampleFactor $OversampleFactor

        $pngFiles = $Sizes |
            Sort-Object |
            ForEach-Object { Join-Path $tempDir ("{0}_{1}x{1}.png" -f $tmpBase, $_) }

        foreach ($p in $pngFiles) {
            if (-not (Test-Path -LiteralPath $p)) { throw "Missing temp PNG: $p" }
        }

        & $MagickPath @($pngFiles + @("ICO:$OutFile"))
        if ($LASTEXITCODE -ne 0) { throw "ImageMagick failed building favicon ICO. ExitCode=$LASTEXITCODE" }
    }
    finally {
        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function New-EigenverftWindowsIco {
<#
.SYNOPSIS
Creates a Windows .ico from an SVG using temporary PNGs.

.DESCRIPTION
Generates temporary PNGs via New-EigenverftPngIcons, combines them into an ICO, then deletes temp files.

.PARAMETER MagickPath
Full path to magick.exe (ImageMagick).

.PARAMETER InFile
Full path to the input SVG file.

.PARAMETER OutDir
Directory for the output ICO (used when OutFile is not provided).

.PARAMETER BaseFileName
Base name used to derive a default OutFile when OutFile is not provided.
Default OutFile pattern: {OutDir}\{BaseFileName}_win.ico

.PARAMETER OutFile
Full path to the output Windows .ico file. If omitted, it is derived from OutDir and BaseFileName.

.PARAMETER Sizes
Icon sizes to include in the ICO.
Default: 16, 24, 32, 48, 64, 128, 256.

.PARAMETER OversampleFactor
Rasterization multiplier applied before downscaling (Size * OversampleFactor).
#>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$MagickPath = 'C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe',

        [Parameter(Mandatory)]
        [string]$InFile,

        [Parameter()]
        [string]$OutDir = (Split-Path -Parent $InFile),

        [Parameter(Mandatory)]
        [string]$BaseFileName,

        [Parameter()]
        [string]$OutFile,

        [Parameter()]
        [int[]]$Sizes = @(16, 24, 32, 48, 64, 128, 256),

        [Parameter()]
        [ValidateRange(1, 64)]
        [int]$OversampleFactor = 16
    )

    if (-not (Test-Path -LiteralPath $MagickPath)) { throw "magick.exe not found at: $MagickPath" }
    if (-not (Test-Path -LiteralPath $InFile))     { throw "Input SVG not found at: $InFile" }

    if ([string]::IsNullOrWhiteSpace($OutFile)) {
        if (-not (Test-Path -LiteralPath $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
        $OutFile = Join-Path $OutDir ("{0}_win.ico" -f $BaseFileName)
    }
    else {
        $outDirResolved = Split-Path -Parent $OutFile
        if (-not (Test-Path -LiteralPath $outDirResolved)) { New-Item -ItemType Directory -Path $outDirResolved | Out-Null }
    }

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("eigenverft-winico-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    $tmpBase = "tmp_win_" + [guid]::NewGuid().ToString("N")

    try {
        New-EigenverftPngIcons `
            -MagickPath $MagickPath `
            -InFile $InFile `
            -OutDir $tempDir `
            -BaseFileName $tmpBase `
            -RegularSizes $Sizes `
            -BlazorSizes @() `
            -MaskableSizes @() `
            -OversampleFactor $OversampleFactor

        $pngFiles = $Sizes |
            Sort-Object |
            ForEach-Object { Join-Path $tempDir ("{0}_{1}x{1}.png" -f $tmpBase, $_) }

        foreach ($p in $pngFiles) {
            if (-not (Test-Path -LiteralPath $p)) { throw "Missing temp PNG: $p" }
        }

        & $MagickPath @($pngFiles + @("ICO:$OutFile"))
        if ($LASTEXITCODE -ne 0) { throw "ImageMagick failed building Windows ICO. ExitCode=$LASTEXITCODE" }
    }
    finally {
        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function New-EigenverftAppleTouchIconPng {
<#
.SYNOPSIS
Renders a single apple-touch-icon PNG (default 180x180) from an SVG using ImageMagick.

.DESCRIPTION
Creates an iOS/iPadOS home screen icon (Web Clip). Writes a single PNG file name you choose
(e.g., apple-touch-icon.png). Optionally adds padding and forces an opaque background for
consistent rendering.

.PARAMETER MagickPath
Full path to magick.exe (ImageMagick).

.PARAMETER InFile
Full path to the input SVG file.

.PARAMETER OutFile
Full path to the output PNG file (e.g., ...\wwwroot\_assets\apple-touch-icon.png).

.PARAMETER Size
Square output size in pixels. Default is 180 (recommended for iPhone retina).

.PARAMETER Padding
Inner padding (in px) around the rendered SVG before centering on the final canvas.
Common values: 16–24. Default: 20.

.PARAMETER Background
Background color for the output icon. Use a solid color for predictable results.
(Default is white.) Note: some audits recommend non-transparent backgrounds. #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$MagickPath = 'C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe',

        [Parameter(Mandatory)]
        [string]$InFile,

        [Parameter(Mandatory)]
        [string]$OutFile,

        [Parameter()]
        [ValidateRange(64, 2048)]
        [int]$Size = 180,

        [Parameter()]
        [ValidateRange(0, 256)]
        [int]$Padding = 20,

        [Parameter()]
        [string]$Background = 'white',

        [Parameter()]
        [ValidateRange(1, 64)]
        [int]$OversampleFactor = 16
    )

    if (-not (Test-Path -LiteralPath $MagickPath)) { throw "magick.exe not found at: $MagickPath" }
    if (-not (Test-Path -LiteralPath $InFile))     { throw "Input SVG not found at: $InFile" }

    $outDir = Split-Path -Parent $OutFile
    if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

    $inner = [Math]::Max(1, $Size - (2 * $Padding))
    $innerDim = "{0}x{0}" -f $inner
    $finalDim = "{0}x{0}" -f $Size
    $rast = $Size * $OversampleFactor

    $argsx = @(
        '-background', 'none',
        '-define', "svg:width=$rast",
        '-define', "svg:height=$rast",
        $InFile,
        '-colorspace', 'sRGB',
        '-filter', 'Lanczos',
        '-resize', $innerDim,
        '-background', $Background,
        '-gravity', 'center',
        '-extent', $finalDim,
        # force opaque result for consistent iOS home screen icons
        '-alpha', 'remove',
        '-alpha', 'off',
        '-strip',
        ("PNG32:{0}" -f $OutFile)
    )

    & $MagickPath @argsx
    if ($LASTEXITCODE -ne 0) {
        throw "ImageMagick failed rendering apple-touch-icon. ExitCode=$LASTEXITCODE"
    }
}

function New-EigenverftAppleTouchIcons {
<#
.SYNOPSIS
Generates light + dark apple-touch-icon variants, plus a primary apple-touch-icon.png.

.DESCRIPTION
Creates:
- apple-touch-icon-on-light.png
- apple-touch-icon-on-dark.png
- apple-touch-icon.png (copied from the preferred variant)

.PARAMETER InFileLight
SVG tuned for light UI backgrounds.

.PARAMETER InFileDark
SVG tuned for dark UI backgrounds.

.PARAMETER OutDir
Output directory (e.g., ...\wwwroot\_assets).

.PARAMETER Prefer
Which variant should be emitted as apple-touch-icon.png. Valid: light|dark.
#>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$MagickPath = 'C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe',

        [Parameter(Mandatory)]
        [string]$InFileLight,

        [Parameter(Mandatory)]
        [string]$InFileDark,

        [Parameter(Mandatory)]
        [string]$OutDir,

        [Parameter()]
        [ValidateSet('light', 'dark')]
        [string]$Prefer = 'light',

        [Parameter()]
        [ValidateRange(64, 2048)]
        [int]$Size = 180,

        [Parameter()]
        [ValidateRange(0, 256)]
        [int]$Padding = 20,

        [Parameter()]
        [string]$LightBackground = 'white',

        [Parameter()]
        [string]$DarkBackground = 'black',

        [Parameter()]
        [ValidateRange(1, 64)]
        [int]$OversampleFactor = 16
    )

    if (-not (Test-Path -LiteralPath $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

    $outLight = Join-Path $OutDir 'apple-touch-icon-on-light.png'
    $outDark  = Join-Path $OutDir 'apple-touch-icon-on-dark.png'
    $outMain  = Join-Path $OutDir 'apple-touch-icon.png'

    New-EigenverftAppleTouchIconPng -MagickPath $MagickPath -InFile $InFileLight -OutFile $outLight -Size $Size -Padding $Padding -Background $LightBackground -OversampleFactor $OversampleFactor
    New-EigenverftAppleTouchIconPng -MagickPath $MagickPath -InFile $InFileDark  -OutFile $outDark  -Size $Size -Padding $Padding -Background $DarkBackground  -OversampleFactor $OversampleFactor

    Copy-Item -LiteralPath ($(if ($Prefer -eq 'dark') { $outDark } else { $outLight })) -Destination $outMain -Force
}

function New-EigenverftSafariPinnedTabSvg {
<#
.SYNOPSIS
Creates a Safari pinned-tab mask icon SVG (default: safari-pinned-tab.svg) from a source SVG.

.DESCRIPTION
Safari pinned tabs treat the SVG as a mask; Safari tints it using the `color` attribute
on the <link rel="mask-icon" ...> tag. For reliable behavior the SVG should be single-color
artwork (usually black), without multi-color styling.

This function enforces single-color rendering by applying inline styles to shape elements,
overriding class-based CSS like `.BlueCoat{ fill:... }`.

.PARAMETER InFile
Path to the input SVG.

.PARAMETER OutDir
Output directory. Defaults to the input SVG's directory.

.PARAMETER BaseFileName
Base output filename without extension.
Default: 'safari-pinned-tab' -> produces 'safari-pinned-tab.svg'.

.PARAMETER MaskColor
Color to enforce in the SVG content. Black (#000000) is the conventional mask color.

.PARAMETER NormalizeOpacity
If $true (default), normalizes opacity/fill-opacity/stroke-opacity to 1 on shapes.

.PARAMETER RemoveEmbeddedStyles
If $true (default), removes embedded <style> elements to avoid unexpected CSS overrides.

.PARAMETER UseImportant
If $true (default), appends '!important' to enforced fill/stroke for maximum override strength.

.OUTPUTS
System.String: Full path of the generated SVG.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$InFile,

        [Parameter()]
        [string]$OutDir = (Split-Path -Parent $InFile),

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$BaseFileName = 'safari-pinned-tab',

        [Parameter()]
        [ValidatePattern('^#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$')]
        [string]$MaskColor = '#000000',

        [Parameter()]
        [bool]$NormalizeOpacity = $true,

        [Parameter()]
        [bool]$RemoveEmbeddedStyles = $true,

        [Parameter()]
        [bool]$UseImportant = $true
    )

    if (-not (Test-Path -LiteralPath $InFile)) {
        throw "Input SVG not found: $InFile"
    }

    if (-not (Test-Path -LiteralPath $OutDir)) {
        New-Item -ItemType Directory -Path $OutDir | Out-Null
    }

    $outFile = Join-Path $OutDir ("{0}.svg" -f $BaseFileName)

    $raw = Get-Content -LiteralPath $InFile -Raw
    try {
        [xml]$doc = $raw
    }
    catch {
        throw "Failed to parse SVG as XML. Ensure it's a valid SVG. Details: $($_.Exception.Message)"
    }

    function ConvertFrom-InlineStyle {
        param([string]$Style)
        $map = @{}
        if ([string]::IsNullOrWhiteSpace($Style)) { return $map }

        foreach ($part in ($Style -split ';')) {
            $p = $part.Trim()
            if (-not $p) { continue }

            $kv = $p -split ':', 2
            if ($kv.Count -ne 2) { continue }

            $k = $kv[0].Trim()
            $v = $kv[1].Trim()
            if ($k) { $map[$k] = $v }
        }

        return $map
    }

    function ConvertTo-InlineStyle {
        param([hashtable]$Map)
        if (-not $Map -or $Map.Count -eq 0) { return '' }
        ($Map.Keys | Sort-Object | ForEach-Object { "$($_):$($Map[$_])" }) -join ';'
    }

    function Is-NonePaint {
        param([string]$Value)
        if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
        $v = $Value.Trim().ToLowerInvariant()
        return ($v -eq 'none' -or $v -eq 'transparent')
    }

    $forcedPaint = if ($UseImportant) { "$MaskColor !important" } else { $MaskColor }

    if ($RemoveEmbeddedStyles) {
        # Remove any embedded <style> elements (namespace-agnostic)
        $styleNodes = $doc.SelectNodes("//*[local-name()='style']")
        foreach ($sn in @($styleNodes)) {
            [void]$sn.ParentNode.RemoveChild($sn)
        }
    }

    # Apply inline styles to common shape elements
    $shapeXPath = "//*[local-name()='path' or local-name()='rect' or local-name()='circle' or local-name()='ellipse' or local-name()='polygon' or local-name()='polyline' or local-name()='line']"
    $shapes = $doc.SelectNodes($shapeXPath)

    foreach ($n in @($shapes)) {
        $styleMap = ConvertFrom-InlineStyle -Style $n.GetAttribute('style')

        # Respect explicit fill:none / stroke:none if present (rare, but safe)
        $attrFill = $n.GetAttribute('fill')
        $attrStroke = $n.GetAttribute('stroke')

        $styleFill = if ($styleMap.ContainsKey('fill')) { $styleMap['fill'] } else { '' }
        $styleStroke = if ($styleMap.ContainsKey('stroke')) { $styleMap['stroke'] } else { '' }

        if (-not (Is-NonePaint -Value $attrFill) -and -not (Is-NonePaint -Value $styleFill)) {
            $styleMap['fill'] = $forcedPaint
        }

        if (-not (Is-NonePaint -Value $attrStroke) -and -not (Is-NonePaint -Value $styleStroke)) {
            $styleMap['stroke'] = $forcedPaint
        }

        if ($NormalizeOpacity) {
            $styleMap['opacity'] = '1'
            $styleMap['fill-opacity'] = '1'
            $styleMap['stroke-opacity'] = '1'
        }

        # Write inline style (overrides class CSS like .BlueCoat/.TarInk)
        $n.SetAttribute('style', (ConvertTo-InlineStyle -Map $styleMap))

        # Optional: remove presentation attrs to reduce ambiguity (inline style is the source of truth)
        if ($n.HasAttribute('fill')) { $n.RemoveAttribute('fill') }
        if ($n.HasAttribute('stroke')) { $n.RemoveAttribute('stroke') }
        if ($n.HasAttribute('opacity')) { $n.RemoveAttribute('opacity') }
        if ($n.HasAttribute('fill-opacity')) { $n.RemoveAttribute('fill-opacity') }
        if ($n.HasAttribute('stroke-opacity')) { $n.RemoveAttribute('stroke-opacity') }
    }

    # Write UTF-8 without BOM (clean diffs)
    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Indent = $true
    $settings.Encoding = New-Object System.Text.UTF8Encoding($false)

    $writer = [System.Xml.XmlWriter]::Create($outFile, $settings)
    try {
        $doc.Save($writer)
    }
    finally {
        $writer.Dispose()
    }

    return $outFile
}



# --- Calls (edit paths/sizes as you like) ---

# --- Calls (matching your BaseFileName usage) ---

# 1) PNG sets
New-EigenverftPngIcons -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_no_border.svg" -BaseFileName "evt-logo_on_light_no_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftPngIcons -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_border.svg"   -BaseFileName "evt-logo_on_light_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftPngIcons -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_dark_centered_1024_1024_no_border.svg" -BaseFileName "evt-logo_on_dark_no_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftPngIcons -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_dark_centered_1024_1024_border.svg"   -BaseFileName "evt-logo_on_dark_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"

# 2) Favicons (derive output from BaseFileName unless you pass -OutFile)
New-EigenverftFaviconIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_no_border.svg" -BaseFileName "evt-logo_on_light_no_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftFaviconIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_border.svg"   -BaseFileName "evt-logo_on_light_border"   -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftFaviconIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_dark_centered_1024_1024_no_border.svg" -BaseFileName "evt-logo_on_dark_no_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftFaviconIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_dark_centered_1024_1024_border.svg"   -BaseFileName "evt-logo_on_dark_border"   -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"

# 3) Windows ICOs (derive output from BaseFileName unless you pass -OutFile)
New-EigenverftWindowsIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_no_border.svg" -BaseFileName "evt-logo_on_light_no_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftWindowsIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_border.svg"   -BaseFileName "evt-logo_on_light_border"   -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftWindowsIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_dark_centered_1024_1024_no_border.svg" -BaseFileName "evt-logo_on_dark_no_border" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"
New-EigenverftWindowsIco -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_dark_centered_1024_1024_border.svg"   -BaseFileName "evt-logo_on_dark_border"   -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"

New-EigenverftAppleTouchIcons -InFileLight "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_no_border.svg" -InFileDark  "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_dark_centered_1024_1024_no_border.svg" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created" -Prefer "light" -LightBackground "#F6F0E3" -DarkBackground  "#090E0F"

#New-EigenverftSafariPinnedTabSvg -InFile "C:\dev\github.com\eigenverft\eigenverft\new_media\eigenverft-logo-v8_basis_on_light_centered_1024_1024_no_border.svg" -OutDir "C:\dev\github.com\eigenverft\eigenverft\new_media\created"

