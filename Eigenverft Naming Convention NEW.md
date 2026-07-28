# Naming Convention

## 1. Namensschema

```text
<Root>.<Category>.<Product>[.<Variant>]
```

Beispiele:

```text
<Root>.Service.McpServer
<Root>.Web.CustomerPortal
<Root>.Cli.PackageInspector
<Root>.Tool.RepositoryDoctor
<Root>.CliFx.LegacyConverter
<Root>.WebLib.RequestFilters
<Root>.BlazorLib.Components
<Root>.WinLib.ProcessIsolation.RestrictedToken
```

---

## 2. Bedeutung der Segmente

| Segment | Bedeutung |
|---|---|
| `Root` | Organisation, Marke oder übergeordnete Produktfamilie |
| `Category` | Eine fest erlaubte Kategorie aus Abschnitt 3 |
| `Product` | Fachlicher Produkt- oder Fähigkeitsname |
| `Variant` | Optionale konkrete Variante desselben Produkts |

Beispiel:

```text
<Root>.WinLib.ProcessIsolation.RestrictedToken
<Root>.WinLib.ProcessIsolation.AppContainer
```

Dabei gilt:

```text
Category = WinLib
Product  = ProcessIsolation
Variant  = RestrictedToken oder AppContainer
```

Das Variantensegment wird nur verwendet, wenn tatsächlich mehrere Varianten eines gemeinsamen Produkts existieren.

---

## 3. Feste Kategorien

Die folgende Tabelle ist die vollständige Whitelist.

Kategorien werden ausgewählt. Sie dürfen nicht spontan kombiniert, abgekürzt oder während der Benennung eines einzelnen Projekts neu erfunden werden.

| Kategorie | Art | Bedeutung und Verwendung |
|---|---|---|
| `Web` | Anwendung | Browseranwendung, Webportal, Blazor-Anwendung oder Progressive Web App |
| `Desktop` | Anwendung | Native oder desktoporientierte Anwendung, beispielsweise WinForms, WPF, WinUI oder Avalonia |
| `Service` | Anwendung | Dauerhaft laufender Server, API, Worker, Proxy, Daemon oder Backenddienst |
| `Cli` | Anwendung | Eigenständig veröffentlichte Kommandozeilenanwendung für modernes .NET |
| `Tool` | Anwendung/Paket | Als lokales oder globales .NET Tool über ein NuGet-Paket installiertes Kommando |
| `CliFx` | Anwendung | Eigenständig veröffentlichte Kommandozeilenanwendung für klassisches .NET Framework |
| `Module` | Automatisierung | PowerShell-Modul, das über ein Modulmanifest installiert und über Cmdlets konsumiert wird |
| `Lib` | Bibliothek | Laufzeitneutraler oder breit kompatibler Bibliotheksvertrag, typischerweise auf Basis von .NET Standard |
| `NetLib` | Bibliothek | Allgemeine Bibliothek für modernes .NET, also .NET Core beziehungsweise .NET 5 oder neuer |
| `WebLib` | Bibliothek | Moderne Bibliothek für ASP.NET Core, HTTP, Middleware, Hosting, Razor oder allgemeine Webtechnologien |
| `BlazorLib` | Bibliothek | Blazor-Komponentenbibliothek oder Razor Class Library mit Blazor als öffentlichem Produktvertrag |
| `DesktopLib` | Bibliothek | Moderne Bibliothek mit öffentlicher Bindung an Desktop-UI-Technologien |
| `WinLib` | Bibliothek | Moderne Bibliothek für Windows-Betriebssystemfunktionen ohne primären Desktop-UI-Vertrag |
| `InteropLib` | Bibliothek | Moderne Bibliothek, bei der Managed-/Native-Interop selbst die öffentliche Produktfunktion ist |
| `WebFxLib` | Framework-Bibliothek | Klassische ASP.NET- oder Webbibliothek auf .NET Framework |
| `DesktopFxLib` | Framework-Bibliothek | Klassische WinForms- oder WPF-Bibliothek auf .NET Framework |
| `WinFxLib` | Framework-Bibliothek | Allgemeine Windows-Bibliothek auf klassischem .NET Framework |
| `InteropFxLib` | Framework-Bibliothek | Bibliothek auf klassischem .NET Framework, bei der Interop selbst die Produktfunktion ist |
| `Templates` | Repositoryform | Projektvorlagen, Scaffolding oder eine Sammlung von Templates |
| `Profile` | Repositoryform | Deklaratives, direkt verwendbares Laufzeit- oder Umgebungsprofil |
| `Extension` | Repositoryform | Erweiterung für einen bestehenden Host, beispielsweise Visual Studio oder Microsoft Office |
| `Installer` | Repositoryform | Installer, Offline-Installer oder Installationsmedium |
| `Artifacts` | Repositoryform | Binärdateien oder veröffentlichte Artefakte ohne primäres Quellprodukt |
| `Suite` | Repositoryform | Repository mit mehreren eigenständig entwickelten oder veröffentlichten Produkten |
| `Lab` | Repositoryform | Aktives Experiment, Prototyp oder Inkubationsprojekt |
| `Meta` | Repositoryform | Governance, Branding, Dokumentation oder organisationsweite Konfiguration |
| `Archive` | Repositoryform | Historischer und nicht mehr aktiv entwickelter Bestand |

