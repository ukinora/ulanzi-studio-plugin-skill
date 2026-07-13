# GitHub Copilot Instructions - Ulanzi Studio Plugin Development
# Place this file at .github/copilot-instructions.md in your project.
# Reference: https://github.com/ukinora/ulanzi-studio-plugin-skill

# Ulanzi Studio Plugin Development

Build plugins for Ulanzi D200H / D200 / D200X stream controllers using the Ulanzi Studio SDK.

TRIGGER when: user asks to create a Ulanzi Studio plugin/app, build a stream deck action, or modify an existing Ulanzi plugin.

## Plugin Architecture

Two runtime modes (choose one per plugin):

| Mode | Entry Point | Use Case |
|------|------------|----------|
| **HTML** | `plugin/app.html` | Canvas drawing, UI-driven, simpler setup |
| **Node.js** | `plugin/app.js` | System access, file I/O, complex logic |

## Directory Structure

```
com.ulanzi.{name}.ulanziPlugin/
  manifest.json                      # Plugin metadata (REQUIRED)
  plugin/
    app.html                         # Entry point (HTML mode)
    app.js                           # Main logic
    actions/
      {action}.js                    # Action class
  property-inspector/
    config/
      inspector.html                 # Settings UI
      inspector.js                   # Settings logic
  libs/
    js/
      constants.js                   # Event constants
      eventEmitter.js                # Pub/sub system
      timers.js                      # Web Worker timers
      utils.js                       # Utilities (fetch, form, canvas)
      ulanzideckApi.js               # SDK API ($UD object)
    css/
      udpi.css                       # Property Inspector styling
    assets/                          # UI icons (svg)
  assets/
    icons/
      icon.png                       # Plugin icon (72x72)
      categoryIcon.png               # Category icon (72x72)
      actionDefaultImage.png         # Default key image (196x196)
  en.json                            # English localization
  ko_KR.json                         # Korean localization
  zh_CN.json                         # Chinese localization
```

## manifest.json Schema

```json
{
  "Version": "1.0.0",
  "Author": "AuthorName",
  "Name": "Plugin Name",
  "Description": "Short description",
  "Icon": "assets/icons/icon.png",
  "Category": "Category Name",
  "CategoryIcon": "assets/icons/categoryIcon.png",
  "CodePath": "plugin/app.html",
  "Type": "JavaScript",
  "SupportedInMultiActions": false,
  "PrivateAPI": true,
  "UUID": "com.ulanzi.ulanzideck.{pluginName}",
  "Actions": [
    {
      "Name": "Action Name",
      "Icon": "assets/icons/icon.png",
      "PropertyInspectorPath": "property-inspector/config/inspector.html",
      "state": 0,
      "States": [
        { "Image": "assets/icons/actionDefaultImage.png" }
      ],
      "Tooltip": "Action tooltip",
      "UUID": "com.ulanzi.ulanzideck.{pluginName}.{actionName}",
      "SupportedInMultiActions": false
    }
  ],
  "OS": [
    { "Platform": "windows", "MinimumVersion": "10" },
    { "Platform": "mac", "MinimumVersion": "10.11" }
  ],
  "Software": { "MinimumVersion": "6.1" }
}
```

**UUID rules:**
- Plugin UUID: 4 dot-separated segments (`com.ulanzi.ulanzideck.myPlugin`)
- Action UUID: 5+ segments (`com.ulanzi.ulanzideck.myPlugin.myAction`)

## SDK API Reference ($UD)

### Connection

```javascript
$UD.connect('com.ulanzi.ulanzideck.myPlugin')  // Plugin main service
$UD.connect('com.ulanzi.ulanzideck.myPlugin.myAction')  // Property inspector
```

### Event Handlers

| Method | Fires When | Callback Data |
|--------|-----------|---------------|
| `onConnected(fn)` | WebSocket connected | `{}` |
| `onAdd(fn)` | Action added to key | `{ context, param }` |
| `onRun(fn)` | Key pressed | `{ context }` |
| `onSetActive(fn)` | Action becomes visible | `{ context, active }` |
| `onClear(fn)` | Action removed | `{ param: [{ context }] }` |
| `onParamFromApp(fn)` | Settings received from app | `{ context, param }` |
| `onParamFromPlugin(fn)` | Settings received from PI | `{ context, param }` |
| `onClose(fn)` | Connection closed | `{}` |
| `onError(fn)` | WebSocket error | error string |
| `onSelectdialog(fn)` | File/folder dialog result | selection result |

### Icon Methods

```javascript
// Base64 canvas image (most common for dynamic content)
$UD.setBaseDataIcon(context, base64DataUrl, optionalText)

// Predefined state from manifest States array
$UD.setStateIcon(context, stateIndex, optionalText)

// Local image file path
$UD.setPathIcon(context, './assets/icons/myIcon.png', optionalText)

// Animated GIF (base64 or path)
$UD.setGifDataIcon(context, base64GifData, optionalText)
$UD.setGifPathIcon(context, './assets/myAnim.gif', optionalText)
```

