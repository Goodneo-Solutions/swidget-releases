# sWidget

Widgets configured once in the Superroute back office, drawn wherever they are needed. A client sets up a widget —
parcel tracking, a price quote, a shipping order or a pickup point picker — with its options, branding and language,
and loads it by its id: on its own website, in the back office for its staff, and (from the native packages on) in an
app on any of sApp's nine platforms. The widget's flow, its branding and its language come from the back office; the
server keeps deciding what each caller may do.
Superroute SDK License — see [LICENSE](LICENSE) and [open.superroute.ca/developer/license](https://open.superroute.ca/developer/license).

Documentation: [open.superroute.ca/developer/swidget](https://open.superroute.ca/developer/swidget). This repository
carries the releases: the web files with their checksums, and from the native packages on the Swift packages, the
Maven repository and the example apps.

| Package | Platform | Install |
|---|---|---|
| `@superrouteca/swidget` (npm) | Web: ES module, Web Components and the script-tag bundle | `npm install @superrouteca/swidget` |
| `/swidget/swidget.js` (served by Superroute) | Any website, one script tag | the snippet from the back office |

The packages for React, React Native, Flutter, SwiftUI, Jetpack Compose, WPF and WinForms follow the same
[specification](https://open.superroute.ca/developer/swidget) and carry the same version as the web package.

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
        data-key="sp_appkey_…" data-client="k3m9q2" data-api="https://open.superroute.ca" async></script>
```

Pages that draw widgets themselves use the ES module or `window.sWidget`:

```js
import { mount, on, defineWidgetElements } from '@superrouteca/swidget';

defineWidgetElements();
await mount('#checkout-pickup', { widget: 'abc123def456', key: 'sp_appkey_…', client: 'k3m9q2', inputName: 'pickup_point' });
on('select', ({ pickup_point }) => console.log(pickup_point.id));
```

Optional settings: `locale` (one of the 14 languages), `theme` (`light`, `dark`, `auto`), `accent` (`#RRGGBB`) and,
for the pickup point picker, `inputName`. Styling: the `--swidget-*` custom properties and `::part()` names listed in
the [specification](https://open.superroute.ca/developer/swidget).

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
composed) and `window.sWidget.on(name, handler)`. See [open.superroute.ca/developer/swidget](https://open.superroute.ca/developer/swidget).

## Versions

Every package of a release carries the same version. Each release adds 0.0.1 and skips any number that contains a 3 or
a 4. The web file served at `/swidget/swidget.js` has no version in its URL: each release replaces it, and its version
is in the file's banner and in `window.sWidget.version`.
