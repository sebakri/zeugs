# zeugs site

This folder holds the static landing page for the zeugs apps.

## Preview

Run this command from the zeugs folder:

```sh
python3 -m http.server -d site
```

Open `http://localhost:8000` in a browser.

You can also open `site/index.html` directly. The page uses local files only.

## Add a release

Edit `apps-data.js` to add or update an app release. Set its release link,
button label, status, and download detail there. The page reads all app cards
from that file.

Hosting is not set. This folder has no deploy script.
