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
            [Parameter(Mandatory)][string[]]$Args,
            [Parameter(Mandatory)][string]$Context
        )

        & $MagickPath @Args
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

        $args = @(
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

        Invoke-Magick -Args $args -Context "png $outFile"
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

        $args = @(
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

        Invoke-Magick -Args $args -Context "maskable $outFile"
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


