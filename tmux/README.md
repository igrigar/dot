# Configuration file for Tmux

Full cheatsheet for Tmux using this config file.

## Managing Tmux from the terminal

* Start new: `tmux`
* Start new with session name: `tmux new -s <name>`
* Attach: `tmux <a|at|attach>`
* Attach to named session: `tmux a -t <name>`
* List sessions: `tmux <ls|list-sessions>`
* Kill session: `tmux kill-session -t myname`
* Kill all the sessions: `tmux ls | grep : | cut -d. -f1 | awk '{print
  substr($1, 0, length($1)-1)}' | xargs kill`


## Inside Tmux

The prefix is the key that precedes a command inside Tmux. In this specigic
configuration is <C-Space>. Now on all the commands shown are preceded by the
prefix.

### Windows (tabs)

* c: new window.
* w: list windows.
* n: next window.
* p: previous window.
* f: find window.
* ,: name window.
* &: kill window.

### Panes (splits)

* v: vertical split.
* s: horizontal split.
* o: swap panes.
* x: kill panes.
* +: break pane into window.
* -: restore pane from window.
* q: show panes number then select the number to move there.
* z: zoom. The current pane is set full screen, if already there, fallback.
* h: move to left pane.
* j: move to down pane.
* k: move to up pane.
* l: move to left pane.
* <C-UP>, <C-DOWN>: resize pane vertically.
* <C-LEFT>, <C-RIGHT>: resize pane horizontally.
