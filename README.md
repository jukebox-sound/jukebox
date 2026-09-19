# jukebox

`jukebox` is a GTK2/Perl music player and library browser for large local
music collections. It is derived from Quentin Sculo's gmusicbrowser and keeps
its configurable layouts, filters, queues, playlists, tag editing, and plugin
model while carrying project-specific maintenance and features.

The code intentionally remains on the GTK2/Perl stack. Distributions that no
longer ship the Perl Gtk2 bindings may therefore need to provide them
separately.

## Project-specific changes

Compared with the gmusicbrowser code from which it was forked, jukebox carries
changes including:

- Papirus-Light and Trinity-style icon sets;
- ArtistInfo improvements, including expanded Last.fm album information,
  external artist searches, local-collection reconciliation for similar
  artists, and GUI-managed Last.fm-to-local artist aliases;
- Notify plugin actions and action icons when supported by the notification
  daemon;
- an option to minimize the main window instead of hiding it;
- fixes for current mpv versions;
- the Spek spectrum-analysis plugin.

The original gmusicbrowser project is available at
<https://github.com/squentin/gmusicbrowser> and
<https://gmusicbrowser.org/>.

## Features

jukebox is centered on a persistent local music library. Major capabilities
include:

- GStreamer, mpv, mplayer, and command-line playback backends;
- configurable player, browser, tray, popup, desktop, and fullscreen layouts;
- nested library filters, saved playlists, queue mode, weighted random modes,
  and artist/album locks;
- mass tag editing and file renaming;
- multiple genres, labels, ratings, ReplayGain, and equalizer support;
- plugins for Last.fm, artist and album information, lyrics, notifications,
  MPRIS, multimedia keys, CD ripping, Spek, web context, and other optional
  integrations.

Installed layouts are ordinary text files and plugins are Perl modules. See
`jukebox-layouts(7)` and `jukebox-plugins(7)` for the corresponding formats.

## Runtime requirements

The core application requires Perl, GTK2, and the Perl `Gtk2`/`Glib` bindings,
in addition to modules that are part of the normal Perl installation. At
least one playback backend must also be available. The supported choices are:

- GStreamer 1.x with its Perl bindings and the plugins/codecs needed by the
  formats in the library;
- `mpv`;
- `mplayer`;
- command-line players such as `mpg321`, `ogg123`, and `flac123`.

The source still contains a GStreamer 0.10 backend for systems that provide the
old bindings, but GStreamer 1.x is the normal GStreamer path.

Some features have optional dependencies. Examples include `Net::DBus` for
DBus/MPRIS integration, `Gnome2::Wnck` for workspace integration,
`Gtk2::AppIndicator` for the AppIndicator plugin, notification bindings for
the Notify plugin, `spek` for spectrum analysis, and the external programs
selected by the CD-ripping plugin. A plugin reports its own missing runtime
requirements when the plugin loader has requirement metadata for them.

## Build and install

jukebox is an interpreted Perl application, so there is no compilation step.
The build step validates and generates manual pages from their maintained POD
sources.

```sh
make
make check
sudo make install
```

The default installation prefix is `/usr`. Paths are defined in `config.mk`
and can be overridden by the packager or on the command line. For example:

```sh
make PREFIX=/usr/local
sudo make PREFIX=/usr/local install
```

Distribution packaging should use `DESTDIR` rather than installing into the
build host directly:

```sh
make clean
make check
make DESTDIR="$pkgdir" PREFIX=/usr install
```

`make check-install` performs the same kind of staged installation under the
build directory and verifies representative installed files.

The install target places the executable in `bin`, application data under
`share/jukebox`, the desktop entry and scalable icon in their standard data
locations, generated manual pages under `share/man`, and project documentation
under `share/doc/jukebox`. It does not update desktop, MIME, or icon caches;
distribution package hooks should handle such system caches where required.

A direct source installation can be removed with:

```sh
sudo make uninstall
```

For packaged installations, use the distribution package manager instead.

## Configuration and library state

The default configuration directory is:

```text
$XDG_CONFIG_HOME/jukebox
```

When `XDG_CONFIG_HOME` is unset this is normally
`~/.config/jukebox`. For compatibility, jukebox falls back to an existing
legacy `~/.jukebox` directory when the XDG location does not yet exist.

`jukeboxrc` in that directory stores both preferences and persistent library
state. It is application-managed data rather than a conventional hand-written
configuration file; normal configuration should be performed through the GUI.
See `jukeboxrc(5)` for details.

User plugins may be placed in the `plugins` subdirectory of the configuration
directory. Additional plugin and layout directories can be supplied with
`jukebox -searchpath`.

## Documentation

The maintained manual sources are POD files in the repository. After
installation, the primary manuals are:

```text
jukebox(1)          command-line interface and files
jukeboxrc(5)        persistent configuration and library state
jukebox-layouts(7)  layout language and widgets
jukebox-plugins(7)  plugin metadata, lifecycle, and common interfaces
```

Use, for example:

```sh
man jukebox
man 5 jukeboxrc
man 7 jukebox-layouts
man 7 jukebox-plugins
```

Generated roff manual pages are build products and are deliberately not kept
as parallel source files in the repository.

## Development

Useful maintenance targets are:

```sh
make check          # validate POD and generated manual pages
make check-install  # stage and sanity-check an installation
make dist           # create a versioned source archive from HEAD
make clean
```

When adding a plugin, keep its runtime requirements in its `gmbplugin`
metadata and follow `jukebox-plugins(7)`. When adding or changing layout
syntax, update `jukebox-layouts.7.pod` together with the implementation.

## Migration from gmusicbrowser

jukebox and gmusicbrowser share ancestry, but their saved state should not be
assumed to be interchangeable. In particular, `jukeboxrc` contains library
metadata as well as preferences and has its own version marker. Keep a backup
and a separate configuration directory when experimenting with migration;
avoid rewriting the file with broad search-and-replace commands.

## License

jukebox is distributed under the GNU General Public License version 3. See
`COPYING` for the license text and `COPYRIGHT` for copyright notices.
