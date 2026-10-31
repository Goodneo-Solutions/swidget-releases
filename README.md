# sWidget

Widgets configured once in the Superroute back office, drawn wherever they are needed. A client sets up a widget —
parcel tracking, a price quote, a shipping order or a pickup point picker — with its options, branding and language,
and loads it by its id: on its own website, in the back office for its staff, and (from the native packages on) in an
app on any of sApp's nine platforms. The widget's flow, its branding and its language come from the back office; the
server keeps deciding what each caller may do.
Superroute SDK License — see [LICENSE](LICENSE) and [open.superroute.ca/developer/license](https://open.superroute.ca/developer/license).

Documentation: [open.superroute.ca/developer/swidget](https://open.superroute.ca/developer/swidget). Releases, the
Swift packages, the Maven repository and the example apps: [Goodneo-Solutions/swidget-releases](https://github.com/Goodneo-Solutions/swidget-releases).

| Package | Platform | Install |
|---|---|---|
| `@superrouteca/swidget` (npm) | Web: ES module, Web Components and the script-tag bundle | `npm install @superrouteca/swidget` |
| `/swidget/swidget.js` (served by Superroute) | Any website, one script tag | the snippet from the back office |
| `SWidget` (Swift package, swidget-releases) | iOS 15+ and macOS 12+, SwiftUI | `https://github.com/Goodneo-Solutions/swidget-releases` |
| `ca.superroute:swidget-android` (Maven) | Android, Jetpack Compose | the Maven repository `https://goodneo-solutions.github.io/swidget-releases/maven` |
| `Superroute.SWidget`, `.Wpf`, `.WinForms` (NuGet) | Windows, WPF and Windows Forms | `dotnet add package Superroute.SWidget.Wpf` |
| `@superrouteca/swidget-react` (npm) | React | `npm install @superrouteca/swidget-react` |
| `@superrouteca/swidget-react-native` (npm) | React Native | `npm install @superrouteca/swidget-react-native` |
| `swidget_flutter` (pub.dev) | Flutter | `flutter pub add swidget_flutter` |

The packages for React, React Native, Flutter, SwiftUI, Jetpack Compose, WPF and WinForms follow the same
[specification](SWIDGET-SPEC.md) and carry the same version as the web package.

## What it covers

- **Tracking** — look a parcel up by its tracking number or order reference and follow its status and history.
- **Quote** — price a shipment on the client's public quote lines (local delivery, pickup, point to point, shipping,
  express).
- **Shipping order** — as a guest (a code confirms the email or phone number, then payment and follow-up: cancel,
  label, the guest's shipments) or as a signed-in customer of the client.
- **Pickup point** — choose one of the client's smart lockers or staffed pickup points; the choice goes to the page.

## On a website

The back office generates the snippet: a container and one script tag with the widget's public key, which works only
on the websites listed on the widget.

```html
<div id="swidget-abc123def456"></div>
<script src="https://admin.example.com/swidget/swidget.js" data-swidget="abc123def456"
        data-key="<widget key>" data-client="k3m9q2" data-app="swidget" data-api="https://api.superroute.ca" async></script>
```

The widget runs on Superroute's own API host (`data-api`, the client's own API host or `https://api.superroute.ca`) as
the app `swidget` (`data-app`). Snippets pasted before 0.2.1 (no `data-app`, `data-api` on the open host) keep working:
their first call reads the configuration on the open host, and its answer moves every later call to the API host. A
signed-in order widget shows its own e-mail and password sign-in (with a code step when the account asks for one),
"Create an account" when the client takes sign-ups, and "Forgot password" when the client has a reset page.

Pages that draw widgets themselves use the ES module or `window.sWidget`:

```js
import { mount, on, defineWidgetElements } from '@superrouteca/swidget';

defineWidgetElements();
await mount('#checkout-pickup', { widget: 'abc123def456', key: '<widget key>', client: 'k3m9q2', app: 'swidget', api: 'https://api.superroute.ca', inputName: 'pickup_point' });
on('select', ({ pickup_point }) => console.log(pickup_point.id));
```

Optional settings: `locale` (one of the 14 languages), `theme` (`light`, `dark`, `auto`), `accent` (`#RRGGBB`) and,
for the pickup point picker, `inputName`. Styling: the `--swidget-*` custom properties and `::part()` names listed in
the [specification](SWIDGET-SPEC.md#styling).

## In the back office

Superroute's back office draws a widget whose Staff channel is on at `/staff-widgets/{id}` with the session
transport: every call goes to the back office on the person's own session and CSRF token, with no key and no token in
the page.

```js
await mount(element, { transport: 'session', widget: '12', config: inlineConfig });
```

The order widget asks first whether the order is for an existing customer or for a walk-in guest.

## Designer preview

The widget designer draws the unsaved draft with a preview ticket bound to it. A preview only reads: steps that would
write show a sample answer marked **Preview**.

```js
await mount(element, { widget, key, client, api, preview: ticket, draftHash, draft });
```

## Events and errors

Every platform raises the same events — `ready`, `select`, `quoted`, `created`, `cancelled`, `payment`,
`signInRequired`, `error` — and names every refusal with a code. On the web they are `swidget:*` DOM events (bubbling,
composed) and `window.sWidget.on(name, handler)`. See [SWIDGET-SPEC.md](SWIDGET-SPEC.md).

## In an app

An app loads a widget by its id on its own sApp connection: the app key before sign-in, its user's token after. Start
sWidget on its own (`SWidget.app(…)` makes the sApp partner connection) or over the sApp client the app already has
(`SWidget.forSapp(sr)`, one sign-in for both). The widget draws the sApp and sLocker kit components — tracking,
`GuestQuote`, `GuestShippingOrder`, `ShippingOrderForm`, the locker map on the client's pickup points — in the widget's
branding (colour, corner radius, light or dark) and language unless the app passes its own `mode`, `accent`, `theme` or `locale`; a guest shipment's label reaches the app as the `file` event. The last good configuration is kept
for 24 hours in secure storage (Keychain, Android Keystore, Windows DPAPI) so a widget draws offline.

```swift
import SWidget

let widgets = SWidget.app(appCode: "p_acme_parcels", clientCode: "k3m9q2", appKey: appKey)
SwidgetView(widgetId: "abc123def456", client: widgets) { event in
    if case .payment(_, let url) = event { openURL(url) }
}
```

```kotlin
val widgets = SWidget.forSapp(context, sr)
Swidget(widgetId = "abc123def456", client = widgets) { event -> if (event is SwidgetEvent.SignInRequired) signIn() }
```

```csharp
var model = new SwidgetViewModel(SWidget.ForSapp(sr), "abc123def456");
model.Payment += e => Process.Start(new ProcessStartInfo((string)e.Detail["pay_url"]!) { UseShellExecute = true });
host.Content = new SwidgetControl(model);   // Superroute.SWidget.Wpf or .WinForms
```

A widget refused for the app (`widget_not_found` 404, `widget_not_enabled_for_app` 403, `widget_revoked` 410), one
whose capabilities the app lacks (`unavailable`) and one newer than the package (`widget_unsupported`) each draw their
own state and raise `error`; a sign-in order widget asks the app to sign the person in (`signInRequired`) and follows
the sApp session.

## Versions

Every package of a release carries the same version. Each release adds 0.0.1 and skips any number that contains a 3 or
a 4. The web file served at `/swidget/swidget.js` has no version in its URL: each release replaces it, and its version
is in the file's banner and in `window.sWidget.version`.

## Repository

| Folder | What |
|---|---|
| `web/` | `@superrouteca/swidget`: the source (`src/`), its jsdom tests (`test/`) and the build (`build.mjs`) |
| `tools/release/build-web.sh` | builds `swidget.js`, `swidget.esm.js` and `SHA256SUMS` for a release |
| `swift/` | the Swift package `SWidget` (SwiftUI) and its tests |
| `kotlin/` | `ca.superroute:swidget-android` (Jetpack Compose) and its Robolectric tests |
| `dotnet/` | `Superroute.SWidget`, `.Wpf`, `.WinForms` and their xunit tests |
| `react/`, `react-native/` | `@superrouteca/swidget-react`, `@superrouteca/swidget-react-native` (on `@superrouteca/swidget/core`) and their tests |
| `flutter/` | the Flutter package `swidget_flutter` and its tests |
| `tests/cases/`, `tools/make_cases.py` | the shared cases every language runs (SWIDGET-SPEC.md §7) |
| `tools/native/` | the string tables of the native packages (`strings.mjs`), generated from the web runtime's |
| `tools/release/build-swift-xcframeworks.sh`, `write-swidget-releases-repo.sh` | the Swift binary package and its `Package.swift` for swidget-releases |
| `.github/workflows/release.yml` | publishes every package of a release when its version tag is pushed |
| `SWIDGET-SPEC.md` | the contract every platform follows: configuration, transports, events, error codes |

```sh
cd web && npm ci && npm test && npm run build      # dist/swidget.js, dist/swidget.esm.js
tools/release/build-web.sh out/                    # the release files with their checksums
```

### Native packages

sWidget 0.2.1 is built on sApp 0.2.5 (`GuestQuote`, `GuestShippingOrder`) and sLocker 0.2.1 (the locker map's pickup
point source), from their public releases: Swift from `sapp-releases` and `slocker-customer-releases`, Kotlin from the
sApp and sLocker Maven repositories, .NET from nuget.org.

```sh
(cd swift && swift test)
(cd kotlin && ./gradlew :swidget-android:testDebugUnitTest)
dotnet test dotnet/tests/Superroute.SWidget.Tests/Superroute.SWidget.Tests.csproj
node tools/native/strings.mjs            # after a change of web/src/strings.js or tools/native/strings-native.json
```

### JavaScript and Flutter packages

The React and React Native packages depend on `@superrouteca/sapp` 0.2.5 with `@superrouteca/sapp-react` /
`sapp-react-native` 0.2.5 and `@superrouteca/slocker-react` / `slocker-react-native` 0.2.1 from npm; the Flutter
package on `sapp` and `sapp_ui` ^0.2.5 and `slocker_ui` ^0.2.1 from pub.dev. The root `package.json` makes `react/` and
`react-native/` npm workspaces and points `@superrouteca/swidget` at `web/`, so they are tested against the web package
of the same commit. `web/` stays outside the workspace and builds from its own lockfile.

```sh
npm install && npm test                # react, react-native
(cd flutter && flutter pub get && flutter analyze && flutter test)
(cd web && npm test)                   # includes the shared cases
```

### Release

Pushing a version tag (`0.2.0`, no `v`) runs `.github/workflows/release.yml`. It refuses a version with a 3 or a 4 and
any package whose version is not the tag's, then publishes:

- npm (trusted publishing): `@superrouteca/swidget` first (the React packages depend on its `./core`), then
  `@superrouteca/swidget-react` and `@superrouteca/swidget-react-native`;
- pub.dev (automated publishing): `swidget_flutter`;
- nuget.org (trusted publishing): `Superroute.SWidget`, `Superroute.SWidget.Wpf`, `Superroute.SWidget.WinForms`;
- Goodneo-Solutions/swidget-releases (deploy key `RELEASES_DEPLOY_KEY`): the `SWidget` XCFramework and its
  `Package.swift`, the Maven repository (`ca.superroute:swidget-android`) and the web files (`web/<version>/`) with
  their `SHA256SUMS`; that repository's own workflow makes the GitHub Release and the tag SwiftPM resolves.

A version already published is skipped, so the workflow can be run again (`workflow_dispatch` with the tag).