### Settings & Communication

```javascript
// Send settings to main app (from Property Inspector)
$UD.sendParamFromPlugin(settingsObject, optionalContext)

// UI helpers
$UD.toast('Notification message')
$UD.openUrl('https://example.com')
$UD.openView('./popup.html', 300, 200)
$UD.selectFileDialog('image(*.jpg *.png)')
$UD.selectFolderDialog()

// Localization
$UD.t('keyName')  // Returns translated string
```

## Plugin Main Service Pattern (app.js)

```javascript
const ACTION_CACHES = {}
$UD.connect('com.ulanzi.ulanzideck.{pluginName}')
$UD.onConnected(conn => {})

$UD.onAdd(jsn => {
  const context = jsn.context
  if (!ACTION_CACHES[context]) {
    ACTION_CACHES[context] = new MyAction(context)
    onSetSettings(jsn)
  } else {
    ACTION_CACHES[context].add()
  }
})

$UD.onSetActive(jsn => {
  const instance = ACTION_CACHES[jsn.context]
  if (instance) instance.setActive(jsn.active)
})

$UD.onRun(jsn => {
  const instance = ACTION_CACHES[jsn.context]
  if (!instance) $UD.emit('add', jsn)
  else instance.run()
})

$UD.onClear(jsn => {
  if (jsn.param) {
    jsn.param.forEach(item => {
      if (ACTION_CACHES[item.context]) {
        ACTION_CACHES[item.context].clear()
        delete ACTION_CACHES[item.context]
      }
    })
  }
})

$UD.onParamFromApp(jsn => onSetSettings(jsn))
$UD.onParamFromPlugin(jsn => onSetSettings(jsn))

function onSetSettings(jsn) {
  const settings = jsn.param || {}
  const instance = ACTION_CACHES[jsn.context]
  if (!settings || !instance || JSON.stringify(settings) === '{}') return
  if (typeof instance.setParams === 'function') instance.setParams(settings)
}
```

## Action Class Pattern

```javascript
class MyAction {
  constructor(context) {
    this.context = context
    this.lastIcon = ''
    this.allowSend = true
    this.settings = { /* defaults */ }
    this.fontReady = false

    // Wait for font before first render
    this.loadFont().then(() => {
      this.fontReady = true
      this.run()
    })
  }

  loadFont() {
    return document.fonts.ready.then(() => {
      var c = document.createElement('canvas')
      c.width = 1; c.height = 1
      var ctx = c.getContext('2d')
      ctx.font = '10px "Source Han Sans"'
      ctx.fillText('.', 0, 0)
      return document.fonts.ready
    })
  }

  run() { /* start timers, fetch data */ }

  async createIcon(text) {
    if (!this.fontReady) await this.loadFont()
    const canvas = document.createElement('canvas')
    const size = 196  // D200H LCD key size
    canvas.width = size
    canvas.height = size
    const ctx = canvas.getContext('2d')

    // Draw background
    ctx.fillStyle = '#1a1a2e'
    ctx.fillRect(0, 0, size, size)

    // Draw text
    ctx.fillStyle = '#ffffff'
    ctx.font = 'bold 32px "Source Han Sans"'
    ctx.textBaseline = 'middle'
    ctx.textAlign = 'center'
    ctx.fillText(text, size / 2, size / 2)

    const dataUrl = canvas.toDataURL('image/png')
    this.setIcon(dataUrl)
  }

  setIcon(icon) {
    if (!this.allowSend) return
    this.lastIcon = icon || this.lastIcon
    if (this.lastIcon) $UD.setBaseDataIcon(this.context, this.lastIcon)
  }

  add() { this.run() }

  setActive(active) {
    this.allowSend = true
    this.setIcon()
    this.allowSend = active
  }

  setParams(jsn) {
    this.settings = { ...this.settings, ...jsn }
    this.run()
  }

  clear() { /* clear timers */ }
}
```

## Property Inspector Pattern

### inspector.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="../../libs/css/udpi.css">
</head>
<body>
  <div class="udpi-wrapper hidden">
    <form id="property-inspector">
      <div class="udpi-item">
        <div class="udpi-item-label" data-localize>Label</div>
        <select class="udpi-item-value select" name="fieldName">
          <option value="a">Option A</option>
          <option value="b">Option B</option>
        </select>
      </div>
    </form>
  </div>
  <script src="../../libs/js/constants.js"></script>
  <script src="../../libs/js/eventEmitter.js"></script>
  <script src="../../libs/js/timers.js"></script>
  <script src="../../libs/js/utils.js"></script>
  <script src="../../libs/js/ulanzideckApi.js"></script>
  <script src="./inspector.js"></script>
