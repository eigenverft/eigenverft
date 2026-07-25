# Überarbeitete Eigenverft-Namenskonvention

## 1. Grundformat

```text
Eigenverft.<Category>.<Product>[.<Variant>]
```

Beispiele:

```text
Eigenverft.Service.McpServer
Eigenverft.Tool.Drydock
Eigenverft.Library.ProcessIsolation.RestrictedToken
Eigenverft.Templated.Agents
```

Die Segmente haben feste Verantwortlichkeiten:

| Segment      | Bedeutung                                                 |
| ------------ | --------------------------------------------------------- |
| `Eigenverft` | Marke und Root-Namespace                                  |
| `Category`   | technische Produkt- oder Auslieferungsform                |
| `Product`    | stabile Produktfähigkeit oder Produktfamilie              |
| `Variant`    | Implementierung, Plattform oder klar abgegrenzte Variante |

---

# 2. Leitprinzip

Das zweite Segment soll die wichtigste technische Information liefern:

> Wie wird dieses Produkt verwendet, ausgeführt oder eingebunden?

Es soll nicht primär ausdrücken:

* welchen Zweck das Produkt verfolgt,
* welche Marketingidentität es hat,
* wie sicher oder modern es ist,
* welche interne Architektur verwendet wird.

Beispiel:

```text
Eigenverft.Library.ProcessIsolation.RestrictedToken
```

Hier ist sofort erkennbar:

* Es ist eine wiederverwendbare Bibliothek.
* Sie gehört zur Produktfamilie `ProcessIsolation`.
* Sie implementiert die Variante `RestrictedToken`.

Der Name:

```text
Eigenverft.Guarded.ProcessIsolation.RestrictedToken
```

vermittelt zwar den Sicherheitszweck, verschweigt aber, ob es eine Library, ein Service oder ein Tool ist.

---

# 3. Empfohlene Kategorien

## `Service`

Für länger laufende Backendprozesse ohne primären Desktop- oder Browser-Charakter.

Dazu gehören:

* HTTP-Server
* APIs
* MCP-Server
* Reverse Proxies
* Gateways
* Worker Services
* Hintergrunddienste
* lokal oder zentral laufende Hosts

Beispiele:

```text
Eigenverft.Service.McpServer
Eigenverft.Service.ReverseProxy
Eigenverft.Service.PackageEndpoint
Eigenverft.Service.AgentGateway
```

`Service` ist präziser als `App`, wenn ein dauerhaft laufender Backendprozess gemeint ist.

---

## `Web`

Für browserorientierte Produkte.

Dazu gehören:

* Blazor-Anwendungen
* Progressive Web Apps
* Web-Portale
* browserseitige Clients
* Web-UIs mit eigener Produktidentität

Beispiele:

```text
Eigenverft.Web.GlobalPortal
Eigenverft.Web.PackageCatalog
Eigenverft.Web.AgentConsole
```

Ein Projekt mit Browser-UI und Backend wird nach der primären Produktidentität eingeordnet:

```text
Eigenverft.Web.GlobalPortal
```

wenn das Portal das Produkt ist,

oder:

```text
Eigenverft.Service.GlobalServer
```

wenn der Server und seine API das eigentliche Produkt sind.

---

## `Desktop`

Für Anwendungen mit nativer oder desktoporientierter Benutzeroberfläche.

Dazu gehören:

* WPF
* WinForms
* WinUI
* Avalonia
* MAUI-Desktop
* native Verwaltungsprogramme

Beispiele:

```text
Eigenverft.Desktop.PackageManager
Eigenverft.Desktop.AgentConsole
Eigenverft.Desktop.SandboxInspector
```

Damit wird die frühere Sammelkategorie `App` sinnvoll aufgeteilt:

```text
Service = Backend und Server
Web     = Browseranwendung
Desktop = Desktopanwendung
```

---

## `Tool`

Für eigenständig aufgerufene Kommandozeilenprogramme.

Dazu gehören:

* .NET Tools
* CLI-Anwendungen
* Build-Werkzeuge
* Repository-Werkzeuge
* CI-Helfer
* lokale Entwicklerprogramme

Beispiele:

```text
Eigenverft.Tool.Drydock
Eigenverft.Tool.LlamaRunner
Eigenverft.Tool.RepositoryDoctor
Eigenverft.Tool.PackageInspector
```

`Tool` ist verständlicher als `Distributed`.

