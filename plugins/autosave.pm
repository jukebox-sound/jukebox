# See COPYING and COPYRIGHT files for corresponding information.

=for gmbplugin AUTOSAVE
name	Autosave
title	Autosave plugin
=cut

package GMB::Plugin::AUTOSAVE;

use strict;
use warnings;

use constant {
	OPT => 'PLUGIN_AUTOSAVE_',
};

my $savesub = $::Command{Save}[0];
my $handle;

::SetDefaultOptions(
	OPT,
	minutes => 15
);

sub Start {
	$handle = Glib::Timeout->add(
		$::Options{OPT . 'minutes'} * 60000,
		sub {
			$savesub->();
			1
		}
	);
}

sub Stop {
	Glib::Source->remove($handle);
	$handle = undef;
}

sub prefbox {
	my $vbox = Gtk2::VBox->new(::FALSE, 2);

	my $spin = ::NewPrefSpinButton(
		OPT . 'minutes',
		1,
		60 * 24,
		step => 1,
		page => 15,
		cb => sub {
			Stop() if $handle;
			Start();
		},
		text => "Save tags/settings every %d minutes"
	);

	my $button = Gtk2::Button->new("Save now");
	$button->signal_connect(clicked => $savesub);

	$vbox->pack_start($_, ::FALSE, ::FALSE, 2) for $spin, $button;

	return $vbox;
}

1;

# End of file.
