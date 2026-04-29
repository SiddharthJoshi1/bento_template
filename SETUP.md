# SETUP.md — Your own Flutter bento portfolio in under an hour

This repo is a GitHub template. Fork it, customise `content.json`, deploy — done.

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — stable channel, 3.x or later
- A GitHub account
- Optionally: a hosting target (GitHub Pages, Firebase Hosting, Vercel, Netlify)

---

## Step 1 — Fork the template

Click **Use this template → Create a new repository** at the top of this repo.

Give it a name (e.g. `my-portfolio`) and set visibility to public if you plan to use GitHub Pages.

Clone your new repo locally:

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
flutter pub get
```

---

## Step 2 — Set up the content branch

Your portfolio content lives in a separate `content` branch, served via `raw.githubusercontent.com`. This means you can update your portfolio without ever rebuilding or redeploying the app.

Create the content branch:

```bash
git checkout --orphan content
git rm -rf .
```

Copy the starter `content.json` from this repo's `assets/data/content.json` into the **root** of this branch (not inside any subfolder — the raw URL must resolve to `https://raw.githubusercontent.com/<you>/<repo>/content/assets/data/content.json`), then push it:

```bash
# Copy assets/data/content.json from main, place it at assets/data/content.json on this branch
mkdir -p assets/data
cp /path/to/content.json assets/data/content.json
git add assets/data/content.json
git commit -m "init: content branch"
git push origin content
git checkout main
```

> The folder structure on the `content` branch must mirror the path used in `CONTENT_BASE_URL`. If your variable is `https://raw.githubusercontent.com/<you>/<repo>/content/`, then `content.json` must live at `assets/data/content.json` on that branch.

---

## Step 3 — Point the app at your repo

No code changes needed. The content URL is injected at build time via a `--dart-define` flag.

Set your repo URL as a **repository variable** in GitHub:

1. Go to your repo **Settings → Secrets and variables → Actions → Variables**
2. Add a variable named `CONTENT_BASE_URL` with the value:
   ```
   https://raw.githubusercontent.com/<your-username>/<your-repo>/content/
   ```
   (trailing slash is required)

The GitHub Actions workflow picks this up automatically. For local development, pass it manually:

```bash
flutter run -d chrome --dart-define=CONTENT_BASE_URL=https://raw.githubusercontent.com/<your-username>/<your-repo>/content/
```

Optionally, also add a `MAP_USER_AGENT` variable (reverse-DNS format, e.g. `com.yourname.portfolio`) — required by OSM tile policy. Falls back to a generic value if not set.

---

## Step 4 — Customise content.json

Edit `content.json` on the `content` branch (or locally in `assets/data/content.json` for the bundled fallback).

### Profile

```json
{
  "version": "1.0.0",
  "profile": {
    "name": "Your Name",
    "bio": "One-line bio that appears on your profile tile.",
    "avatar_path": "assets/your_photo.png"
  },
  "tiles": []
}
```

Put your avatar image in the `assets/` folder and register it in `pubspec.yaml` under `flutter > assets`.

### Adding tiles

Each tile needs at minimum a `type` and `tile_size`. Everything else is type-specific.

```json
{
  "type": "link",
  "tile_size": "half_card",
  "title": "My GitHub",
  "url": "https://github.com/your-username",
  "image_path": "assets/github_preview.png"
}
```

See `CLAUDE.md` for the full tile type and tile size reference tables.

### Updating live content (no rebuild needed)

Once deployed, you never need to redeploy to update content:

1. Edit `content.json`
2. Bump the `"version"` field (e.g. `"1.0.0"` → `"1.0.1"`)
3. Push to the `content` branch

The app checks the remote version on startup and swaps in the new content automatically.

---

## Step 5 — Personalise your site metadata & icons

These files control what browsers, search engines, and social platforms see. They ship with placeholder values — update them before going live.

### `web/index.html`

Open this file and replace all the `PERSONALISE:` comment blocks:

| Tag | What to change |
|---|---|
| `<meta name="description">` | Your one-line bio |
| `<meta name="apple-mobile-web-app-title">` | Your name or site name |
| `og:title`, `og:description` | Your name and bio (controls LinkedIn / Slack previews) |
| `og:image`, `twitter:image` | Full URL to your deployed `icons/Icon-512.png` |
| `og:url` | Your live site URL |
| `twitter:title`, `twitter:description` | Same as OG, or customise for X/Twitter |
| `<title>` | `Your Name \| Your Role` |

### `web/manifest.json`

Update `name`, `short_name`, and `description` — these control how the PWA looks when someone adds your site to their home screen.

### Icons & favicon

Replace all files in `web/icons/` and `web/favicon.png` with your own branding. Required sizes: `Icon-192.png`, `Icon-512.png`, `Icon-maskable-192.png`, `Icon-maskable-512.png`.

[RealFaviconGenerator](https://realfavicongenerator.net) generates all sizes from a single image for free. Icons live in `web/` — no code changes, no rebuild needed.

---

## Step 6 — Add your assets

Add any images or videos you reference in `content.json` to the `assets/` folder, then register them in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/
    - assets/data/
```

Run `flutter pub get` after editing `pubspec.yaml`.

---

## Step 7 — Run locally

```bash
flutter run -d chrome
```

Check that your profile and tiles render correctly.

---

## Step 8 — Deploy

### GitHub Pages (recommended — free, zero config)

This repo includes a GitHub Actions workflow at `.github/workflows/deploy.yml` that builds and deploys to GitHub Pages on every push to `main`.

1. Go to your repo **Settings → Pages**, set source to **GitHub Actions**
2. Go to **Settings → Secrets and variables → Actions** and add:
   - **Variable** `CONTENT_BASE_URL` — your raw GitHub content URL (from Step 3)
   - **Variable** `MAP_USER_AGENT` — e.g. `com.yourname.portfolio` (optional)
   - **Secret** `LUKEHOG_APP_ID` — your Lukehog ID (optional, analytics silently disabled if absent)
3. Push to `main` — the workflow does the rest

Your site will be live at `https://<your-username>.github.io/<your-repo>/`.

> **Custom domain:** Add a `CNAME` file to the `web/` folder containing your domain, and point your DNS to GitHub Pages.

### Firebase Hosting

```bash
npm install -g firebase-tools
firebase login
firebase init hosting    # set public dir to "build/web"
flutter build web
firebase deploy
```

### Vercel / Netlify

Set the build command to `flutter build web` and the publish directory to `build/web`. Both platforms support this out of the box.

---

## Optional — Analytics

The app supports [Lukehog](https://lukehog.com) analytics, injected at build time:

```bash
flutter build web --dart-define=LUKEHOG_APP_ID=your_app_id
```

Without this flag, analytics events are silently dropped — nothing breaks.

---

## Troubleshooting

**Blank screen on load** — Check the browser console. Usually a missing asset registered in `pubspec.yaml` or a malformed `content.json`.

**Content not updating** — Make sure you bumped `"version"` in `content.json` and pushed to the `content` branch (not `main`).

**CORS errors in the console** — This is Flutter web fetching from `raw.githubusercontent.com`. It should work without issues; if it doesn't, check your content branch URL is correct and the branch is public.

**`flutter analyze` errors** — Run `flutter pub get` first, then `flutter analyze`. Fix all issues before pushing.

---

## What's next

Once you're up and running, the most interesting thing to customise is the interactive widget system. See `WIDGET_GUIDE.md` for how to build your own.