### Verbindliche Kategorienliste

```text
Web
Desktop
Service
Cli
Tool
CliFx
Module

Lib
NetLib
WebLib
BlazorLib
DesktopLib
WinLib
InteropLib

WebFxLib
DesktopFxLib
WinFxLib
InteropFxLib

Templates
Profile
Extension
Installer
Artifacts
Suite
Lab
Meta
Archive
```

---

## 4. Nicht erlaubte Kategorien

| Nicht erlaubt | Grund | Zu verwendende Alternative |
|---|---|---|
| `App` | Zu allgemein; unterscheidet Browser, Desktop, Dienst und Kommandozeile nicht | `Web`, `Desktop`, `Service`, `Cli`, `Tool` oder `CliFx` |
| `WebApp` | `App` ist redundant, weil `Web` verbindlich als ausführbares Browserprodukt definiert ist | `Web` |
| `DesktopApp` | `App` ist redundant, weil `Desktop` verbindlich als ausführbares Desktopprodukt definiert ist | `Desktop` |
| `CliTool` | Vermischt eigenständige CLI-Anwendung und .NET-Tool-Paketierung | `Cli` oder `Tool` |
| `CommandLineTool` | Zu lang und nicht eindeutig zwischen eigenständiger Anwendung und .NET Tool | `Cli` oder `Tool` |
| `DotnetTool` | Produktname und Installationsmechanismus werden unnötig ausgeschrieben | `Tool` |
| `CliFxNet` | `Fx` bezeichnet bereits klassisches .NET Framework; `Net` ist redundant | `CliFx` |
| `FxCli` | Verstößt gegen die festgelegte Wortreihenfolge | `CliFx` |
| `Library` | Verstößt gegen die festgelegte kurze Library-Grammatik | `Lib` |
| `NetStandardLib` | .NET Standard wird bereits durch die neutrale Kategorie `Lib` ausgedrückt | `Lib` |
| `ModernNetLib` | „Modern“ ist zeitabhängig und altert | `NetLib` |
| `NetCoreLib` | .NET Core ist eine frühere Produktbezeichnung und umfasst .NET 5+ nicht sauber | `NetLib` |
| `FxLib` | Klassisches .NET Framework ist nicht plattformneutral | `WinFxLib` oder eine spezifischere `*FxLib`-Kategorie |
| `AspNetLib` | Zu eng an einen Frameworknamen gebunden | `WebLib` |
| `RazorLib` | Razor kann serverseitiges Web oder Blazor-Komponenten bedeuten | `WebLib` oder `BlazorLib` |
| `BrowserLib` | Nicht eindeutig zwischen allgemeinem Browsercode und Blazor-Komponenten | `WebLib` oder `BlazorLib` |
| `WindowsLibrary` | Verstößt gegen die verbindliche Kurzform | `WinLib` |
| `WindowsLib` | Verstößt gegen die festgelegte Abkürzung `Win` | `WinLib` |
| `WinWebLib` | Erzeugt spontan eine nicht freigegebene Mischkategorie | `WebLib` oder `WinLib` |
| `WindowsSecurityLib` | Vermischt Plattform, Produktdomäne und Artefaktart | `WinLib` und Sicherheitsfunktion im Produktnamen |
| `SecurityLib` | Sicherheit ist meist eine Produktdomäne und keine technische Konsumform | Passende Library-Kategorie und Sicherheitsfunktion im Produktnamen |
| `DataLib` | Datenhaltung ist meist eine Produktdomäne und keine technische Bindung | `Lib` oder `NetLib` und Datenfunktion im Produktnamen |
| `CrossPlatformLib` | Plattformunabhängigkeit ist eine Eigenschaft und kein präziser Laufzeitvertrag | `Lib` oder `NetLib` |
| `CompatLib` | Kompatibilität ist zu unspezifisch und gehört in den dokumentierten Supportvertrag | `Lib`, `NetLib` oder passende `*FxLib`-Kategorie |
| `FxWebLib` | Falsche Reihenfolge; die Grammatik lautet `<Domain>FxLib` | `WebFxLib` |
| `FxDesktopLib` | Falsche Reihenfolge; die Grammatik lautet `<Domain>FxLib` | `DesktopFxLib` |
| `FxWinLib` | Falsche Reihenfolge | `WinFxLib` |
| `InteropWindowsLib` | Vermischt Produktfunktion und Plattform ohne klare Präzedenz | `InteropLib` oder `WinLib` |
| `Templated` | Kann bedeuten, dass ein Produkt lediglich aus einem Template erzeugt wurde | `Templates` |
| `Archived` | Beschreibt eher einen Zustand als die Repositoryfunktion | `Archive` |

