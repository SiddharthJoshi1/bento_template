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

> **Enable GitHub Pages now.** Go to your repo **Settings → Pages** and set the source to **GitHub Actions** before continuing. If you skip this, the deploy workflow will fail silently and you'll have to come back here anyway.

---

## Step 2 — Set up the content branch

Your portfolio content lives in a separate `content` branch, served via `raw.githubusercontent.com`. This means you can update your portfolio without ever rebuilding or redeploying the app.

A setup script handles this for you. From the root of your repo:

```bash
bash scripts/init_content_branch.sh
```

If you want to bootstrap from one of the starter configs in `examples/` instead of the default content:

```bash
bash scripts/init_content_branch.sh examples/developer.json
```

Here's what it does, step by step:

1. **Reads the source `content.json`** from your working tree — either `assets/data/content.json` (default) or a path you pass as an argument (e.g. `examples/developer.json`)
2. **Creates an orphan branch** called `content` — a branch with no shared history with main, keeping it clean and minimal
3. **Wipes the working tree** so the branch contains only what the app needs to fetch
4. **Reconstructs `assets/data/content.json`** on the new branch using the content read in step 1
5. **Commits and pushes** to origin, then returns you to main

Once complete, your content will be accessible at:
```
https://raw.githubusercontent.com/<your-username>/<your-repo>/content/assets/data/content.json
```

> The folder path on the `content` branch must mirror the path used in `CONTENT_BASE_URL`. The script sets this up correctly — only move things manually if you know what you're doing.

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

> **Not sure where to start?** The [`examples/`](./examples/) folder has three starter configs — `developer.json`, `designer.json`, and `minimal.json`. Copy one into `assets/data/content.json` and edit from there.

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