</body>
</html>
```

### inspector.js

```javascript
let ACTION_SETTING = {}
let form = ''

$UD.connect('com.ulanzi.ulanzideck.{pluginName}.{actionName}')

$UD.onConnected(conn => {
  form = document.querySelector('#property-inspector')
  document.querySelector('.udpi-wrapper').classList.remove('hidden')

  form.addEventListener('input', Utils.debounce(() => {
    ACTION_SETTING = Utils.getFormValue(form)
    $UD.sendParamFromPlugin(ACTION_SETTING)
  }))
})

$UD.onAdd(jsn => {
  if (jsn && jsn.param) restoreSettings(jsn.param)
})

$UD.onParamFromApp(jsn => {
  if (jsn && jsn.param) restoreSettings(jsn.param)
})

function restoreSettings(params) {
  ACTION_SETTING = params
  Utils.setFormValue(ACTION_SETTING, form)
}
```

## Critical Constraints

### CORS

The HTML plugin runs in a WebView that enforces CORS. Only APIs with `Access-Control-Allow-Origin: *` work.

**Known working APIs:**
- Binance: `https://data-api.binance.vision/api/v3/*`
- CryptoCompare: `https://min-api.cryptocompare.com/*`
- manana.kr: `https://api.manana.kr/*`
- open.er-api.com: `https://open.er-api.com/*`

**Known blocked APIs (no CORS):**
- Upbit: `https://api.upbit.com/*`
- Bithumb: `https://api.bithumb.com/*`
- Dunamu: `https://quotation-api-cdn.dunamu.com/*`
- CoinGecko: returns 403 when User-Agent is empty (WebView behavior)

To check CORS: `curl -sI "URL" | grep -i "access-control"`

**Workaround - self-hosted CORS relay (Cloudflare Worker):**

A "blocked" API is not a dead end. Proxy it through a tiny Cloudflare Worker that fetches
server-side (a server context has no CORS) and re-emits the JSON with
`Access-Control-Allow-Origin: *`. The plugin then calls your Worker instead of the blocked API.

```javascript
// worker.js - deploy with `wrangler deploy` (free tier: 100k req/day)
const CORS = { 'Access-Control-Allow-Origin': '*', 'Cache-Control': 'no-store' };
export default {
  async fetch(request) {
    if (request.method === 'OPTIONS') return new Response(null, { headers: CORS });
    const id = new URL(request.url).searchParams.get('id') || '';
    if (!/^[A-Za-z0-9.\-]{1,16}$/.test(id))               // validate - never proxy arbitrary input
      return Response.json({ error: 'bad id' }, { status: 400, headers: CORS });
    const r = await fetch('https://UPSTREAM/api/' + encodeURIComponent(id), {
      headers: { 'User-Agent': 'Mozilla/5.0', 'Referer': 'https://UPSTREAM/' },
    });
    return new Response(await r.text(),
      { headers: { 'Content-Type': 'application/json; charset=utf-8', ...CORS } });
  },
};
```

- A **fixed upstream host + `encodeURIComponent` + an input whitelist** are mandatory, or the
  Worker becomes an open proxy / SSRF target. For a public URL add a rate limit or a shared token.
- Naver Finance realtime quotes (KR/US stocks and indices) *require* this relay - they return
  `403 Invalid CORS request` on any cross-origin read. Upbit / Bithumb / Dunamu (blocked above)
  also work through it.
