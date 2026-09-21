# See COPYING and COPYRIGHT files for corresponding information.

=for gmbplugin AppIndicator
name	App indicator
title	App Indicator plugin
desc	Displays a panel indicator in some desktops
req	perl(Gtk2::AppIndicator, libgtk2-appindicator-perl perl-Gtk2-AppIndicator)
=cut

######################################################################
# GMB::Plugin::AppIndicator                                          #
######################################################################

package GMB::Plugin::AppIndicator;

use strict;
use warnings;

use constant {
	OPT => 'PLUGIN_AppIndicator_',
};

use Gtk2::AppIndicator;

::SetDefaultOptions(
	OPT,
	MiddleClick => 'playpause'
);

# action when middle-clicking on icon, must correspond to an id in the tray menu (@::TrayMenu)
my %mactions = (
	playpause => "Play/Pause",
	showhide  => "Show/Hide",
	next      => "Next",
);

my $indicator;

sub Start {
	$indicator ||= Gtk2::AppIndicator->new(::PROGRAM_NAME, 'jukebox', 'application-status');

	# events that requires updating the traymenu :
	::Watch($indicator, $_ => \&QueueUpdate) for qw/Lock Playing Windows/;

	# FIXME needs initialization #deactivated because it can't work for now
	#::Watch($indicator, $_=> \&UpdateIcon) for qw/Playing Icons/; 

	QueueUpdate();
}

sub Stop {
	::UnWatch_all($indicator);
	$indicator->get_menu->destroy;

	# can't find how to destroy it, so hide it and reuse it if plugin reactivated
	$indicator->set_passive; 
}

sub prefbox {
	my $vbox = Gtk2::VBox->new(::FALSE, 2);

	my $middleclick = ::NewPrefCombo(
		OPT . 'MiddleClick',
		\%mactions,
		text => "Middle-click action :",
		cb   => \&Update
	);

	my $warning = Gtk2::Label->new_with_format(
		"<i>%s</i>",
		"(The middle-click action doesn't work correctly in some desktops)"
	);

	$vbox->pack_start($_, ::FALSE, ::FALSE, 2) for $middleclick, $warning;

	return $vbox;
}

sub QueueUpdate {
	::IdleDo('2_AppIndicator', 500, \&Update);
}

sub Update {
	delete $::ToDo{'2_AppIndicator'};

	return unless $indicator;

	my $menu = ::BuildMenu(\@::TrayMenu);
	$menu->show_all;
	$indicator->set_active;
	$indicator->set_menu($menu);
	my ($menuentry) = grep $_->{id} && $_->{id} eq $::Options{OPT . 'MiddleClick'}, $menu->get_children;
	$indicator->set_secondary_activate_target($menuentry) if $menuentry;
}


######################################################################
# Gtk2::AppIndicator                                                 #
######################################################################

#patch for typo in Gtk2::AppIndicator
package Gtk2::AppIndicator;

sub set_secondary_activate_target {
	my $self   = shift;
	my $widget = shift;
	$self->{secondary} = $widget;
	appindicator_set_secondary_activate_target($self->{ind}, $widget);
}

1;

# End of file.
