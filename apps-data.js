/* Single source of truth for the app cards and their download links. */
window.ZEUGS_APPS = [
  {
    name: "Draw",
    slug: "draw",
    assetUrlTemplate: "https://github.com/sebakri/zeugs/releases/download/draw-v{version}/Draw_{version}_universal.dmg",
    description: "A whiteboard and sketch workspace.",
    icon: "assets/draw.png",
    status: "Available",
    released: true,
    releaseUrl: "https://github.com/sebakri/zeugs/releases",
    downloadLabel: "Download for macOS",
    detail: "Universal DMG · Draw_<version>_universal.dmg"
  },
  {
    name: "Table",
    slug: "table",
    assetUrlTemplate: "https://github.com/sebakri/zeugs/releases/download/table-v{version}/Table_{version}_universal.dmg",
    description: "A Bigtable viewer for local and remote instances.",
    icon: "assets/table.png",
    status: "Not released yet",
    released: false
  },
  {
    name: "pdf",
    slug: "pdf",
    assetUrlTemplate: "https://github.com/sebakri/zeugs/releases/download/pdf-v{version}/Pdf_{version}_universal.dmg",
    description: "Opens a PDF, changes the text of a line, and saves the file.",
    icon: "assets/pdf.png",
    status: "Not released yet",
    released: false
  },
  {
    name: "note",
    slug: "note",
    assetUrlTemplate: "https://github.com/sebakri/zeugs/releases/download/note-v{version}/Note_{version}_universal.dmg",
    description: "A note-taking app for Markdown and Quarkdown files on disk.",
    icon: "assets/note.png",
    status: "Not released yet",
    released: false
  }
];
