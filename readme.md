# Realist's Hyprland Minimalistic Desktop [ RHMD ] on Gentoo Linux

## About this project

This project contains complete installation commands and config files for create Gentoo linux with Hyperland desktop for Web Developers.

## Final desktop One monitor screenshot

<img src="one_screen.png" alt="One Monitor Screen" />

## Grub background

<img src="grub.png" alt="grub-screen" />

## Create install environment

### Partitions
SSD / SATA Disk

```
parted -s /dev/sda mklabel gpt && parted -a optimal /dev/sda
```

#### Parted commands

```
unit mib
mkpart primary fat32 1 150
name 1 UEFI
set 1 bios_grub on
mkpart primary 150 -1
name 2 ROOT
quit
```

SSD or SATA disk (Virtualbox)

```
mkfs.fat -n UEFI -F32 /dev/sda1 && mkfs.f2fs -l ROOT -O extra_attr,inode_checksum,sb_checksum -f /dev/sda2
```

```
mkdir -p /mnt/gentoo && mount -t f2fs /dev/sda2 /mnt/gentoo
```

```
mkdir -p /mnt/gentoo/boot && mount /dev/sda1 /mnt/gentoo/boot
```

### Stage3 and config portage

```
cd /mnt/gentoo
```

```
wget https://distfiles.gentoo.org/releases/amd64/autobuilds/20240514T170404Z/stage3-amd64-openrc-20240514T170404Z.tar.xz
```

```
tar xpf stage3-amd64-openrc-20240514T170404Z.tar.xz --xattrs-include='*.*' --numeric-owner
```

```
mkdir -p /mnt/gentoo/var/db/repos/gentoo && mkdir -p /mnt/gentoo/etc/portage/repos.conf
```

```
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/
```

```
cp /etc/resolv.conf /mnt/gentoo/etc/
```

### Mounting important system FS

```
mount -t proc none /mnt/gentoo/proc && mount -t sysfs none /mnt/gentoo/sys
```

```
mount --rbind /sys /mnt/gentoo/sys && mount --make-rslave /mnt/gentoo/sys
```

```
mount --rbind /dev /mnt/gentoo/dev && mount --make-rslave /mnt/gentoo/dev
```

```
mount --rbind /run /mnt/gentoo/run && mount --make-rslave /mnt/gentoo/run
```

```
test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
```

```
mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm && chmod 1777 /dev/shm
```

### Chroot to prepared system

```
chroot /mnt/gentoo /bin/bash && env-update && source /etc/profile
```

### Sync and config portage

```
emerge-webrsync
```

```
cd /etc/portage/
```

```
rm make.conf && rm -R package.use && rm -R package.accept_keywords && rm -R package.mask
```

### File - /etc/portage/make.conf

```
wget https://raw.githubusercontent.com/lotrando/realist-hyprland-desktop/main/make.conf
```

```
# RHMD - Realist Hyperland Minimal Desktop LTO & GPO version
# make.conf file (c) 2022 -> /etc/portage/make.conf

USE="alsa dbus elogind jpeg libnotify png pulseaudio pipewire nls vulkan wayland -X"
CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sse sse2 sse3 sse4_1 sse4_2 ssse3"

COMMON_FLAGS="-O2 -pipe -fomit-frame-pointer"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
MAKE_OPTS="-j6"

GENTOO_MIRRORS="https://mirror.dkm.cz/gentoo/"
PORTAGE_BINHOST="http://94.113.201.164:55/hyprland"
PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"
PORTAGE_NICENESS=19
PORTAGE_IONICE_COMMAND="ionice -c 3 -p \${PID}"
EMERGE_DEFAULT_OPTS="-v --ask-enter-invalid --jobs=1 --load-average=6"
FEATURES="downgrade-backup parallel-fetch sign"

ACCEPT_KEYWORDS="amd64"
ACCEPT_LICENSE="-* @FREE"
GRUB_PLATFORMS="pc efi-64"

LC_ALL=C
LC_MESSAGES=C
L10N="cs"

INPUT_DEVICES="libinput"
VIDEO_CARDS="amdgpu radeonsi"
```

