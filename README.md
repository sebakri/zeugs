# zeugs site

This folder holds the static landing page for zeugs, a suite of small, local-first desktop apps.

The page lists applications only. It does not list command-line tools. All page data is in `apps-data.js`, so the page makes no API calls and needs no network beyond its own files.

## Preview

Run this command from the repository root:

```sh
python3 -m http.server -d site
```

Open `http://localhost:8000` in a browser.

## Add a release entry

Edit `apps-data.js` to add or update an app release. Set `released` to `true`, then set `releaseUrl`, `downloadLabel`, and `detail`. Use the release page at `https://github.com/sebakri/zeugs/releases`. Releases use tags such as `draw-v0.2.0` and `note-v0.1.0`.

For an app that is not released, set `released` to `false` and give it a status such as `Not released yet`.

## Release an app

1. Review and commit the app changes on `main`. Run `task release:version APP=draw` and `task changelog APP=draw`. Use `note`, `pdf`, or `table` for the other apps.
2. Check the plan with `./scripts/release.sh draw 0.2.0 --dry-run`. This command does not change files or tags. It does not build or push.
3. In phase 2, run `task release APP=draw`. The task sets the version files. It commits changed version files before it creates the local tag. It does not push. Use `BUMP=patch`, `BUMP=minor`, or `BUMP=major` to force a bump.
4. In phase 2, set `PRIVATE_GH_TOKEN` and `FORGEJO_TOKEN`. On macOS, run `task release:publish APP=draw VERSION=0.2.0 STAGE=prepare`, then repeat with `STAGE=build`, `STAGE=scan`, `STAGE=verify`, and `STAGE=publish`. Prepare runs tests before it sets version files and creates the local tag. Build creates the universal DMG and checksum. Scan checks the bundle, mounted DMG files, tagged app source, release notes, and checksum for confidential data. It writes a redacted JSON report to the ignored `.openchamber/release-evidence/` folder. Publish requires a clean report less than 24 hours old for the exact artifact and all scan inputs. It rescans before any GitHub request. Rules cover credentials, private identifiers, paths, networks, and email addresses. `scripts/release-scan-allow.txt` holds scoped false-positive rules and their reasons. Each allowed hit appears in the report. Runtime secrets and private identifiers cannot be allowed. Verify checks the checksum, DMG, mounted bundle versions, and both binary architectures. Inspect the results before publish. Publish repeats artifact checks, uploads the assets, and checks their sizes and download URLs through GitHub. It then pushes only `main` and the app tag to `origin` and checks both remote refs. The GitHub release targets the site repo's `main` branch. Omit `STAGE` to run all stages in order. `./scripts/release.sh` also accepts `--stage`. The older `--prepare-only` option and `task release` change version metadata and the local tag only; they do not run tests.
5. Check the assets and checksum. Then update the app entry and publish the site. Publishing scans `site/` and blocks on any finding. Keep `releaseUrl` set to `https://github.com/sebakri/zeugs/releases`. Set `version` on the app entry. The page fills `{version}` in `assetUrlTemplate` and `detail` from it, and the download button uses the versioned asset URL. Without `version`, the button falls back to `releaseUrl`. Do not use the repo-wide latest-release URL for one app.

The tasks need `task`, `svu` 3.4.0, Git, Node.js, npm, and Python 3. Publishing also needs Go, Wails 3, and the macOS build tools. Both version checks and local release tasks refuse a dirty app folder. Dry-run mode can show a plan for a dirty folder, but a real release cannot proceed.

The version command uses `svu next --tag.prefix <app>-v --tag.pattern '<app>-v*' --log.directory <app>`. Forced bumps use the same tag prefix and pattern. They do not inspect commits. The first release of Note, Pdf, and Table is `0.1.0`, for all bump choices. These apps have no tags yet. `svu` returns an error when the tag pattern has no match. Later releases use `svu`. Draw's current next version is `0.2.0` after `draw-v0.1.9`.

Version preparation updates the npm package and lock file, `build/config.yml`, and `APP_VERSION` where present. It uses the Wails build-assets generator in a temporary folder for the two macOS plists and Windows version metadata. It checks that other metadata stays the same. Note's macOS build also sets `note/internal/app.Version` through linker flags. No Go version source needs a release edit.

The app registry is in `scripts/release-lib.sh`. Box can join there when its package and verification steps are ready. Box has no release task now. Existing tags are not moved. A retry needs the tag at `HEAD` with matching version files. Release notes use the matching `CHANGELOG.md` section, or app-scoped conventional commits since the previous app tag.

## Publish

GitHub Pages hosts this site at `https://sebakri.github.io/zeugs/`. Commit all site changes before publishing. Then run this command from the repository root:

```sh
./scripts/publish-site.sh
```

The script splits the committed `site/` folder and pushes the split to the `main` branch of `sebakri/zeugs`. Use `--force` only when you need to replace an existing `main` branch.
## Feature requests and bugs

Visitors open issues in the GitHub repo. The `.github/ISSUE_TEMPLATE/` folder holds the forms. The publish script sends it with the rest of `site/`.

## Install script

`install.sh` installs an app from its GitHub release: it downloads the DMG and its checksum, stops on a mismatch, copies the app to `/Applications/zeugs` and removes the quarantine flag. The folder gets the zeugs icon. Use `all` instead of an app name to install every released app. The apps are ad-hoc signed and not notarized, so a browser download is blocked by macOS. The cards show the command `curl -fsSL https://sebakri.github.io/zeugs/install.sh | sh -s -- <app>`. Set `ZEUGS_VERSION` or `ZEUGS_DEST` to override the version or the target folder. The script is plain POSIX shell.
