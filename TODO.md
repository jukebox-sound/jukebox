# jukebox TODO

## Bugs

- [ ] Fix "Open containing folder" with terminal file managers such as vifm.
  Reproduce the failure through the desktop directory MIME association and trace
  `openfolder()` and `run_system_cmd()` before choosing a fix.  Keep the observed
  launch failure separate from the old assumption that `run_system_cmd()` is the
  cause.

## UI and desktop integration

- [ ] Make fullscreen actions use state-appropriate icons consistently.
  `Layout::PictureBrowser` already switches between `gtk-fullscreen` and
  `gtk-leave-fullscreen`; other fullscreen actions still hard-code
  `gtk-fullscreen`.

- [ ] Audit bundled `gmb-*` icons against GTK2 theme/stock equivalents.  Prefer a
  system icon when it has the same semantics, but retain jukebox-specific icons
  when no suitable themed icon exists.

## Cleanup

- [ ] Remove the inherited Gettext/i18n machinery if jukebox is to remain
  untranslated.  No locale catalogs are shipped, but startup still probes
  `Locale::Messages`/`Locale::gettext` and translation wrappers remain in the
  source.  Treat this as a dedicated behavior-preserving cleanup rather than a
  search-and-replace pass.