### File - /etc/portage/package.accept_keywords

```
wget https://raw.githubusercontent.com/lotrando/realist-hyprland-desktop/main/package.accept_keywords
```

```
# RHMD - Realist Hyperland Minimal Desktop LTO & GPO version
# package.accept_keywords file -> /etc/portage/package.accept_keywords

# Hyprland
gui-apps/hyprlock ~amd64
gui-apps/hypridle ~amd64
gui-libs/xdg-desktop-portal-hyprland ~amd64
gui-apps/hyprpaper ~amd64
gui-apps/hyprpicker ~amd64
gui-apps/waybar ~amd64
gui-apps/swaync ~amd64
gui-apps/rofi-wayland ~amd64
gui-wm/hyprland-contrib ~amd64
dev-cpp/sdbus-c++ ~amd64
gui-apps/nwg ~amd64
app-misc/nwg-look ~amd64
app-misc/nwg-shell-wallpapers ~amd64
gui-apps/nwg-displays ~amd64
gui-apps/nwg-dock ~amd64
gui-apps/nwg-drawer ~amd64
gui-apps/nwg-icon-picker ~amd64
gui-apps/nwg-menu ~amd64
gui-apps/nwg-panel ~amd64
gui-apps/nwg-shell ~amd64
gui-apps/nwg-shell-config ~amd64
sci-geosciences/geopy ~amd64
dev-python/geographiclib ~amd64
dev-python/i3ipc ~amd64
dev-python/dasbus ~amd64
gui-apps/wlr-randr ~amd64
x11-apps/xcur2png ~amd64
gui-apps/nwg-dock-hyprland ~amd64
gui-apps/azote ~amd64
dev-python/colorthief ~amd64

# APP-EDITORS
app-editors/sublime-text ~amd64
app-editors/vscode ~amd64

# APP-EMULATORS
app-emulation/fs-uae ~amd64
app-emulation/fs-uae-launcher ~amd64

# APP-MISC
app-misc/radeontop ~amd64
app-misc/ca-certificates ~amd64
app-misc/ufetch ~amd64

# DEV-PHP
dev-php/ca-bundle ~amd64
dev-php/composer ~amd64
dev-php/json-schema ~amd64
dev-php/jsonlint ~amd64
dev-php/metadata-minifier ~amd64
dev-php/phar-utils ~amd64
dev-php/php ~amd64
dev-php/psr-log ~amd64
dev-php/semver ~amd64
dev-php/spdx-licenses ~amd64
dev-php/symfony-config ~amd64
dev-php/symfony-console ~amd64
dev-php/symfony-dependency-injection ~amd64
dev-php/symfony-event-dispatcher ~amd64
dev-php/symfony-filesystem ~amd64
dev-php/symfony-finder ~amd64
dev-php/symfony-process ~amd64
dev-php/xdebug-handler ~amd64

# DEV-PYTHON
dev-python/python-lhafile ~amd64
dev-python/sphinx ~amd64

# SYS-KERNEL
sys-kernel/zen-sources ~amd64

# APP-SHELLS
app-shells/oh-my-zsh ~amd64
app-shells/zsh-autosuggestions ~amd64
app-shells/zsh-syntax-highlighting ~amd64

# DEV-LANG
dev-lang/php ~amd64

# DEV-UTIL
dev-util/ragel ~amd64
dev-util/colm ~amd64
dev-util/jetbrains-toolbox ~amd64

# GNOME-EXTRA
gnome-extra/yad ~amd64

# NET-MISC
net-misc/youtube-viewer ~amd64

# MEDIA-VIDEO
media-video/obs-studio ~amd64
media-video/pipewire ~amd64
media-video/wireplumber ~amd64

# MEDIA-TV
media-tv/plex-media-server ~amd64

# SYS-APSS
sys-apps/eza ~amd64

# WWW-CLIENT
www-client/microsoft-edge ~amd64

# X11-BASE
x11-base/xcb-proto ~amd64

# X11-LIBS
x11-libs/libfm ~amd64
x11-libs/libxcb ~amd64

# X11-MISC
x11-misc/notify-osd ~amd64
x11-misc/pcmanfm ~amd64

# X11-THEMES
x11-themes/elementary-xfce-icon-theme ~amd64
x11-themes/notify-osd-icons ~amd64
```

