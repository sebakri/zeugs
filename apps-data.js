/* Single source of truth for the app cards and their download links. */
window.ZEUGS_APPS = [
  {
    name: "Draw",
    slug: "draw",
    description: "A whiteboard and sketch workspace.",
    icon: "assets/draw.png",
    status: "Available",
    released: true,
    releaseUrl: "https://codeberg.org/sebdev/draw/releases/latest",
    downloadLabel: "Download for macOS",
    detail: "Universal DMG · Draw_<version>_universal.dmg"
  },
  {
    name: "Table",
    slug: "table",
    description: "A Bigtable viewer for local and remote instances.",
    icon: "assets/table.png",
    status: "Not released yet",
    released: false
  },
  {
    name: "pdf",
    slug: "pdf",
    description: "Opens a PDF, changes the text of a line, and saves the file.",
    icon: "assets/pdf.png",
    status: "Not released yet",
    released: false
  },
  {
    name: "note",
    slug: "note",
    description: "A note-taking app for Markdown and Quarkdown files on disk.",
    icon: "assets/note.png",
    status: "Not released yet",
    released: false
  }
];
