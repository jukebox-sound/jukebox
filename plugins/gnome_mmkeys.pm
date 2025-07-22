# See COPYING and COPYRIGHT files for corresponding information.

=for gmbplugin GMMKEYS
name	Gnome mmkeys
title	Gnome multimedia keys plugin
desc	Makes jukebox react to the Next/Previous/Play/Stop multimedia keys in gnome.
req	perl(Net::DBus, libnet-dbus-perl perl-Net-DBus)
=cut

package GMB::Plugin::GMMKEYS;

use strict;
use warnings;

use Net::DBus;

my %Names = (
	gnome  => 'org.gnome.SettingsDaemon /org/gnome/SettingsDaemon/MediaKeys',

	# for gnome version until ~2.20  <2.22, I should probably remove it
	ognome => 'org.gnome.SettingsDaemon /org/gnome/SettingsDaemon',

	mate => 'org.mate.SettingsDaemon  /org/mate/SettingsDaemon/MediaKeys',
);

my $object;
for my $desktop (qw/gnome mate ognome/) {
	if ($object = GMB::DBus::simple_call($Names{$desktop})) {
		$object->connect_to_signal(MediaPlayerKeyPressed => \&callback);

		last;
	}
}

die "Can't find the dbus Settings Daemon for gnome or MATE\n" if $@;

my %cmd = (
	Previous => 'PrevSong',
	Next     => 'NextSong',
	Play     => 'PlayPause',
	Stop     => 'Stop',
);

sub Start {
	$object->GrabMediaPlayerKeys('jukebox', 0);
}

sub Stop {
	$object->ReleaseMediaPlayerKeys('jukebox');
}

sub prefbox { }

sub callback {
	my ($app, $key) = @_;

	return unless $app eq 'jukebox';

	if (my $cmd = $cmd{$key}) {
		::run_command(undef, $cmd);
	} else {
		warn "gnome_mmkeys : unknown key : $key\n"
	}
}

1;

# End of file.