### File - /etc/portage/package.use

```
wget https://raw.githubusercontent.com/lotrando/realist-hyprland-desktop/main/package.use
```

```
# RHMD - Realist Hyperland Minimal Desktop LTO & GPO version
# package.use file -> /etc/portage/package.use

# APP-ADMIN
app-admin/sudo -sendmail

# APP-EDITORS
app-editors/nano magic

# APP-ESELECT
app-eselect/eselect-php apache2 fpm

# APP-MISC
app-misc/mc nls -slang unicode gpm sftp

# APP-TEXT
app-text/evince djvu tiff
app-text/ghostscript-gpl cups
app-text/poppler cairo
app-text/xmlto text

# DEV-CPP
dev-cpp/gtkmm X
dev-cpp/cairomm X

# DEV-DB
dev-db/mysql -perl
dev-db/sqlite tools

# DEV-LANG
dev-lang/php apache2 bcmath curl fpm gd mysql mysqli pdo soap sockets spell sqlite xmlreader xmlwriter zip
dev-lang/python lto pgo

# DEV-LIBS
dev-libs/elfutils lzma zstd
dev-libs/libxml2 icu
dev-libs/sexp static-libs

# DEV-PYTHON
dev-python/PyQt5 -bluetooth dbus declarative gui multimedia network opengl printsupport svg widgets
dev-python/pillow webp tiff

# DEV-VCS
dev-vcs/git -perl

# DEV-QT
dev-qt/qtmultimedia widgets
dev-qt/qtbase opengl
dev-qt/qtgui egl vulkan

# GNOME-BASE
gnome-base/gvfs cdda http udisks nfs archive

# GUI-APPS
gui-apps/rofi-wayland drun windowmode
gui-apps/swaybg gdk-pixbuf
gui-apps/waybar pulseaudio udev network tray upower wifi
gui-apps/nwg hyprland

# GUI-LIBS
gui-libs/wlroots x11-backend tinywl
gui-libs/gtk-layer-shell vala introspection

# MEDIA-FONTS
media-fonts/terminus-font -ru-g
media-fonts/fontawesome ttf

# MEDIA-GFX
media-gfx/gimp jpeg2k jpegxl udev vector-icons webp wmf xpm
media-gfx/imagemagick djvu lzma raw svg truetype zip xml
media-gfx/inkscape exif imagemagick svg2

# MEDIA-LIBS
media-libs/audiofile flac
media-libs/flac ogg
media-libs/gegl cairo
media-libs/harfbuzz icu
media-libs/libsdl opengl
media-libs/libsdl2 haptic opengl gles2
media-libs/libsndfile minimal
media-libs/libvpx postproc
media-libs/mesa d3d9 lm-sensor wayland

# MEDIA-PLUGINS
media-plugins/alsa-plugins pulseaudio
media-plugins/audacious-plugins aac cdda cue flac http lame libnotify modplug mp3 sndfile vorbis wavpack

# MEDIA-SOUND
media-sound/mpg123 -pulseaudio
media-sound/pulseaudio alsa-plugin -bluetooth -daemon

# MEDIA-VIDEO
media-video/ffmpeg mp3 sdl svg truetype v4l opus vorbis webp x264 xvid
media-video/pipewire sound-server v4l -bluetooth

# NET-LIBS
net-libs/nodejs lto

# NET-IM
net-im/qtox notification

# NET-MISC
net-misc/networkmanager modemmanager -bluetooth dhcpcd iptables lto resolvconf

# NET-P2P
net-p2p/transmission gtk -qt5 -qt6

# SYS-BOOT
sys-boot/grub mount

# SYS-DEVEL
sys-devel/gcc graphite lto pgo

# SYS-KERNEL
sys-kernel/linux-firmware initramfs
sys-kernel/zen-sources symlink

# SYS-FS
sys-fs/squashfs-tools lz4 lzma lzo zstd

# SYS-LIBS
sys-libs/zlib minizip

# WWW-CLIENT
www-client/firefox lto pgo
www-client/microsoft-edge qt5

# X11-LIBS
x11-libs/cairo X
x11-libs/libdrm video_cards_radeon
x11-libs/motif xft
x11-libs/gtk+ wayland X
x11-libs/libxkbcommon X
```