`Distributed` kann missverstanden werden als „verteiltes System“, obwohl das aktuelle Drydock-Projekt ein normales .NET-CLI-Tool ist.

Soll die bisherige Marke erhalten bleiben, kann `Distributed` als Legacy-Familie weitergeführt werden. Für neue Projekte ist `Tool` jedoch semantisch besser.

---

## `Module`

Für PowerShell-Module.

Dazu gehören:

* `.psd1`-Module
* `.psm1`-Module
* PowerShell-Kommandosammlungen
* PowerShell-Automatisierungsoberflächen

Beispiele:

```text
Eigenverft.Module.Agent
Eigenverft.Module.Drydock
Eigenverft.Module.Package
```

`Manifested` klingt eigenständig und ist historisch etabliert, aber `Module` ist fachlich klarer.

Eine mögliche konservative Entscheidung lautet:

```text
Bestehende PowerShell-Produkte: Manifested
Neue PowerShell-Produkte:       Module
```

Das würde jedoch zwei parallele Systeme erzeugen. Langfristig ist deshalb `Module` sauberer.

---

## `Library`

Für wiederverwendbare Codepakete.

Dazu gehören:

* NuGet-Bibliotheken
* Middleware-Pakete
* Sicherheitsbibliotheken
* Interop-Bibliotheken
* Provider
* Framework-Erweiterungen
* gemeinsame Komponenten

Beispiele:

```text
Eigenverft.Library.RequestFilters
Eigenverft.Library.ProcessIsolation.RestrictedToken
Eigenverft.Library.ProcessIsolation.AppContainer
Eigenverft.Library.NativeProcess
Eigenverft.Library.PackageContracts
```

`Library` darf generisch sein, weil das dritte und vierte Segment die fachliche Differenzierung übernehmen.

Das ist besser als viele künstliche Bibliotheksfamilien wie:

```text
Guarded
Marshaled
Composed
Persisted
```

Diese Begriffe können höchstens als Produkt- oder Subsystemnamen dienen, sollten aber nicht zwingend die technische Produktart ersetzen.

---

## `Templated`

Für Templates, Starter und Scaffolding.

Dazu gehören:

* Agent-Templates
* `dotnet new` Templates
* Repository-Vorlagen
* Projektstarter
* Modulvorlagen
* vorkonfigurierte Grundstrukturen

Beispiele:

```text
Eigenverft.Templated.Agents
Eigenverft.Templated.PowerShellModule
Eigenverft.Templated.WebService
Eigenverft.Templated.Repository
```

`Templated` ist besser als `Seeded`, weil:

* es direkt verständlich ist,
* es zur bestehenden Adjektiv-/Partizipstruktur passt,
* es keine zusätzliche metaphorische Bedeutung lernen lässt,
* es eindeutig auf Templates verweist.

---

## `Profile`

Für deklarative, direkt verwendbare Konfigurationsprofile.

Dazu gehören:

* Windows-Sandbox-Dateien
* Environment-Profile
* Bootstrap-Konfigurationen
* Hostprofile
* vorkonfigurierte Laufzeitumgebungen

Beispiele:

```text
Eigenverft.Profile.WindowsSandbox
Eigenverft.Profile.DeveloperMachine
Eigenverft.Profile.AgentWorkspace
```

Ein `.wsb`-Produkt ist ein `Profile`, auch wenn es beim Start PowerShell verwendet.

---

## `Integration`

Für Adapter und Verbindungen zu externen Systemen.

Dazu gehören:

* GitHub-Adapter
* MCP-Integrationen
* NuGet-Provider
* externe Paketquellen
* Protokolladapter
* API-Brücken

Beispiele:

```text
Eigenverft.Integration.GitHub
Eigenverft.Integration.Mcp
Eigenverft.Integration.NuGet
Eigenverft.Integration.HuggingFace
```

`Integration` sollte nur verwendet werden, wenn das Produkt primär ein vorhandenes externes System anbindet.

---

## `Infrastructure`

Für technische Infrastrukturkomponenten, die weder normale Library noch Endnutzerprodukt sind.

Dazu gehören:

* Deployment-Infrastruktur
* Build-Infrastruktur
* Paketdepots
* interne Hosting-Grundlagen
* Provisionierungs-Backends
* organisationsweite technische Plattformkomponenten

Beispiele:

```text
Eigenverft.Infrastructure.PackageDepot
Eigenverft.Infrastructure.BuildPipeline
Eigenverft.Infrastructure.CertificateAuthority
```

Nicht jede interne Bibliothek gehört hierher. Die Infrastrukturrolle muss die öffentliche Produktidentität sein.

---

## `Archived`

Für historische und nicht mehr aktiv entwickelte Inhalte.

Beispiele:

```text
Eigenverft.Archived.Legacy
Eigenverft.Archived.Bootstrapper
Eigenverft.Archived.RoutedCore
```

`All` sollte nicht als Produktname verwendet werden.

---

# 4. Kategorien, die nicht empfohlen werden

## `App`

Zu unspezifisch, weil darunter fallen könnten:

* Webanwendungen
* Desktopanwendungen
* Server
* CLIs
* Worker
* Hintergrunddienste

Ersetzen durch:

```text
Service
Web
Desktop
Tool
```

---

## `Guarded`

Beschreibt einen Sicherheitszweck, aber keine Produktform.

Besser:

```text
Eigenverft.Library.ProcessIsolation.RestrictedToken
Eigenverft.Service.PolicyEnforcement
Eigenverft.Tool.SecurityAudit
```

Die Sicherheitsinformation steht im Produktnamen, nicht zwingend in der Kategorie.

---

## `Marshaled`

Beschreibt eine Implementierungstechnik.

Besser:

```text
Eigenverft.Library.NativeInterop
Eigenverft.Library.ProcessIsolation.RestrictedToken
```

`Marshaled` könnte als vierte Variante verwendet werden, falls es tatsächlich mehrere Implementierungsarten gibt:

```text
Eigenverft.Library.ProcessExecution.Marshaled
```

Aber auch dort sollte ein fachlich konkreter Begriff bevorzugt werden.

---

## `Composed`

Zu abstrakt für eine technische Kategorie.

Es ist nicht erkennbar, ob es sich handelt um:

* eine Library,
* einen Service,
* ein Tool,
* ein Template,
* eine Anwendung.

Besser:

```text
Eigenverft.Library.Configuration
Eigenverft.Library.Validation
```

---

## `Seeded`

Stilistisch passend, aber unnötig indirekt.

Besser:

```text
Eigenverft.Templated.Agents
```

---

## `Provisioned`

Kann für einen Vorgang oder Zustand stehen, sagt aber nicht eindeutig, was ausgeliefert wird.

Für konkrete Produkte sind präzisere Namen besser:

```text
Eigenverft.Profile.WindowsSandbox
Eigenverft.Tool.MachineProvisioning
Eigenverft.Module.Provisioning
Eigenverft.Service.Provisioning
```

---

# 5. Produkt- und Variantensegmente

Die notwendige fachliche Differenzierung erfolgt nach der Kategorie.

## Produktsegment

Das Produktsegment beschreibt die stabile Fähigkeit:

```text
ProcessIsolation
RequestFilters
McpServer
ReverseProxy
Drydock
Package
Agent
WindowsSandbox
```

## Variantensegment

Das Variantensegment beschreibt eine echte technische Alternative:

```text
RestrictedToken
AppContainer
AspNetCore
Sqlite
Windows
Linux
```

Es wird nur ergänzt, wenn mindestens zwei Varianten existieren oder absehbar sind.

Beispiele:

```text
Eigenverft.Library.ProcessIsolation.RestrictedToken
Eigenverft.Library.ProcessIsolation.AppContainer
```

Nicht nötig:

```text
Eigenverft.Library.RequestFilters.AspNetCore
```

wenn es keine andere RequestFilters-Implementierung gibt und ASP.NET Core ohnehin die gesamte Produktidentität bestimmt.

In diesem Fall reicht:

```text
Eigenverft.Library.RequestFilters
```

---

# 6. Überarbeitete Namen im Workspace

