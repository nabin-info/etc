#!/bin/bash
# vim: set ft=sh ts=2 sw=2 ai et fdm=indent:

wm_usage() {
  echo ''
  echo 'My .xinitrc uses WMNAME= to determine which WM to run'
  echo 'so you can just use WMNAME=dwm startx'
  echo ''
  exit 1
}
test -z "$WMNAME" && { wm_usage; }

cd_home() {
  cd ~
  local home="$(pwd)"
  [[ -z "$HOME" ]] && echo 'WARNING:  env-var "HOME" is empty !' >&2
  [[ "$home" != "$HOME" ]] && echo 'WARNING:  env-var "HOME" is not ~ !' >&2
}

load_Xdefaults() {
  userresources="${HOME}/.Xresources"
  usermodmap="${HOME}/.Xmodmap"
  sysresources="/etc/X11/xinit/.Xresources"
  sysmodmap="/etc/X11/xinit/.Xmodmap"
  xrdb -remove -all && {
    test -f "$sysresources"  && xrdb -merge "$sysresources"
    test -f "$sysmodmap"     && xmodmap     "$sysmodmap"
    test -f "$userresources" && xrdb -merge "$userresources"
    test -f "$usermodmap"    && xmodmap     "$usermodmap"
  }
}

fix_xkbmap() {
  #  (setxkbmap: see ~/.xkb/symbols/xkbtest)
  #  NOTE: ralt_switch_multikey: ALT+SHIFT (PRESSED) --> COMPOSE so
  #        is not needed anymore
  #  -option eurosign:e \
  #  -variant altgr-intl \
  
  setxkbmap \
    -variant basic \
    -option \
    -option compose:prsc \
    -option caps:escape \
    -option terminate:ctrl_alt_bkspc \
    -option terminate:ctrl_alt_bksp \
    -option nbsp:level3n

    #-option lv3:ralt_switch \
}

fix_keyboard() {
  fix_xkbmap
  xset c off
}

fix_tp_eraser() {
  local id="TPPS/2 IBM TrackPoint"
  xinput --set-button-map "$id"  1 2 3 4 5 0 0 0 0 0 0 0 0 0
  xinput --set-prop       "$id" "Evdev Middle Button Emulation"  0
  xinput --set-prop       "$id" "Evdev Third Button Emulation"   0
  xinput --set-prop       "$id" "Evdev Wheel Emulation"          1
  xinput --set-prop       "$id" "Evdev Wheel Emulation Button"   2
  xinput --set-prop       "$id" "Evdev Wheel Emulation Y Axis"   4 5
  xinput --set-prop       "$id" "Evdev Wheel Emulation X Axis"   6 7
}

fix_tp_touchpad() {
  local id="SynPS/2 Synaptics TouchPad"
  #xinput --set-prop "$id" "Device Enabled" 1
  #xinput --set-prop "$id" "Synaptics Off" 0
}

fix_lt_touchpad() {
  xinput --set-prop "Logitech K400" "Evdev Middle Button Emulation" 1
}

fix_mouse() {
  xset m 16/1 2
  syndaemon -d -R -i 0.5 -K
  fix_tp_eraser
  fix_tp_touchpad
  #fix_lt_touchpad
}

fix_display() {
  xset dpms 1800 3600 0
}

fix_sound() {
  ## systemd should be starting pulseaudio ...
  #pulseaudio -h >/dev/null \
  #  && pulseaudio --check || pulseaudio --start \
  #    || echo "[WARN]  Failed to start pulseaudio server."
  xset b 0
}

