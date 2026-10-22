// Repair: stock searchable new-tab/home, native sidebar layout; no custom CSS.
// Iris: appearance only. Native Zen vertical tabs remain the default.
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("browser.theme.content-theme", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.enabled", true);
user_pref("zen.view.show-background-tab-toast", false);

// BEGIN IRIS NATIVE GLASS — supported by the installed Zen 1.23.2b resources.
// Native chrome alpha; keep web content opaque and compositor opacity at 1.0.
user_pref("zen.widget.linux.transparency", true);
user_pref("browser.tabs.allow_transparent_browser", false);
// END IRIS NATIVE GLASS

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", false);

user_pref("widget.transparent-windows", true);

user_pref("zen.urlbar.replace-newtab", false);

user_pref("zen.urlbar.open-on-startup", true);

user_pref("zen.view.sidebar-expanded.max-width", 500);

user_pref("zen.theme.content-element-separation", 8);

user_pref("zen.theme.border-radius", -1);

user_pref("zen.theme.essentials-favicon-bg", true);

user_pref("browser.newtabpage.activity-stream.showSearch", true);

user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);

user_pref("browser.newtabpage.activity-stream.showSponsored", false);

user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
