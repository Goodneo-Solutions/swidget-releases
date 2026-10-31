# 0.2.0

## Web

### Websites
- **One package**: the web runtime that Superroute served as sWidget 0.2.0 (tracking, quote, shipping order and pickup point widgets on a client's own website, the `window.sWidget` JavaScript API, named errors, styling hooks and accessibility) now comes from the npm package `@superrouteca/swidget`, with the ES module and the script-tag bundle built from the same source.
- **Configuration version**: a widget whose configuration is newer than the runtime says so (`widget_unsupported`) instead of drawing nothing.
- **Payment and sign-in events**: a guest order raises `swidget:payment` when its payment link is ready, and a signed-in order raises `swidget:sign-in-required` when the person must sign in again.

### Back office
- **Staff entries**: the same widgets run inside the Superroute back office on the person's own session, with no key or token in the page.
- **Orders by staff**: the order widget asks whether the order is for an existing customer (search by name, email or customer code, then the order form as that customer) or for a walk-in guest (the guest confirms a code sent to their phone or email; the payment link goes to the guest, never to the screen).

### Web apps
- **Widgets in a web app**: `SWidget.app(…)` loads a widget by its id on the app's own sApp connection (alone or over the app's sApp client) and draws it with `SWidget.mount` or `<sr-swidget widget-id>`; the configuration is kept 24 hours in the browser tab so a widget still draws offline.
- **Look from the back office**: the corner radius and the light, dark or automatic mode set in the designer apply on websites too; a page's own settings still win.
- **`SWidget.web`**: the ES module draws a website widget in one call.

### Designer preview
- **Unsaved changes**: a preview draws the configuration being edited before it is saved.
- **Nothing is written**: steps that would write (prices, confirmation codes, orders, cancellations, labels, signing in) show a sample answer marked Preview.

## Apps

### iOS, macOS, Android and Windows
- **Widgets in an app**: SwiftUI (`SwidgetView`), Jetpack Compose (`Swidget`), WPF and Windows Forms (`SwidgetControl`) load a widget by its id on the app's own sApp connection, on its own or beside the sApp client the app already has, and draw tracking, quotes, guest and signed-in shipping orders and the pickup point picker from the sApp and sLocker kits.
- **Branding and language**: the widget's colour, corner radius, light or dark mode and language from the back office, unless the app gives its own mode, accent colour, theme or language.
- **Offline**: the last good configuration is kept for 24 hours in the device's secure storage, so a widget still draws without a connection.
- **Refusals and events**: a widget that is unknown, revoked, not enabled for the app, missing a capability or newer than the app shows its own state; every package raises the same events (ready, select, quoted, created, cancelled, payment, sign-in required, open URL, file, error).

### React, React Native and Flutter
- **Widgets in an app**: React and React Native (`<Swidget widgetId>`) and Flutter (`SrSwidget(widgetId:)`) load a widget by its id on the app's own sApp connection and draw tracking, quotes, guest and signed-in shipping orders and the pickup point picker from the sApp and sLocker kits, with the same branding, offline, refusal and event behaviour as the other apps.
