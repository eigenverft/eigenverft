# General Eigenverft Project and Namespace Naming Rules

Short introduction:

Eigenverft project names use a fixed branded structure.
Every project name must contain:
- a brand
- a family
- a project name

A project name is always required.
Brand + family only is not allowed.

This document defines:
- project names
- package names
- namespace roots

This document does not define:
- folder structure
- source layout
- implementation layering
- build output kinds
- internal dependency tiers

## Quick Start

When creating a new Eigenverft project name:

1. Start with the fixed brand:
   - `Eigenverft`

2. Choose the correct family:
   - `Unified` — shared libraries for broad compatibility, for example `netstandard2.0`
   - `Composed` — modern libraries for current .NET versions, for example `net6.0` or `net10.0`
   - `Marshaled` — Windows-specific modern .NET libraries
   - `Routed` — ASP.NET Core, web, HTTP, and request pipeline projects
   - `Bladed` — Razor, UI, and presentation projects
   - `Manifested` — PowerShell modules
   - `Distributed` — CLI and dotnet tools
   - `Forged` — MSBuild and build integration projects
   - `Seeded` — templates and starter projects
   - `Legacy.NetFx2` — legacy .NET Framework 2.x projects
   - `Legacy.NetFx4` — legacy .NET Framework 4.x projects

3. Choose the project name:
   - for a concrete project, use the real subject directly
   - for an intentionally broad shared project, use one of the reserved shared project names

4. Add a project subqualifier only when extending an existing project line or refining a shared project line.

5. Use the same value for the namespace root as for the full project name.

Examples:
- `Eigenverft.Routed.RequestFilters`
- `Eigenverft.Marshaled.ProgressBarEx`
- `Eigenverft.Unified.Primitives`
- `Eigenverft.Unified.Primitives.Serialization`
- `Eigenverft.Composed.Extensions.Hosting`
- `Eigenverft.Routed.RequestFilters.Tests`
- `Eigenverft.Legacy.NetFx2.ProgressBarEx`

## Terms

- `brand` is the fixed root segment at the beginning of every Eigenverft project name.
- `family` identifies the project line or ecosystem area the project belongs to.
- `project` is the actual subject of the project.

Derived forms:
- `qualified family` is a special form of `family` that uses more than one segment.
- `project subqualifier` is a special extension of `project` used to extend or refine an existing project line.
- `reserved shared project name` is a special form of `project` for intentionally broad shared projects.
- `namespace root` is the primary namespace that mirrors the project name.

## Families

Current families:
- `Unified` — shared libraries for broad compatibility, for example `netstandard2.0`
- `Composed` — modern libraries for current .NET versions, for example `net8.0` or `net9.0`
- `Marshaled` — Windows-specific modern .NET libraries
- `Routed` — ASP.NET Core, web, HTTP, and request pipeline projects
- `Bladed` — Razor, UI, and presentation projects
- `Manifested` — PowerShell modules
- `Distributed` — CLI and dotnet tools
- `Forged` — MSBuild and build integration projects
- `Seeded` — templates and starter projects
- `Legacy.NetFx2` — legacy .NET Framework 2.x projects
- `Legacy.NetFx4` — legacy .NET Framework 4.x projects

## Reserved Shared Project Names

- `Primitives` is a shared project name for packages with no intentional external package dependencies.
- `Extensions` is a shared project name for packages with Microsoft ecosystem dependencies only.
- `Integrations` is a shared project name for packages with third-party dependencies.

These names are reserved for intentionally broad shared projects.
They do not replace normal concrete project names.

Shared base examples:
- `Eigenverft.Unified.Primitives`
- `Eigenverft.Composed.Extensions`
- `Eigenverft.Routed.Integrations`

Shared refined examples:
- `Eigenverft.Unified.Primitives.Serialization`
- `Eigenverft.Composed.Extensions.Hosting`
- `Eigenverft.Routed.Integrations.Swashbuckle`

## Base Naming Forms

Standard concrete form:
- `Eigenverft.Family.Project`

Qualified legacy concrete form:
- `Eigenverft.Legacy.NetFx2.Project`
- `Eigenverft.Legacy.NetFx4.Project`

Extended concrete project line:
- `Eigenverft.Family.Project.Subqualifier`
- `Eigenverft.Legacy.NetFx2.Project.Subqualifier`
- `Eigenverft.Legacy.NetFx4.Project.Subqualifier`

Shared base form:
- `Eigenverft.Family.Primitives`
- `Eigenverft.Family.Extensions`
- `Eigenverft.Family.Integrations`

