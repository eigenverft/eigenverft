# Legacy der Eigenverft-Namenskonvention

> **Status:** Historische Dokumentation. Dieses Dokument ist nicht verbindlich.
>
> Die aktuelle und maßgebliche Konvention steht in [`Eigenverft Naming Convention NEW.md`](./Eigenverft%20Naming%20Convention%20NEW.md).

## Zweck dieses Dokuments

Dieses Dokument fasst die beiden früheren Entwürfe zur Benennung von Eigenverft-Projekten, Paketen und Namespaces zusammen:

- `Eigenverft Project and Namespace Naming Specification.md`
- `nameconvention.md`

Die Originaldateien wurden entfernt, weil sie sich gegenseitig und der aktuellen Konvention in wesentlichen Punkten widersprachen. Ihre fachliche Absicht und die Entwicklung des Benennungssystems bleiben hier nachvollziehbar.

## Gemeinsamer Kern der früheren Entwürfe

Beide Entwürfe wollten ein konsistentes Schema für Repository-, Projekt-, Paket-, Assembly- und Namespace-Namen schaffen. Dauerhaft übernommen wurden insbesondere folgende Grundideen:

- `Eigenverft` ist der feste Marken- und Root-Namespace.
- Jeder Name enthält eine erkennbare Produkt- oder Fähigkeitsbezeichnung.
- Projektname und Root-Namespace sollen denselben vollständigen Stamm verwenden.
- Namen werden in PascalCase geschrieben.
- Produktnamen sollen konkret und fachlich verständlich sein.
- Unscharfe Begriffe wie `Common`, `Shared`, `Misc`, `New` oder `All` sollen vermieden werden.
- Erweiterungen wie Tests, Benchmarks oder konkrete Varianten werden an einen stabilen Produktstamm angehängt.
- Die öffentliche Verwendung eines Artefakts ist wichtiger als seine interne Implementierung.

## Erste Phase: markenbasierte Produktfamilien

Die Datei `Eigenverft Project and Namespace Naming Specification.md` definierte das Schema:

```text
Eigenverft.<Family>.<Project>[.<Subqualifier>]
```

Die zweite Namenskomponente war eine Eigenverft-spezifische Produktfamilie. Vorgesehen waren unter anderem:

| Frühere Familie | Gedachte Bedeutung |
|---|---|
| `Unified` | breit kompatible oder .NET-Standard-basierte Bibliotheken |
| `Composed` | allgemeine Bibliotheken für modernes .NET |
| `Marshaled` | Windows-spezifische moderne Bibliotheken |
| `Routed` | ASP.NET Core, HTTP und Request-Pipelines |
| `Bladed` | Razor, UI und Präsentation |
| `Manifested` | PowerShell-Module |
| `Distributed` | CLI-Anwendungen und .NET Tools |
| `Forged` | MSBuild- und Build-Integration |
| `Seeded` | Templates und Starterprojekte |
| `Legacy.NetFx2` | Projekte für .NET Framework 2.x |
| `Legacy.NetFx4` | Projekte für .NET Framework 4.x |

Zusätzlich wurden die breiten Projektnamen `Primitives`, `Extensions` und `Integrations` reserviert. Sie sollten gemeinsame Bibliothekslinien anhand ihrer Abhängigkeiten gliedern:

```text
Eigenverft.Unified.Primitives.Serialization
Eigenverft.Composed.Extensions.Hosting
Eigenverft.Routed.Integrations.Swashbuckle
```

### Sinn dieses Ansatzes

Der Entwurf sollte der Eigenverft-Produktlandschaft eine eigene, wiedererkennbare Sprache geben. Er gruppierte Projekte nach Ökosystem, Laufzeitgeneration oder technischer Ausrichtung und machte verwandte Produktlinien optisch zusammengehörig.

### Grenzen dieses Ansatzes

Die Familiennamen waren ohne Zusatzwissen nicht unmittelbar verständlich. Außerdem vermischten sie unterschiedliche Dimensionen:

- Zielplattform,
- Laufzeitgeneration,
- technische Domäne,
- Konsumform,
- interne Implementierung.

So war beispielsweise aus `Distributed` nicht eindeutig erkennbar, ob ein normales CLI-Programm, ein .NET Tool oder ein verteiltes System gemeint war. `Marshaled` beschrieb eher eine Implementierungstechnik als die öffentliche Produktart.

## Zweite Phase: technische Kategorien

Die Datei `nameconvention.md` ersetzte die Kunstnamen weitgehend durch unmittelbar verständliche technische Kategorien. Das vorgeschlagene Schema war:

```text
Eigenverft.<Category>.<Product>[.<Variant>]
```