| Aktueller Name                                  | Optimierter Name                                      | Begründung                            |
| ----------------------------------------------- | ----------------------------------------------------- | ------------------------------------- |
| `Eigenverft.App.BlazorMultihost`                | `Eigenverft.Service.BlazorMultiHost`                  | Hosting-/Serverfunktion               |
| `Eigenverft.App.GlobalServerPwaHost`            | `Eigenverft.Web.GlobalPortal`                         | Falls das Browserprodukt dominiert    |
| `Eigenverft.App.GlobalServerPwaHost`            | `Eigenverft.Service.GlobalServer`                     | Falls Backend und Hosting dominieren  |
| `Eigenverft.App.LlamaRunner`                    | `Eigenverft.Tool.LlamaRunner`                         | CLI                                   |
| `Eigenverft.App.McpServer`                      | `Eigenverft.Service.McpServer`                        | dauerhaft laufender Server            |
| `Eigenverft.App.ReverseProxy`                   | `Eigenverft.Service.ReverseProxy`                     | laufender Netzwerkdienst              |
| `Eigenverft.Archive.All`                        | `Eigenverft.Archived.Legacy`                          | klare Archivbezeichnung               |
| `Eigenverft.Distributed.Drydock`                | `Eigenverft.Tool.Drydock`                             | .NET Tool                             |
| `Eigenverft.Manifested.Agent`                   | `Eigenverft.Module.Agent`                             | PowerShell-Modul                      |
| `Eigenverft.Manifested.Drydock`                 | `Eigenverft.Module.Drydock`                           | PowerShell-Modul                      |
| `Eigenverft.Manifested.Package`                 | `Eigenverft.Module.Package`                           | PowerShell-Modul                      |
| `Eigenverft.Manifested.Sandbox`                 | `Eigenverft.Profile.WindowsSandbox`                   | `.wsb`-Profil                         |
| `Eigenverft.Routed.RequestFilters`              | `Eigenverft.Library.RequestFilters`                   | wiederverwendbare Middleware-Library  |
| `Eigenverft.Template.Agents`                    | `Eigenverft.Templated.Agents`                         | Template-Sammlung                     |
| `Eigenverft.Windows.ProcessIsolationRestricted` | `Eigenverft.Library.ProcessIsolation.RestrictedToken` | Library plus konkrete Implementierung |
| `Eigenverft.Windows.ProcessIsolationSandbox`    | `Eigenverft.Library.ProcessIsolation.AppContainer`    | Library plus konkrete Implementierung |

---

# 7. Empfohlene Zielstruktur

```text
eigenverft

Eigenverft.Service.BlazorMultiHost
Eigenverft.Web.GlobalPortal
Eigenverft.Service.McpServer
Eigenverft.Service.ReverseProxy

Eigenverft.Tool.LlamaRunner
Eigenverft.Tool.Drydock

Eigenverft.Module.Agent
Eigenverft.Module.Drydock
Eigenverft.Module.Package

Eigenverft.Profile.WindowsSandbox

Eigenverft.Library.RequestFilters
Eigenverft.Library.ProcessIsolation.RestrictedToken
Eigenverft.Library.ProcessIsolation.AppContainer

Eigenverft.Templated.Agents

Eigenverft.Archived.Legacy
```

---

# 8. Kompakte Kategorienliste

```text
Service         Backend, Server, API, Worker
Web             Browseranwendung, Portal, PWA
Desktop         native Desktopanwendung
Tool            CLI und eigenständiges Entwicklerwerkzeug
Module          PowerShell-Modul
Library         wiederverwendbares Codepaket
Templated       Templates und Scaffolding
Profile         deklaratives Laufzeit- oder Environment-Profil
Integration     Adapter zu externen Systemen
Infrastructure  technische Plattform- und Betriebsinfrastruktur
Archived        historische Inhalte
```

Diese Liste liefert mehr Differenzierung als `App`, bleibt aber verständlicher als eine Taxonomie aus vielen Kunstbegriffen.

---

# 9. Endgültige Empfehlung

Die beste Eigenverft-Konvention ist kein rein generisches Modell und auch kein reines Kunstnamensystem.

Sie ist ein kontrolliertes technisches Kategoriensystem:

```text
Eigenverft.<PreciseCategory>.<Product>[.<Variant>]
```

Dabei gilt:

* Standardbegriffe werden verwendet, wenn sie präzise sind.
* Ein Kunstname wird nur verwendet, wenn er mehr Information liefert als ein etablierter technischer Begriff.
* `Library` ist besser als `Guarded`, wenn ein konsumierbares Codepaket gemeint ist.
* `Templated` ist besser als `Seeded`, weil die Bedeutung unmittelbar erkennbar bleibt.
* Fachliche Zwecke wie Sicherheit, Routing oder Isolation gehören überwiegend in den Produktnamen.
* Die Kategorie muss den Konsum- und Ausführungsmodus erkennen lassen.
