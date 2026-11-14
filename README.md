# zeugs site

This folder holds the static landing page for zeugs, a suite of small, local-first desktop tools for developers.

## Preview

Run this command from the repository root:

```sh
python3 -m http.server -d site
```

Open `http://localhost:8000` in a browser.

## Add a release entry

Edit `apps-data.js` to add or update an app release. Set `released` to `true`, then set `releaseUrl`, `downloadLabel`, and `detail`. Use the release page at `https://github.com/sebakri/zeugs/releases`. Releases use tags such as `draw-v0.2.0` and `box-v0.7.3`.

For an app that is not released, set `released` to `false` and give it a status such as `Not released yet`.

## Publish

GitHub Pages hosts this site at `https://sebakri.github.io/zeugs/`. Commit all site changes before publishing. Then run this command from the repository root:

```sh
./scripts/publish-site.sh
```

The script splits the committed `site/` folder and pushes the split to the `main` branch of `sebakri/zeugs`. Use `--force` only when you need to replace an existing `main` branch.
## Feature requests and bugs

Visitors open issues in the GitHub repo. The `.github/ISSUE_TEMPLATE/` folder holds the forms. The publish script sends it with the rest of `site/`.