- If the upstream sits behind Cloudflare and challenges the Worker or `curl` by TLS (JA3)
  fingerprint, a Node plugin can shell out to
  [`curl-impersonate`](https://github.com/lexiforest/curl-impersonate)
  (`--impersonate chrome146 --ca-native`) to mimic a real browser handshake.

### Font Loading

Remote fonts (`Source Han Sans` from `ulanzistudio.com`) load asynchronously. Canvas renders with system fallback font if drawn before font loads.

**Fix:** Always await `document.fonts.ready` before Canvas drawing:
```javascript
async createIcon() {
  await document.fonts.ready
  // now draw on canvas
}
```

### Canvas Size

LCD key canvas is **196x196 pixels**. All icons must be this size.

### Long Text - Scroll, Don't Shrink

When a label is wider than 196px, shrinking the font to fit quickly becomes unreadable. Keep the
font size and scroll the text horizontally (marquee). Measure with `ctx.measureText`; if it
overflows, advance an x-offset each frame and draw a second copy for a seamless wrap:

```javascript
const w = ctx.measureText(label).width;
if (w > size) {
  this.scrollX = (this.scrollX + speed) % (w + GAP);   // speed = px/frame; expose as a PI setting
  ctx.fillText(label, -this.scrollX, y);
  ctx.fillText(label, -this.scrollX + w + GAP, y);     // wrap-around copy
} else {
  ctx.fillText(label, (size - w) / 2, y);              // fits: center, no scroll
}
```

### Flicker-Free Updates

Dynamic keys redraw every few seconds. Drawing a placeholder (`...`, a spinner, "Loading") on
*every* refresh makes the key visibly flicker.

- Show a loading placeholder **only on the first render** - track a `hasData` flag and stop
  showing it once you have a value.
- On a fetch **error**, keep the last good value on screen instead of blanking to `...`; a
  transient blip should not wipe the key.
- Only call `setBaseDataIcon` when the rendered output actually changed (compare against
  `lastIcon`).

```javascript
async refresh() {
  let data;
  try { data = await this.fetch(); }
  catch { if (this.hasData) return; return this.renderError(); }  // keep last value on error
  this.hasData = true;
  this.render(data);
}
```

### Data Fetching

Use `Utils.fetchData(url)` for GET requests (returns parsed JSON via fetch API).
Use `Utils.getData(url)` for XHR-based requests (adds timestamp param, 1.5s timeout).

**Realtime polling:** drive live data (prices, quotes) from a timer in `libs/js/timers.js` -
those are Web Worker timers, so they keep firing when the WebView is backgrounded. Match the
upstream's cadence (e.g. ~5-7s during market hours) instead of hammering it; too fast risks rate
limits or an IP ban. Keep a source-fallback chain (primary -> secondary) and reuse the last value
when a poll fails (see Flicker-Free Updates).

### Debouncing

Always debounce rapid updates (Settings changes, API calls):
```javascript
Utils.debounce(fn, 150)  // 150ms default
```

## Security (Plugins That Handle Secrets)

Most tickers are read-only, but any plugin that stores an API key, token, or session cookie must
treat it as sensitive:

- **Never hardcode API keys** in `actions/*.js` - anyone who installs the plugin (or reads the
  repo) gets the key. Read it from a Property Inspector field and keep it in the action's settings.
- **Validate before you shell out.** A Node plugin that passes a user-supplied value into
  `child_process.exec`, a `.bat`, or PowerShell is a command-injection target. Whitelist it first -
  `if (!/^[A-Za-z0-9._-]+$/.test(key)) return;` - before it reaches a shell. A crafted value like
  `x" & calc &` otherwise runs arbitrary commands.
- **Don't put secrets on the command line.** Process arguments are visible to any local process
  (`Get-CimInstance Win32_Process`, `tasklist`). Pass secrets through a file or stdin, not
  `-Key <value>`.
- **Protect secrets at rest.** A plaintext key file is readable by any process running as the
  user; prefer OS-native protection (DPAPI on Windows) and tighten the file's ACL. Scraping
  another app's browser cookies (Chrome DPAPI / App-Bound Encryption) is fragile and breaks
  across versions - prefer explicit user entry.

## Localization

Create JSON files in plugin root: `en.json`, `ko_KR.json`, `zh_CN.json`, etc.

```json
{
  "Label Text": "Translated text"
}
```

Elements with `data-localize` attribute are auto-translated. Use `$UD.t('key')` in code.

Supported languages: en, zh_CN, zh_HK, de_DE, ja_JP, ko_KR, and more.

## Debugging

- **HTML plugin**: Launch Ulanzi Studio with `--webRemoteDebug` flag, open `localhost:9292`
- **Node.js plugin**: Launch with `--nodeRemoteDebug`, use Chrome DevTools Inspector
- **Simulator**: Browser-based test at `http://127.0.0.1:39069` (when Ulanzi Studio is running)

## SDK Library Files

The `libs/` directory is shared across plugins. Copy from any existing plugin:
- `libs/js/constants.js` - Event type constants
- `libs/js/eventEmitter.js` - Pub/sub with wildcard support
- `libs/js/timers.js` - Web Worker based reliable timers
- `libs/js/utils.js` - HTTP, form, canvas, debounce utilities
- `libs/js/ulanzideckApi.js` - Main SDK ($UD singleton)
- `libs/css/udpi.css` - Property Inspector dark theme CSS

**Source:** [UlanziDeckPlugin-SDK](https://github.com/UlanziTechnology/UlanziDeckPlugin-SDK)

## Plugin Installation Path

```
Windows: %APPDATA%\Ulanzi\UlanziDeck\Plugins\com.ulanzi.{name}.ulanziPlugin\
macOS:   ~/Library/Application Support/Ulanzi/UlanziDeck/Plugins/com.ulanzi.{name}.ulanziPlugin/
```

Restart Ulanzi Studio after installing.

## Device Specs

| Device | Layout | Keys |
|--------|--------|------|
| D200H | 5x3 | 14 LCD + 13 macro |
| D200 | 5x3 | 15 LCD |
| D200X | 5x3 | 15 LCD |
| Dial | 3x3 | 9 LCD + knob |