Shared refined form:
- `Eigenverft.Family.Primitives.Subqualifier`
- `Eigenverft.Family.Extensions.Subqualifier`
- `Eigenverft.Family.Integrations.Subqualifier`

Examples:
- `Eigenverft.Routed.RequestFilters`
- `Eigenverft.Marshaled.ProgressBarEx`
- `Eigenverft.Manifested.Initialize`
- `Eigenverft.Distributed.Release`
- `Eigenverft.Forged.PostBuildRunner`
- `Eigenverft.Seeded.WebApi`
- `Eigenverft.Unified.Primitives`
- `Eigenverft.Unified.Primitives.Serialization`
- `Eigenverft.Composed.Extensions.Hosting`
- `Eigenverft.Routed.RequestFilters.Tests`
- `Eigenverft.Legacy.NetFx2.ProgressBarEx`

## Rules

### Rule 1
Every Eigenverft project name must start with `Eigenverft`.

Correct:
- `Eigenverft.Routed.RequestFilters`
- `Eigenverft.Unified.Primitives.Serialization`

Not allowed:
- `Routed.RequestFilters`
- `Primitives.Serialization`

### Rule 2
Every Eigenverft project name must contain a family.

Correct:
- `Eigenverft.Composed.Extensions.Hosting`
- `Eigenverft.Manifested.Initialize`

Not allowed:
- `Eigenverft.Hosting`
- `Eigenverft.Initialize`

### Rule 3
Every Eigenverft project name must contain a project.

Allowed forms:
- `Eigenverft.Family.Project`
- `Eigenverft.Family.Project.Subqualifier`
- `Eigenverft.Legacy.NetFx2.Project`
- `Eigenverft.Legacy.NetFx2.Project.Subqualifier`
- `Eigenverft.Legacy.NetFx4.Project`
- `Eigenverft.Legacy.NetFx4.Project.Subqualifier`

Not allowed:
- brand + family only
- brand + qualified family only

Examples:
- `Eigenverft.Unified`
- `Eigenverft.Routed`
- `Eigenverft.Legacy.NetFx2`

### Rule 4
Choose the project name by the real type of project.

Use a direct project name when the subject is concrete.

Preferred direct project names:
- `RequestFilters`
- `EndpointFilters`
- `ProgressBarEx`
- `PropertyGridHelpers`
- `TagHelpers`
- `GitBackend`
- `Initialize`
- `GitX`
- `PostBuildRunner`

Examples:
- `Eigenverft.Routed.RequestFilters`
- `Eigenverft.Marshaled.ProgressBarEx`
- `Eigenverft.Manifested.Initialize`
- `Eigenverft.Forged.PostBuildRunner`

Use a reserved shared project name when the project is intentionally broad and shared.

Examples:
- `Eigenverft.Unified.Primitives`
- `Eigenverft.Composed.Extensions`
- `Eigenverft.Routed.Integrations`

If a shared project line needs a concrete subject, add a subqualifier after the reserved shared project name.

Preferred:
- `Eigenverft.Unified.Primitives.Serialization`
- `Eigenverft.Composed.Extensions.Hosting`
- `Eigenverft.Composed.Integrations.NewtonsoftJson`

Not preferred:
- `Eigenverft.Unified.Serialization`
- `Eigenverft.Composed.Hosting`
- `Eigenverft.Composed.NewtonsoftJson`

### Rule 5
The project name must be specific and meaningful.

Good direct project names:
- `RequestFilters`
- `EndpointFilters`
- `ProgressBarEx`
- `PropertyGridHelpers`
- `TagHelpers`
- `GitBackend`
- `Initialize`
- `GitX`
- `PostBuildRunner`

Good shared refined names:
- `Primitives.Serialization`
- `Extensions.Hosting`
- `Integrations.NewtonsoftJson`

Avoid vague project names.

### Rule 6
Do not repeat information that is already obvious from the project name.

Preferred:
- `Eigenverft.Marshaled.ProgressBarEx`
- `Eigenverft.Legacy.NetFx2.ProgressBarEx`

Not preferred:
- `Eigenverft.Marshaled.WinForms.ProgressBarEx`
- `Eigenverft.Legacy.NetFx2.WinForms.ProgressBarEx`

If the project name already makes the technology or UI relationship clear, do not repeat it.

### Rule 7
Use a project subqualifier only to extend an existing project line or to refine a shared project line.

Preferred:
- `Eigenverft.Routed.RequestFilters.Tests`
- `Eigenverft.Routed.RequestFilters.Abstractions`
- `Eigenverft.Routed.RequestFilters.EntityFramework`
- `Eigenverft.Routed.RequestFilters.OpenApi`
- `Eigenverft.Unified.Primitives.Serialization`
- `Eigenverft.Composed.Extensions.Hosting`
- `Eigenverft.Forged.PostBuildRunner.Tasks`