Zu den vorgeschlagenen Kategorien gehörten:

```text
Service
Web
Desktop
Tool
Module
Library
Templated
Profile
Integration
Infrastructure
Archived
```

Der zentrale Gedanke lautete:

> Die zweite Namenskomponente soll zeigen, wie ein Produkt verwendet, ausgeführt oder eingebunden wird.

Beispiele dieses Übergangsentwurfs waren:

```text
Eigenverft.Service.McpServer
Eigenverft.Web.GlobalPortal
Eigenverft.Tool.Drydock
Eigenverft.Module.Agent
Eigenverft.Library.RequestFilters
Eigenverft.Library.ProcessIsolation.RestrictedToken
Eigenverft.Profile.WindowsSandbox
Eigenverft.Templated.Agents
Eigenverft.Archived.Legacy
```

### Sinn dieses Ansatzes

Der Entwurf machte die Namen ohne Eigenverft-spezifisches Vorwissen verständlicher. Er trennte insbesondere:

- Backenddienste von Browser- und Desktopanwendungen,
- PowerShell-Module von eigenständigen Programmen,
- Templates von Laufzeitprodukten,
- Profile von ausführbarem Code,
- Produktfunktion von Implementierungsdetails.

Er enthielt außerdem eine erste konkrete Zuordnung bestehender Workspace-Namen zu einer technisch klareren Zielstruktur.

### Grenzen dieses Ansatzes

Einige Kategorien waren noch zu breit oder vermischten weiterhin verschiedene Kriterien:

- `Tool` fasste direkte CLI-Anwendungen und über `dotnet tool` installierte Produkte zusammen.
- `Library` unterschied weder neutrale, moderne, web-, desktop-, Windows- noch Interop-spezifische Verträge.
- `Integration` beschrieb häufig eine Produktdomäne statt die technische Konsumform.
- `Infrastructure` war eine organisatorische Rolle und keine eindeutige Artefaktart.
- `Templated` und `Archived` beschrieben einen Zustand beziehungsweise eine Partizipform statt einer stabilen Kategorie.
- Build-Time-Artefakte und Source Generatoren waren noch nicht sauber getrennt.

## Übergang zur aktuellen Konvention

Die aktuelle Konvention übernimmt den verständlichen technischen Ansatz, verfeinert ihn aber durch eine feste Whitelist und eindeutige Präzedenzregeln.

Die wichtigsten historischen Übergänge sind:

| Frühere Bezeichnung | Aktuelle Einordnung |
|---|---|
| `Unified` | meistens `Lib` |
| `Composed` | meistens `NetLib` |
| `Marshaled` | je nach öffentlichem Vertrag `WinLib`, `InteropLib` oder `DesktopLib` |
| `Routed` | je nach Produkt `Web`, `Service` oder `WebLib` |
| `Bladed` | je nach Produkt `Web`, `BlazorLib`, `WebLib` oder `DesktopLib` |
| `Manifested` | `Module` |
| `Distributed` | `Cli` oder `Tool` |
| `Forged` | `Build` oder `Generator` |
| `Seeded` / `Templated` | `Templates` |
| `Library` | `Lib`, `NetLib`, `WebLib`, `BlazorLib`, `DesktopLib`, `WinLib`, `InteropLib` oder passende `*FxLib`-Kategorie |
| `Archived` | `Archive` |
| `Legacy.NetFx2` / `Legacy.NetFx4` | passende `CliFx`- oder `*FxLib`-Kategorie; konkrete Frameworkversion bleibt Metadatum |

Die aktuelle Konvention trennt außerdem ausdrücklich:

```text
Cli       direkt veröffentlichtes modernes Kommandozeilenprodukt
Tool      über dotnet tool installiertes Produkt
CliFx     Kommandozeilenprodukt für klassisches .NET Framework
Build     MSBuild-Tasks, Targets, Props und Build-Pakete
Generator Roslyn Source Generator
```

## Historische Bewertung

Die beiden alten Dokumente waren notwendige Entwicklungsschritte:

1. Das Familiensystem schuf eine eigenständige Eigenverft-Identität und stabile Produktlinien.
2. Der technische Übergangsentwurf verbesserte Verständlichkeit und ordnete bestehende Workspace-Projekte neu ein.
3. Die aktuelle Konvention vereinheitlicht beide Ziele durch verständliche, technisch präzise und verbindlich begrenzte Kategorien.

Die früheren Namen können weiterhin in Git-Historie, alten Paketnamen, Repository-Verweisen oder historischen Releases vorkommen. Für neue Namen und Umbenennungen sind sie jedoch nicht mehr maßgeblich.
