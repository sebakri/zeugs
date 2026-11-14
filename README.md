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

## Release an app

1. Review and commit the app changes on `main`. Run `task release:version APP=draw` and `task changelog APP=draw`. Use `note`, `pdf`, or `table` for the other apps.
2. Check the plan with `./scripts/release.sh draw 0.2.0 --dry-run`. This command does not change files or tags. It does not build or push.
3. In phase 2, run `task release APP=draw`. The task sets the version files. It commits changed version files before it creates the local tag. It does not push. Use `BUMP=patch`, `BUMP=minor`, or `BUMP=major` to force a bump.
4. In phase 2, set `PRIVATE_GH_TOKEN`. Run `task release:publish APP=draw VERSION=0.2.0` on macOS. The task tests and builds the universal DMG. It pushes `main` and tags to `origin`. It then uploads the DMG and checksum to GitHub. The GitHub release targets the site repo's `main` branch.
5. Check the assets and checksum. Then update the app entry and publish the site. Keep `releaseUrl` set to `https://github.com/sebakri/zeugs/releases`. The `assetUrlTemplate` field gives the app-specific download URL. Replace `{version}` with the released version. Do not use the repo-wide latest-release URL for one app.

The tasks need `task`, `svu` 3.4.0, Git, Node.js, npm, and Python 3. Publishing also needs Go, Wails 3, and the macOS build tools. Both version checks and local release tasks refuse a dirty app folder. Dry-run mode can show a plan for a dirty folder, but a real release cannot proceed.

The version command uses `svu next --tag.prefix <app>-v --tag.pattern '<app>-v*' --log.directory <app>`. Forced bumps use the same tag prefix and pattern. They do not inspect commits. The first release of Note, Pdf, and Table is `0.1.0`, for all bump choices. These apps have no tags yet. `svu` returns an error when the tag pattern has no match. Later releases use `svu`. Draw's current next version is `0.2.0` after `draw-v0.1.9`.

Version preparation updates the npm package and lock file, `build/config.yml`, and `APP_VERSION` where present. It uses the Wails build-assets generator in a temporary folder for the two macOS plists and Windows version metadata. It checks that other metadata stays the same. Note's macOS build also sets `note/internal/app.Version` through linker flags. No Go version source needs a release edit.

The app registry is in `scripts/release-lib.sh`. Box can join there when its package and verification steps are ready. Box and suite-ui have no release task now. Existing tags are not moved. A retry needs the tag at `HEAD` with matching version files. Release notes use the matching `CHANGELOG.md` section, or app-scoped conventional commits since the previous app tag.

## Publish

GitHub Pages hosts this site at `https://sebakri.github.io/zeugs/`. Commit all site changes before publishing. Then run this command from the repository root:

```sh
./scripts/publish-site.sh
```

The script splits the committed `site/` folder and pushes the split to the `main` branch of `sebakri/zeugs`. Use `--force` only when you need to replace an existing `main` branch.
## Feature requests and bugs

Visitors open issues in the GitHub repo. The `.github/ISSUE_TEMPLATE/` folder holds the forms. The publish script sends it with the rest of `site/`.