---

## 5. Auswahl der Kategorie

Die Kategorie wird in der folgenden Reihenfolge bestimmt:

| Priorität | Prüfung | Ergebnis |
|---:|---|---|
| 1 | Ist das Repository eine besondere Repositoryform? | `Templates`, `Profile`, `Extension`, `Installer`, `Artifacts`, `Suite`, `Lab`, `Meta` oder `Archive` |
| 2 | Ist das primäre Artefakt ein PowerShell-Modul? | `Module` |
| 3 | Ist das Produkt ausführbar oder deploybar? | `Web`, `Desktop`, `Service`, `Cli`, `Tool` oder `CliFx` |
| 4 | Ist es eine klassische .NET-Framework-Bibliothek? | Passende `*FxLib`-Kategorie |
| 5 | Ist es eine moderne oder neutrale Bibliothek mit spezifischem öffentlichem Vertrag? | `BlazorLib`, `WebLib`, `DesktopLib`, `WinLib` oder `InteropLib` |
| 6 | Ist modernes .NET Teil des öffentlichen Vertrags? | `NetLib` |
| 7 | Ist der Vertrag laufzeitneutral beziehungsweise .NET-Standard-basiert? | `Lib` |

Die erste eindeutig zutreffende Regel gewinnt.

---

## 6. Repository-Sonderformen

| Situation | Kategorie |
|---|---|
| Sammlung von Projektvorlagen | `Templates` |
| Deklaratives Laufzeit- oder Umgebungsprofil | `Profile` |
| Erweiterung eines bestehenden Hosts | `Extension` |
| Installer oder Installationsmedium | `Installer` |
| Reine Binär- oder Artefaktablage | `Artifacts` |
| Mehrere eigenständige Produkte | `Suite` |
| Experiment, Prototyp oder Inkubator | `Lab` |
| Governance, Branding oder übergreifende Dokumentation | `Meta` |
| Historischer Bestand | `Archive` |

Beispiele:

```text
<Root>.Templates.WebProjects
<Root>.Profile.WindowsSandbox
<Root>.Extension.VisualStudioToolbar
<Root>.Installer.OfflineEnvironment
<Root>.Artifacts.ProductBinaries
<Root>.Suite.DeveloperTools
<Root>.Lab.Hosting
<Root>.Meta.Conventions
<Root>.Archive.Legacy
```