Rule:
The base project name stays stable.
Growth happens by appending a subqualifier after the project name.

### Rule 8
The namespace root must mirror the full project name.

Examples:

Project:
- `Eigenverft.Routed.RequestFilters`
Namespace root:
- `Eigenverft.Routed.RequestFilters`

Project:
- `Eigenverft.Routed.RequestFilters.Tests`
Namespace root:
- `Eigenverft.Routed.RequestFilters.Tests`

Project:
- `Eigenverft.Unified.Primitives.Serialization`
Namespace root:
- `Eigenverft.Unified.Primitives.Serialization`

Project:
- `Eigenverft.Composed.Extensions.Hosting`
Namespace root:
- `Eigenverft.Composed.Extensions.Hosting`

Project:
- `Eigenverft.Legacy.NetFx2.ProgressBarEx`
Namespace root:
- `Eigenverft.Legacy.NetFx2.ProgressBarEx`

### Rule 9
This spec does not define internal project structure.

Out of scope:
- folders
- subfolders
- source layout
- implementation layers
- internal naming by dependency policy

`Primitives`, `Extensions`, and `Integrations` are reserved project names for shared projects.
They are not defined here as internal folder or source-structure rules.

## Family Meanings

### Unified
General-purpose .NET Standard family.

Examples:
- `Eigenverft.Unified.Primitives`
- `Eigenverft.Unified.Primitives.Serialization`
- `Eigenverft.Unified.Extensions.Configuration`

### Composed
Modern .NET general-purpose family.

Examples:
- `Eigenverft.Composed.Primitives`
- `Eigenverft.Composed.Extensions.Hosting`
- `Eigenverft.Composed.Integrations.NewtonsoftJson`

### Marshaled
Windows-specific family.

Examples:
- `Eigenverft.Marshaled.ProgressBarEx`
- `Eigenverft.Marshaled.PropertyGridHelpers`
- `Eigenverft.Marshaled.Integrations.DevExpress`

### Routed
ASP.NET Core, web, HTTP, and request pipeline family.

Examples:
- `Eigenverft.Routed.RequestFilters`
- `Eigenverft.Routed.EndpointFilters`
- `Eigenverft.Routed.Extensions.OpenApi`

### Bladed
Razor, UI, and presentation family.

Examples:
- `Eigenverft.Bladed.TagHelpers`
- `Eigenverft.Bladed.Components`
- `Eigenverft.Bladed.Integrations.MudBlazor`

### Manifested
PowerShell module family.

Examples:
- `Eigenverft.Manifested.Initialize`
- `Eigenverft.Manifested.Version`
- `Eigenverft.Manifested.GitX`

### Distributed
CLI and dotnet tool family.

Examples:
- `Eigenverft.Distributed.Release`
- `Eigenverft.Distributed.GitSync`

### Forged
MSBuild and build integration family.

Examples:
- `Eigenverft.Forged.PostBuildRunner`
- `Eigenverft.Forged.AssemblyVersionStamp`
- `Eigenverft.Forged.PostBuildRunner.Tasks`

### Seeded
Template family.

Examples:
- `Eigenverft.Seeded.WebApi`
- `Eigenverft.Seeded.ManifestedModule`

### Legacy.NetFx2
Legacy .NET Framework 2.x family.

Examples:
- `Eigenverft.Legacy.NetFx2.ProgressBarEx`
- `Eigenverft.Legacy.NetFx2.Primitives.Serialization`

### Legacy.NetFx4
Legacy .NET Framework 4.x family.

Examples:
- `Eigenverft.Legacy.NetFx4.PropertyGridHelpers`
- `Eigenverft.Legacy.NetFx4.Integrations.NewtonsoftJson`

## Short Summary

Standard concrete form:
- `Eigenverft.Family.Project`

Qualified legacy concrete form:
- `Eigenverft.Legacy.NetFx2.Project`
- `Eigenverft.Legacy.NetFx4.Project`

Shared base form:
- `Eigenverft.Family.Primitives`
- `Eigenverft.Family.Extensions`
- `Eigenverft.Family.Integrations`

Shared refined form:
- `Eigenverft.Family.Primitives.Subqualifier`
- `Eigenverft.Family.Extensions.Subqualifier`
- `Eigenverft.Family.Integrations.Subqualifier`

Extended concrete project line:
- `Eigenverft.Family.Project.Subqualifier`

Project names must be specific.
Namespaces must match project names.