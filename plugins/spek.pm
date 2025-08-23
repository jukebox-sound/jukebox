# See COPYING and COPYRIGHT files for corresponding information.

=for gmbplugin Spek
name	Spek
title	Acoustic Spectrum Analyser plugin
desc	Adds Spek menu entry to song contextual menu
=cut

package GMB::Plugin::Spek;

use strict;
use warnings;

use constant {
	OPT => 'PLUGIN_Spek_',
};

::SetDefaultOptions(
	OPT,
	tocmd_label => 'Acoustic Spectrum Analyzer',
	tocmd_cmd   => 'spek %f',
);

my $ON;
my %menuentry = (
	tocmd => {
		label => sub {
			$::Options{OPT . 'tocmd_label'}
		},
		code => \&RunCommand,
		test => sub {
			my $c = $::Options{OPT . 'tocmd_cmd'};
			defined $c && $c ne '';
		},
		notempty => 'IDs',
	}
);

sub Start {
	$ON = 1;
	updatemenu();
}

sub Stop {
	$ON = 0;
	updatemenu();
}

sub prefbox {
	my $vbox = Gtk2::VBox->new(::FALSE, 2);
	my $sg1  = Gtk2::SizeGroup->new('horizontal');
	my $sg2  = Gtk2::SizeGroup->new('horizontal');

	my $entry1 = ::NewPrefEntry(
		OPT . 'tocmd_label',
		'Menu entry name:',
		width => 22,
		sizeg1 => $sg1,
		sizeg2 => $sg2,
		tip => "Name under which the command will appear in the menu"
	);

	my $entry2 = ::NewPrefEntry(
		OPT . 'tocmd_cmd',
		'System command:',
		width => 22,
		sizeg1 => $sg1,
		sizeg2 => $sg2,
		tip => "These fields can be used:\n"
			. ::MakeReplaceText('ftalydnAY')
			. "\n"
			. "In this case one command by file will be run\n\n"
			. 'Or you can use the field $files which will be replaced by the list of files, '
			. 'and only one command will be run'
	);

	my $check1 = ::NewPrefCheckButton(
		OPT . 'tocmd',
		'Execute custom command on selected files',
		cb => \&updatemenu,
		widget => ::Vpack($entry1, $entry2)
	);

	$vbox->pack_start($_, ::FALSE, ::FALSE, 2) for $check1;

	return $vbox;
}

sub updatemenu {
	my $removeall = !$ON;

	for my $eid (keys %menuentry) {
		my $menu  = \@::SongCMenu;
		my $entry = $menuentry{$eid};

		if (!$removeall && $::Options{OPT . $eid}) {
			push @$menu, $entry unless (grep $_ == $entry, @$menu);
		} else {
			@$menu = grep $_ != $entry, @$menu;
		}
	}
}

sub RunCommand {
	my $IDs = $_[0]{IDs} || $_[0]{filter}->filter;
	my $cmd = $::Options{OPT . 'tocmd_cmd'};

	::run_system_cmd($cmd, $IDs, 0);
}

1;

# End of file.