Repository-Sonderformen haben Vorrang vor einzelnen enthaltenen Projekttypen.

Ein Repository mit mehreren eigenständigen Anwendungen wird beispielsweise als `Suite` benannt und nicht nach einem beliebigen enthaltenen Hauptprojekt.

---

## 7. Ausführbare Produkte

| Primäre Verwendung | Kategorie | Abgrenzung |
|---|---|---|
| Benutzer arbeitet hauptsächlich im Browser | `Web` | Browseroberfläche ist das eigentliche Produkt |
| Benutzer arbeitet hauptsächlich mit einer nativen Oberfläche | `Desktop` | Desktopoberfläche ist das eigentliche Produkt |
| Prozess läuft dauerhaft, serverseitig oder headless | `Service` | Server, API, Worker, Proxy oder Daemon ist das Produkt |
| Moderne .NET-Anwendung wird direkt über die Kommandozeile gestartet | `Cli` | Eigenständige CLI-Distribution; nicht über `dotnet tool install` konsumiert |
| Kommando wird als lokales oder globales .NET Tool installiert | `Tool` | Installation und Verwaltung erfolgen über `dotnet tool` |
| Klassische .NET-Framework-Anwendung wird über die Kommandozeile gestartet | `CliFx` | Eigenständige Konsolenanwendung für klassisches .NET Framework |
| Nutzer installieren ein PowerShell-Modul und verwenden Cmdlets | `Module` | Modulmanifest und Cmdlets sind die primäre Schnittstelle |

Beispiele:

```text
<Root>.Web.CustomerPortal
<Root>.Desktop.PackageManager
<Root>.Service.McpServer
<Root>.Service.ReverseProxy
<Root>.Cli.PackageInspector
<Root>.Tool.RepositoryDoctor
<Root>.CliFx.LegacyConverter
<Root>.Module.Deployment
```

### 7.1 `Cli`

`Cli` bezeichnet eine eigenständig veröffentlichte Kommandozeilenanwendung für modernes .NET.

Sie kann veröffentlicht werden als:

- framework-dependent Deployment,
- framework-dependent Executable,
- self-contained Deployment,
- Single-File-Anwendung,
- plattformspezifischer Apphost,
- portable DLL mit Start über `dotnet`.

Beispiele:

```text
dotnet PackageInspector.dll
PackageInspector.exe
./PackageInspector
```

Alle diese Formen können zur Kategorie `Cli` gehören.

Entscheidend ist nicht, ob die Anwendung self-contained ist.

Entscheidend ist:

> Die Anwendung wird direkt als eigenständiges Kommandozeilenprodukt veröffentlicht und nicht primär über `dotnet tool install` konsumiert.

Typische Projektmerkmale:

```xml
<OutputType>Exe</OutputType>
<TargetFramework>net10.0</TargetFramework>
```

Mögliche Namen:

```text
<Root>.Cli.PackageInspector
<Root>.Cli.ConfigurationEditor
<Root>.Cli.RepositorySync
```

### 7.2 `Tool`

`Tool` bezeichnet ausschließlich ein als lokales oder globales .NET Tool gepacktes Produkt.

Typische Installation:

```text
dotnet tool install --global <package>
```

oder:

```text
dotnet tool restore
```

Typische Projektmerkmale:

```xml
<OutputType>Exe</OutputType>
<PackAsTool>true</PackAsTool>
<ToolCommandName>repository-doctor</ToolCommandName>
```

Mögliche Namen:

```text
<Root>.Tool.RepositoryDoctor
<Root>.Tool.PackageAudit
<Root>.Tool.BuildInspector
```

Ein .NET Tool enthält technisch ausführbaren .NET-Code. Für die Kategorie zählt jedoch nicht die interne Dateiform, sondern die öffentliche Installations- und Konsumform.

```text
direkt veröffentlichtes Kommando
→ Cli

Installation über dotnet tool
→ Tool
```

