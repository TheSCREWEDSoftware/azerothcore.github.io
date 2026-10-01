(function () {
  var STORAGE_KEY = 'azerothcore-theme';

  function getPreferredTheme() {
    try {
      var stored = localStorage.getItem(STORAGE_KEY);
      if (stored === 'light' || stored === 'dark') {
        return stored;
      }
    } catch (e) {}
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
  }

  // Applied immediately (this script must load before the stylesheets finish
  // parsing) so there's no light-mode flash before the toggle button exists.
  var currentTheme = getPreferredTheme();
  applyTheme(currentTheme);

  function updateButton(button, theme) {
    // Plain characters instead of a FontAwesome <i> icon: this button is
    // created after FontAwesome's own page scan has already run, so an
    // icon class injected here isn't reliably picked up and replaced.
    button.textContent = theme === 'dark' ? '\u2600\ufe0f' : '\ud83c\udf19';
    var label = theme === 'dark' ? 'Switch to light theme' : 'Switch to dark theme';
    button.setAttribute('aria-label', label);
    button.title = label;
  }

  function init() {
    // One floating toggle, injected on every page (Jekyll pages and the
    // embedded Angular catalogue alike) so no per-layout markup is needed.
    var button = document.createElement('button');
    button.type = 'button';
    button.className = 'theme-toggle-btn';
    updateButton(button, currentTheme);

    button.addEventListener('click', function () {
      currentTheme = currentTheme === 'dark' ? 'light' : 'dark';
      applyTheme(currentTheme);
      updateButton(button, currentTheme);
      try {
        localStorage.setItem(STORAGE_KEY, currentTheme);
      } catch (e) {}
    });

    document.body.appendChild(button);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