### Edit file - /etc/portage/package.license

```
wget https://raw.githubusercontent.com/lotrando/realist-hyprland-desktop/main/package.license
```

```
# RHMD - Realist Hyperland Minimal Desktop LTO & GPO version
# package.license file -> /etc/portage/package.license

# APP-EDITORS
app-editors/sublime-text Sublime
app-editors/vscode Microsoft-vscode

# APP-ARCH
app-arch/rar RAR

# DEV-UTIL
dev-util/jetbrains-toolbox JetBrainsToolbox

# MEDIA-FONTS
media-fonts/corefonts MSttfEULA

# SYS-KERNEL
sys-kernel/linux-firmware linux-fw-redistributable no-source-code

# WWW-CLIENT
www-client/microsoft-edge-beta microsoft-edge
www-client/microsoft-edge microsoft-edge
```

### Edit file - /etc/portage/package.mask

```
wget https://raw.githubusercontent.com/lotrando/realist-hyprland-desktop/main/package.mask
```

```
# RHMD - Realist Hyperland Minimal Desktop LTO & GPO version
# package.mask file -> /etc/portage/package.mask

# // some custom masked package //
```

```
sed -i 's/UTC/local/g' /etc/conf.d/hwclock
```

### Edit file - /etc/fstab

```
nano /etc/fstab
```

## SSD or SATA Disk

```
/dev/sda1         /boot   vfat    noatime       0 2
/dev/sda2         /       f2fs    defaults,rw   0 0
```

```
sed -i 's/localhost/hyprland/g' /etc/conf.d/hostname
```

```
sed -i 's/default8x16/ter-v16b/g' /etc/conf.d/consolefont
```

```
sed -i 's/us/cs/g' /etc/conf.d/keymaps
```

```
sed -i 's/127.0.0.1/#127.0.0.1/g' /etc/hosts
```

```
echo "127.0.0.1 hyprland.gentoo.dev hyprland localhost" >> /etc/hosts
```

### Edit file - /etc/locale.gen

```
nano /etc/locale.gen
```

```
cs_CZ.UTF-8 UTF-8
cs_CZ ISO-8859-2
```

### Edit file - /etc/env.d/02locale

```
nano /etc/env.d/02locale
```

```
LANG="cs_CZ.UTF-8"
LC_COLLATE="C"
```

```
echo "Europe/Prague" > /etc/timezone
```

### Create locale

```
locale-gen
```

```
eselect locale set 7
```

```
env-update && source /etc/profile
```

```
export PS1="(chroot) ${PS1}"
```

### Edit file - /etc/conf.d/net

## Static network (variable, default dhcp)

```
nano /etc/conf.d/net
```

```
config_enp0s3="192.168.0.30 netmask 255.255.255.0"
routes_enp0s3="default via 192.168.0.1"
```

```
cd /etc/init.d/
```

```
ln -s net.lo net.enp0s3
```

### Create user (replace realist and toor with custom user and password)

```
useradd -m -G audio,video,usb,cdrom,portage,users,wheel -s /bin/bash realist
```

```
echo "root:toor" | chpasswd -c SHA256
```

```
echo "realist:toor" | chpasswd -c SHA256
```

## Compiling phase

### Create kernel ( ZEN Sources recommended )

```
emerge -g genkernel linux-firmware zen-sources && genkernel all
```

### Install important system packages

```
emerge hcpcd grub usbutils terminus-font sudo f2fs-tools app-misc/mc dev-vcs/git eselect-repository --noreplace nano

eselect repository enable mv guru
emaint sync -R mv guru

emerge oh-my-zsh gentoo-zsh-completions zsh-completions
```