### 7.3 `CliFx`

`CliFx` bezeichnet eine eigenständig veröffentlichte Konsolenanwendung für klassisches .NET Framework.

Typische Targets:

```text
net20
net40
net462
net48
```

Typische Projektmerkmale:

```xml
<OutputType>Exe</OutputType>
<TargetFrameworkVersion>v4.8</TargetFrameworkVersion>
```

oder SDK-basiert:

```xml
<OutputType>Exe</OutputType>
<TargetFramework>net48</TargetFramework>
```

Mögliche Namen:

```text
<Root>.CliFx.LegacyConverter
<Root>.CliFx.ConfigurationMigrator
<Root>.CliFx.OfficeExporter
```

`CliFxNet` wird nicht verwendet, da `Fx` bereits klassisches .NET Framework bezeichnet.

### 7.4 Abgrenzung `Cli`, `Tool` und `CliFx`

| Situation | Kategorie |
|---|---|
| Moderne .NET-Konsolenanwendung, direkt veröffentlicht | `Cli` |
| Moderne .NET-Konsolenanwendung, framework-dependent | `Cli` |
| Moderne .NET-Konsolenanwendung, self-contained | `Cli` |
| Moderne .NET-Konsolenanwendung als Single File | `Cli` |
| Installation über `dotnet tool install` | `Tool` |
| Wiederherstellung über ein Tool-Manifest | `Tool` |
| Klassische .NET-Framework-Konsolenanwendung | `CliFx` |

Die Kategorien unterscheiden sich durch Laufzeitgeneration und öffentliche Distribution, nicht nur durch `OutputType=Exe`.

### 7.5 `Cli`, `Tool` oder `Service`

```text
startet für einen Befehl und beendet sich
→ Cli, Tool oder CliFx

läuft dauerhaft und wartet auf Arbeit
→ Service
```

Ein CLI-Programm darf während eines Befehls temporär:

- einen HTTP-Listener starten,
- einen Browser öffnen,
- Unterprozesse ausführen,
- Dateien überwachen,
- mit einem Remote-Service kommunizieren.

Es bleibt dennoch ein `Cli`, `Tool` oder `CliFx`, wenn sein Lebenszyklus befehlsgebunden ist.

### 7.6 `Web` oder `Service`

```text
Browseroberfläche ist das Produkt
→ Web

API, Server, Proxy oder Endpoint ist das Produkt
→ Service
```

Ein `Web`-Produkt darf ein Backend enthalten.

Ein `Service` darf intern ASP.NET Core verwenden.

### 7.7 `Desktop` oder `Service`

Eine Desktopanwendung mit eingebettetem lokalen Server bleibt `Desktop`, wenn die native Benutzeroberfläche die primäre Interaktionsform ist.

### 7.8 `Module` oder `Cli`

```text
Nutzer installieren ein PowerShell-Modul und rufen Cmdlets auf
→ Module

Nutzer starten ein eigenständiges Kommando
→ Cli, Tool oder CliFx
```

Ein Modul darf intern ein CLI-Produkt starten. Die beiden Artefakte können getrennte Namen tragen:

```text
<Root>.Module.Deployment
<Root>.Cli.Deployment
```

---

## 8. Moderne und neutrale Bibliotheken

### 8.1 `Lib`

`Lib` bezeichnet eine laufzeitneutrale oder breit kompatible Bibliothek.

Typische Targets:

```text
netstandard2.0
netstandard2.1
```

Auch Multi-Targeting ist möglich, wenn der neutrale gemeinsame Vertrag die Produktidentität bleibt:

```text
netstandard2.0
net8.0
net10.0
```

Beispiele:

```text
<Root>.Lib.Configuration
<Root>.Lib.Validation
<Root>.Lib.PackageModel
```

### 8.2 `NetLib`

`NetLib` bezeichnet eine allgemeine Bibliothek für modernes .NET.

Typische Targets:

```text
net8.0
net9.0
net10.0
```

Moderne .NET-APIs sind dabei Teil des öffentlichen Produktvertrags.

