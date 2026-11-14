(() => {
  const appList = document.querySelector("#app-list");
  const apps = Array.isArray(window.ZEUGS_APPS) ? window.ZEUGS_APPS : [];

  function make(tag, className, text) {
    const element = document.createElement(tag);
    if (className) element.className = className;
    if (text) element.textContent = text;
    return element;
  }

  apps.forEach((app) => {
    const card = make("article", "app-card");
    const top = make("div", "app-card__top");
    const image = make("img", "app-card__icon");
    image.src = app.icon;
    image.alt = `${app.name} app icon`;
    image.width = 72;
    image.height = 72;
    image.decoding = "async";
    top.append(image);

    const status = make("span", `status${app.released ? " status--available" : ""}`, app.status);
    top.append(status);
    card.append(top);

    const title = make("h3", "app-card__title", app.name);
    card.append(title);
    card.append(make("p", "app-card__description", app.description));

    const actions = make("div", "app-card__actions");
    if (app.released && app.releaseUrl) {
      const link = make("a", "button button--primary", app.downloadLabel || "View latest release");
      link.href = app.releaseUrl;
      link.target = "_blank";
      link.rel = "noopener noreferrer";
      link.setAttribute("aria-label", `${app.downloadLabel || "View latest release"} for ${app.name} (opens in a new tab)`);
      actions.append(link);
      if (app.detail) actions.append(make("p", "app-card__detail", app.detail));
    } else {
      const button = make("button", "button button--disabled", "Coming soon");
      button.type = "button";
      button.disabled = true;
      actions.append(button);
    }
    card.append(actions);
    appList.append(card);
  });

  const themeToggle = document.querySelector("#theme-toggle");
  const root = document.documentElement;
  const preference = window.matchMedia("(prefers-color-scheme: dark)");

  try {
    const savedTheme = window.localStorage.getItem("zeugs-theme");
    if (savedTheme === "light" || savedTheme === "dark") root.dataset.theme = savedTheme;
  } catch (_error) {
    // The system preference still works when storage is not available.
  }

  function isDark() {
    if (root.dataset.theme) return root.dataset.theme === "dark";
    return preference.matches;
  }

  function updateToggle() {
    const dark = isDark();
    const next = dark ? "light" : "dark";
    themeToggle.textContent = `${dark ? "☼" : "◐"} ${dark ? "Light" : "Dark"} theme`;
    themeToggle.setAttribute("aria-label", `Switch to ${next} theme`);
    themeToggle.setAttribute("aria-pressed", String(dark));
  }

  themeToggle.addEventListener("click", () => {
    const next = isDark() ? "light" : "dark";
    root.dataset.theme = next;
    try {
      window.localStorage.setItem("zeugs-theme", next);
    } catch (_error) {
      // The selected theme remains active for this page view.
    }
    updateToggle();
  });

  if (preference.addEventListener) {
    preference.addEventListener("change", () => {
      if (!root.dataset.theme) updateToggle();
    });
  }
  updateToggle();
})();