### Install oh-my-zsh plugins and theme

```
git clone https://github.com/romkatv/powerlevel10k.git /usr/share/zsh/site-contrib/oh-my-zsh/custom/themes/powerlevel10k
```

```
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/site-contrib/oh-my-zsh/custom/plugins/zsh-autosuggestions
```

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/site-contrib/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

## Configurations

### Grub

```
nano /etc/default/grub
```

```
GRUB_GFXMODE=1920x1080x32
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_BACKGROUND="/boot/grub/grub.png"
GRUB_DISABLE_OS_PROBER=0
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
```

### Sudo

```
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
```

### USER - dotfiles setting

```
cd /home/realist
```

```
chown -R realist:realist /home/realist/
```

### Change default shell to OH-MY-ZSH

```
chsh -s /bin/zsh root && chsh -s /bin/zsh realist
```

### Grub Install
SSD or SATA Disk

```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=HYPRLAND --recheck /dev/sda
```

```
cd /boot/grub && wget -q wget https://raw.githubusercontent.com/lotrando/realist-hyprland-desktop/main/grub.png
```

```
grub-mkconfig -o /boot/grub/grub.cfg
```

### Run daemons

```
rc-update add elogind boot && rc-update add consolefont default && rc-update add numlock default
```

```
rc-update add sshd default && rc-update add dbus default && rc-update add alsasound default
```

```
rc-update add dhcpcd default
```

```
rc-update add NetworkManager default
```

### Store volume

```
alsactl store
```

### Cleaning and reboot to Xmonad desktop

```
cd / && umount -R /mnt/gentoo && reboot
```

# Keybinding of Xmonad desktop

| Keys                | Function                                                 |
| ------------------- | -------------------------------------------------------- |
| Win-Shift-Enter     | Rofi Drun                                                |
| Win-Shift-Backspace | Rofi Apps                                                |
| Win-Shift-p         | Rofi Powermenu                                           |
| Win-Shift-r         | Xmonad Restart                                           |
| Win-Shift-q         | Xmonad Quit                                              |
| Win-Shift-c         | Kill focused window                                      |
| Win-Shift-a         | Kill all windows on current workspace                    |
| Win-Enter           | Run URxvt                                                |
| Win-Alt-b           | Run Firefox                                              |
| Win-Alt-e           | Run Sublime                                              |
| Win-Alt-f           | Run Pcmanfm                                              |
| Win-Alt-t           | Run Btop                                                 |
| Win-Alt-m           | Run Pulsemixer                                           |
| Win-d               | Decrease window spacing                                  |
| Win-i               | Increase window spacing                                  |
| Win-Shift-d         | Decrease screen spacing                                  |
| Win-Shift-i         | Increase screen spacing                                  |
| Win-h               | Shrink horiz window width                                |
| Win-l               | Expand horiz window width                                |
| Win-Alt-j           | Shrink vert window width                                 |
| Win-Alt-k           | Expand vert window width                                 |
| Win-m               | Move focus to the master window                          |
| Win-j               | Move focus to the next window                            |
| Win-k               | Move focus to the prev window                            |
| Win-.               | Switch focus to next monitor                             |
| Win-,               | Switch focus to prev monitor                             |
| Win-Shift-Right     | Shifts focused window to next Workspace                  |
| Win-Shift-Left      | Shifts focused window to prev Workspace                  |
| Win-f               | Toggles my 'floats' layout                               |
| Win-t               | Push floating window back to tile                        |
| Win-Shift-t         | Push ALL floating windows to tile                        |
| Win-Tab             | Switch to next layout                                    |
| Win-Space           | Toggles noborder/full                                    |
| Win-Shift-n         | Toggles noborder                                         |
| Win-Shift-m         | Swap the focused window and the master window            |
| Win-Shift-j         | Swap focused window with next window                     |
| Win-Shift-k         | Swap focused window with prev window                     |
| Win-Backspace       | Moves focused window to master, others maintain order    |
| Win-Shift-Tab       | Rotate all windows except master and keep focus in place |
| Win-Ctrl-Tab        | Rotate all the windows in the current stack              |