Beispiele:

```text
<Root>.NetLib.CommandLine
<Root>.NetLib.RuntimeModel
<Root>.NetLib.DependencyInjection
```

### `Lib` oder `NetLib`

| Situation | Kategorie |
|---|---|
| Öffentlicher Vertrag basiert auf .NET Standard | `Lib` |
| Neutrales Multi-Targeting mit .NET Standard als gemeinsamer Basis | `Lib` |
| Modernes .NET ist Teil des öffentlichen Produktvertrags | `NetLib` |
| Projekt targetet nur modernes .NET und besitzt keine spezifischere Bindung | `NetLib` |

### 8.3 `WebLib`

`WebLib` bezeichnet eine moderne wiederverwendbare Webbibliothek.

Typische öffentliche Bindungen:

- ASP.NET Core,
- Middleware,
- `HttpContext`,
- Endpoint Routing,
- Hosting,
- MVC-Filter,
- HTTP-Abstraktionen,
- allgemeine Razor-Funktionalität.

Beispiele:

```text
<Root>.WebLib.RequestFilters
<Root>.WebLib.Hosting
<Root>.WebLib.Authentication
```

### 8.4 `BlazorLib`

`BlazorLib` bezeichnet eine Blazor-Komponentenbibliothek oder eine Razor Class Library mit Blazor als öffentlichem Produktvertrag.

Typische Inhalte:

- Razor Components,
- `ComponentBase`,
- Blazor-Layouts,
- Blazor-Navigation,
- wiederverwendbare Blazor-Komponenten,
- Blazor-spezifische UI-Services.

Beispiele:

```text
<Root>.BlazorLib.Components
<Root>.BlazorLib.Controls
<Root>.BlazorLib.Layouts
```

### `BlazorLib` oder `WebLib`

| Öffentlicher Vertrag | Kategorie |
|---|---|
| Wiederverwendbare Blazor-Komponenten oder Blazor-UI | `BlazorLib` |
| Middleware, Hosting, HTTP oder allgemeine Webfunktion | `WebLib` |
| Razor Views ohne Blazor-Komponentenidentität | `WebLib` |
| Razor Class Library mit Blazor-Komponenten | `BlazorLib` |

### 8.5 `DesktopLib`

`DesktopLib` bezeichnet eine moderne Bibliothek mit öffentlichem Desktop-UI-Vertrag.

Typische Technologien:

- WPF auf modernem .NET,
- WinForms auf modernem .NET,
- WinUI,
- Avalonia,
- MAUI Desktop.

Beispiele:

```text
<Root>.DesktopLib.Controls
<Root>.DesktopLib.Dialogs
<Root>.DesktopLib.Theming
```

### 8.6 `WinLib`

`WinLib` bezeichnet eine moderne Windows-spezifische Bibliothek ohne primären Desktop-UI-Vertrag.

Typische Funktionen:

- Windows Tokens,
- AppContainer,
- Windows Services,
- Registry,
- Job Objects,
- Prozessisolation,
- Windows-Sicherheitsfunktionen.

Beispiele:

```text
<Root>.WinLib.ProcessIsolation.RestrictedToken
<Root>.WinLib.ProcessIsolation.AppContainer
<Root>.WinLib.Registry
```

### 8.7 `InteropLib`

`InteropLib` wird nur verwendet, wenn Managed-/Native-Interop selbst die öffentlich angebotene Fähigkeit ist.

Beispiele:

```text
<Root>.InteropLib.NativeHandles
<Root>.InteropLib.DynamicLibrary
<Root>.InteropLib.Terminal
```

| Situation | Kategorie |
|---|---|
| P/Invoke implementiert eine Windows-Funktion | `WinLib` |
| P/Invoke implementiert Desktop-UI-Funktionalität | `DesktopLib` |
| Allgemeine Native-Handle- oder ABI-Abstraktion ist das Produkt | `InteropLib` |

---

## 9. Klassisches .NET Framework