fix_fontpath() {
  ## ensure the following fonts are loading into the xserver
  #xset +fp /usr/share/fonts/local
  for d in /usr/share/fonts/*/ ; do xset +fp "$d" ; done
  xset fp rehash
}

start_urxvtd()   { 
  export RXVT_SOCKET=${HOME}/.urxvt/urxvtd-$(uuidgen)
  urxvtd -q -f -o 
}

start_tmux() { 
  setsid tmux start-server
}

start_netmgmt() { 
  echo "not doing anything"
}

start_dropboxd() {
  /opt/dropbox/dropboxd &
}

start_keyring()  {
  ## I can't get this to work outside of a true gnome environment
  ## ... that's because a proper program will start it as-needed ...
  gnome-keyring-daemon --start --foreground --components=secrets,gpg &
}

start_conky() {
  conky_start=$(ps ux | grep '\<conky\>')
  [[ -z "$conky_start" ]] && conky -c ~/.config/conky/conkyrc-rootwin
}


dwm_status() {
  case $1 in

    conky)
      export DWM_STATUS_LINE
      conky -c "${XDG_CONFIG_HOME}/conky/conkyrc.dwm" | \
      while read -r DWM_STATUS_LINE; do
        xsetroot -name "$DWM_STATUS_LINE"
      done &
      ;;

    bat_vol)
      while true; do
        acpi -a | grep off-line > /dev/null
        if [ $? -eq 0 ]; then
          dwm_bat="`acpi -b | awk '{ print $4 " " $5 }' | tr -d ',' `"
          dwm_vol="`amixer get Master | tail -1 | awk '{print $5}' | tr -d '[]'`"
          dwm_dat="`date +'%a, %b %d %R'`"
          xsetroot -name "Bat. $dwm_bat | Vol. $dwm_vol | "
        else
          dwm_vol="`amixer get Master | tail -1 | awk '{print $5}' | tr -d '[]'`"
          dwm_dat="`date +'%a, %b %d %R'`"
          xsetroot -name "Vol. $dwm_vol  | $dwm_dat"
        fi
        sleep 1
      done &
      ;;

    bat_date)
      while true; do
        batt="`acpi -b | tr -d '[a-z ]'` "
        xsetroot -name "$batt | `date +'%F %R'`"
        sleep 60
      done &
      ;;

    *)
      while true; do
        xsetroot -name "`date +'%F %R'` `uptime | sed 's/.*,//'`"
        sleep 60
      done &
      ;;

  esac
}

wm_dwm() {
  dwm_status 'bat_date'
  while true; do dwm || exit ; done
}

stop_sshagent() {
  ## I personally do not use ssh-agent because it seems exploitable
  ssh-agent -k
  rm -f "$ENVIRON";unset ENVIRON
  rm -f "$ENVIRON";unset SOCKET
  killall -e -u rnabinger -q -- ssh-agent
}


# Window Manager Launchers
wm_blackbox() { exec blackbox ; }
wm_openbox()  { exec openbox-session ; }
wm_icewm()    { exec icewm-session ; }
wm_e17()      { exec enlightenment_start ; }
wm_wmii()     { exec wmii ; }
wm_awesome()  { exec awesome ; }
wm_i3()       { exec i3 ; }
wm_notion()   { exec notion ; }
wm_wmaker()   { exec wmaker ; }
wm_xfce4()    { exec xfce4-session ; }
wm_xmonad()   { exec xmonad ; }
wm_cinnamon() { cinnamon ; }
wm_twm() {
  twm &
  xclock     -geometry 50x50-1+1 &
  xterm      -geometry 80x50+494+51 &
  xterm      -geometry 80x20+494-0 &
  exec xterm -geometry 80x66+0+0 -name login
}

# Main Execution 
# ==============

# Perform Startup Tasks 
# ---------------------
cd_home
load_Xdefaults
fix_fontpath
fix_keyboard
fix_mouse
fix_display
fix_sound
stop_sshagent
start_urxvtd
start_netmgmt
#start_tmux
#start_keyring
#start_conky
#start_dropboxd
cd_home

# Load the Window Manager
# -----------------------
if [[ -z "$WMNAME" ]] 
then
  wm_usage
  exit 1
fi

eval wm_${WMNAME}

