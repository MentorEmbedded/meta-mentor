python override_gnome_terminal () {
    oe_import(d)
    import oe.terminal
    import oe.terminal_override
    oe.terminal.Gnome = oe.terminal_override.Gnome
}
override_gnome_terminal[eventmask] = "bb.event.ConfigParsed"
addhandler override_gnome_terminal