| Öffentlicher Vertrag | Kategorie |
|---|---|
| Klassische ASP.NET- oder Webbindung | `WebFxLib` |
| Klassische WinForms- oder WPF-Bindung | `DesktopFxLib` |
| Allgemeine Windows-/Framework-Bibliothek | `WinFxLib` |
| Interop ist die öffentliche Produktfunktion | `InteropFxLib` |

Beispiele:

```text
<Root>.WebFxLib.RequestFilters
<Root>.DesktopFxLib.Controls
<Root>.WinFxLib.ConsoleControl
<Root>.InteropFxLib.NativeHandles
```

### Library-Grammatik

Moderne und neutrale Bibliotheken:

```text
Lib
NetLib
WebLib
BlazorLib
DesktopLib
WinLib
InteropLib
```

Klassisches .NET Framework:

```text
WebFxLib
DesktopFxLib
WinFxLib
InteropFxLib
```

`FxLib` allein ist nicht erlaubt.

Eine allgemeine klassische Framework-Bibliothek wird als `WinFxLib` eingeordnet, da klassisches .NET Framework an Windows gebunden ist.

---

## 10. Präzedenz bei Überschneidungen

Die stärkste öffentliche Konsumentenbindung bestimmt die Kategorie.

| Prüfung | Ergebnis |
|---|---|
| Öffentliche Blazor-Komponenten | `BlazorLib` |
| Öffentlicher Webvertrag | `WebLib` oder `WebFxLib` |
| Öffentlicher Desktop-UI-Vertrag | `DesktopLib` oder `DesktopFxLib` |
| Öffentliche Windows-OS-Funktion | `WinLib` oder `WinFxLib` |
| Interop selbst ist das Produkt | `InteropLib` oder `InteropFxLib` |
| Allgemeines modernes .NET | `NetLib` |
| Neutraler .NET-Standard-Vertrag | `Lib` |

Beispiele:

| Produkt | Kategorie | Grund |
|---|---|---|
| Blazor-Komponenten mit Browser-Interop | `BlazorLib` | Blazor-Komponenten bilden den öffentlichen Vertrag |
| ASP.NET-Core-Middleware, die nur unter Windows läuft | `WebLib` | Nutzer konsumieren sie als Webkomponente |
| WPF-Control-Library mit P/Invoke | `DesktopLib` | Desktop-UI ist die öffentliche Bindung |
| Windows-Prozessisolation mit P/Invoke | `WinLib` | Windows-Prozessisolation ist die Produktfunktion |
| Allgemeine Wrapper für native Handles | `InteropLib` | Interop selbst ist das Produkt |
| Allgemeine moderne Bibliothek | `NetLib` | Modernes .NET ist Teil des Vertrags |
| Neutrale .NET-Standard-Bibliothek | `Lib` | Neutraler Vertrag |
| Klassische ASP.NET-Komponente | `WebFxLib` | Webvertrag auf .NET Framework |
| Klassische WinForms-Control-Library | `DesktopFxLib` | Desktop-UI-Vertrag auf .NET Framework |

---

## 11. Target Frameworks

Target Frameworks sind grundsätzlich Projekt- und Paketmetadaten.

Sie werden nicht automatisch Bestandteil des Produktnamens.

| Targeting und Produktvertrag | Kategorie |
|---|---|
| `netstandard2.0` oder `netstandard2.1` als Basisvertrag | `Lib` |
| .NET Standard plus moderne Targets mit gemeinsamer neutraler API | `Lib` |
| Ausschließlich modernes .NET ohne spezifischere Bindung | `NetLib` |
| Modernes Webframework | `WebLib` oder `BlazorLib` |
| Modernes Windows-Target | `WinLib` oder `DesktopLib` |
| Klassisches .NET Framework | passende `*FxLib`-Kategorie |
| Klassische .NET-Framework-Konsolenanwendung | `CliFx` |

### Gemischtes modernes .NET und .NET Framework

Bei einem Paket mit beispielsweise:

```text
net462
net8.0
net10.0
```

gilt:

| Situation | Entscheidung |
|---|---|
| Ein neutraler .NET-Standard-Vertrag ist vorhanden | `Lib` |
| Modernes .NET ist der primäre Vertrag, Framework ist Zusatzsupport | Moderne Kategorie |
| Klassisches Framework ist der primäre Vertrag | Passende `*FxLib`-Kategorie |
| APIs oder Releasezyklen unterscheiden sich wesentlich | Produkte trennen |

Es wird keine spontane Mischkategorie erzeugt.

---

## 12. Produktnamen

Der Produktname beschreibt die fachliche Fähigkeit.

Bevorzugt:

```text
RequestFilters
ProcessIsolation
McpServer
ReverseProxy
ConsoleControl
PackageInspector
RepositoryDoctor
```

Möglichst vermeiden:

```text
Common
General
Shared
Misc
New
Modern
Experimental
All
```

`Core` darf verwendet werden, wenn es tatsächlich der etablierte Name eines zentralen Produktkerns oder einer allgemeinen Basissammlung ist.

Produktnamen verwenden PascalCase.

---

## 13. Varianten

Varianten werden als separates Segment geschrieben:

```text
<Root>.<Category>.<Product>.<Variant>
```

Beispiele:

```text
<Root>.WinLib.ProcessIsolation.RestrictedToken
<Root>.WinLib.ProcessIsolation.AppContainer

<Root>.NetLib.EventStore.Sqlite
<Root>.NetLib.EventStore.InMemory
```

Nicht als Variante verwenden:

```text
Net10
New
Modern
Preview
Experimental
```

Versionen und Entwicklungsstatus gehören in Projekt-, Paket- und Release-Metadaten.

---

## 14. Unterprojekte

Unterprojekte behalten den vollständigen Produktstamm:

```text
<Root>.Service.McpServer
<Root>.Service.McpServer.Tests
<Root>.Service.McpServer.IntegrationTests
<Root>.Service.McpServer.SmokeTests
```

Empfohlene Suffixe:

```text
Tests
UnitTests
IntegrationTests
SmokeTests
Benchmarks
Samples
TestHost
```

Repository, Solution, Hauptprojekt, Assembly und Paket sollen möglichst denselben Stamm verwenden.

---

## 15. Schreibregeln

Alle Segmente verwenden PascalCase.

Bevorzugt:

```text
McpServer
MultiHost
RequestFilters
ProcessIsolation
RestrictedToken
AppContainer
```

Nicht verwenden:

```text
MCPServer
multihost
request-filters
Process_Isolation
```

Akronyme mit mindestens drei Buchstaben werden als normale PascalCase-Wörter behandelt:

```text
Mcp
Http
Json
Sqlite
Pwa
Cli
```

Etablierte Produktnamen dürfen ihre offizielle Schreibweise behalten.

---

## 16. Verbindliche Kurzfassung

```text
Schema:
<Root>.<Category>.<Product>[.<Variant>]

Erlaubte Kategorien:

Web
Desktop
Service
Cli
Tool
CliFx
Module

Lib
NetLib
WebLib
BlazorLib
DesktopLib
WinLib
InteropLib

WebFxLib
DesktopFxLib
WinFxLib
InteropFxLib

Templates
Profile
Extension
Installer
Artifacts
Suite
Lab
Meta
Archive

Cli:
Eigenständige moderne .NET-Kommandozeilenanwendung.
Sie kann framework-dependent, self-contained oder Single File sein.

Tool:
Lokales oder globales .NET Tool.
Installation erfolgt über dotnet tool.

CliFx:
Eigenständige Kommandozeilenanwendung für klassisches .NET Framework.

Lib:
Neutraler Vertrag, typischerweise .NET Standard.

NetLib:
Allgemeine Bibliothek für modernes .NET.

BlazorLib:
Blazor-Komponentenbibliothek oder passende Razor Class Library.

FxLib:
Allein nicht erlaubt.

Kategorien:
Werden aus der Whitelist ausgewählt und nicht frei zusammengesetzt.

Target Frameworks:
Werden nicht automatisch im Namen codiert.

Präzedenz:
Die stärkste öffentliche Konsumentenbindung bestimmt die Kategorie.
```
