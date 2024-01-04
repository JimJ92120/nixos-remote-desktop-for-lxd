# nixos-remote-desktop-for-lxd

Demonstrate how to run a **NixOS** desktop environment in a **LXD** container.

This may comes in handy:

- to run a container instead of a virtual machine
- spin up isolated **desktop** workspaces within the same host(s)
- leverage **NixOS** declarative setup and configurations to replicate, manage and maintain effortlessly

---

![image](https://github.com/JimJ92120/nixos-remote-desktop-for-lxd/assets/57893611/710dbb2e-b39e-4af9-8a14-d1c46d1a9fb2)  

Plasma5, XFCE example:  
![image](https://github.com/JimJ92120/nixos-remote-desktop-for-lxd/assets/57893611/78c7ed0b-e1eb-4d93-9aa5-d76b33729891)


---

**NixOS** image is not available in **LXD** images repository.  
A dedicated image must be run.

Thanks to the following guide, some `build-image.sh` is available to build the **NixOS** image (desktop or server):  
https://discourse.nixos.org/t/howto-setup-lxd-on-nixos-with-nixos-guest-using-unmanaged-bridge-network-interface/21591

---

**Notes**:  
The example is minimally configured.  
Additional steps may be required for security, networking, etc...

---

---

# introdction

The current **NixOS** configuration will setup a desktop environment.  
However same base configuration may be used for server, by removing desktop related settings.

The default user can be set in `./config/users.nix`.  
Default username is `nixos`, password `nixos`! (see `./config/users.nix`)

Following packages are enabled and with minimal configuration to run:

- `xfce`: for desktop, display and windows management (can be replaced!)
- `xrdp`: for **remote desktop** access over `xserver`
- `ssh`: on default port `22`
- few programs and utils (see `./config/programs.nix`)

### desktop manager examples

`./config/modules/` directory contains "basic" configuration for different **desktop manager**, **display manager**, etc..."ready to use" for **remote desktop** access (over `xrdp`).

Following examples are present:

| desktop manager             | display manager | window manager    | wayland support |
| --------------------------- | --------------- | ----------------- | --------------- |
| `xfce` (default in example) | `gdm`           | `xfce4-session`   | yes             |
| `gnome`                     | `gdm`           | `gnome-session`   | yes             |
| `plasma5`                   | `sddm`          | `startplasma-x11` | no              |

### remote desktop protocol

`xrdp` is configured in `./config/xrdp.nix`.

Other protocols or tools may be used instead, e.g: `vnc`, `guacamole`, etc...

---

---

# requirements

#### host

A host with a minimum of **4-8 CPU cores** available and **8-12 GiB** of RAM is recommended to allow **building** images, running at least **1 desktop container** and other services.

This may be tweaked up to preferences.

Host used for example was using **Wayland**.

#### remote desktop client

Any remote desktop client application using the declared protocol (`xrdp` is used here).

---

---

# how to

### build the image

To build the image, run the following:

```sh
# path to configuration.nix
NIXOS_CONFIGFILE=""
# a name for the image generated
IMAGE_NAME=""

./build-image.sh $NIXOS_CONFIG_FILE $IMAGE_NAME

### additional commands

# delete image
lxc image delete $IMAGE_NAME || echo true
```

### run the container

```sh
# the previously generated image name
IMAGE_NAME=""
# a name for the container generated
CONTAINER_NAME=""

# `c limits.cpu=4 -c limits.memory=8GiB` for desktop!
# `-c security.nesting=true`` to run `nix` in the container
# --profile=my-desktop-profile maybe add some profile?
lxc launch $IMAGE_NAME $CONTAINER_NAME -c limits.cpu=4 -c limits.memory=8GiB -c security.nesting=true

### additional commands

# start container
lxc start $CONTAINER_NAME

# stop container
lxc stop $CONTAINER_NAME

# delete
lxc delete $CONTAINER_NAME # use `--force` flag if running

# shell (or exec /some/commands/)
lxc exec $CONTAINER_NAME /bin/sh

# delete an image
lxc image delete $IMAGE_NAME
```

### remote desktop access

Use any client(s) of your choice.

This has been tested on [**Remmina**](https://remmina.org/), from the host running the container in it.

Host `ipv4` can displayed using:

```sh
$CONTAINER_NAME=""

lxc list

# or
lxc config show $CONTAINER_NAME
```

---

---

# performance

The example configuration has been ran on an host with **I7 - 11th gen CPU** and **24 GiB** of RAM.  
Additional **LXD** containers were running as well.

While image `./build-image.sh` still takes few minutes (~ 5 minutes), **remote desktop** seems to works fine.  
Also with multiple **remote desktop** connections opened.

### build

**Builds** may take up quite some resources.  
Time and performance will vary based on the host configuration.

It is recommended to have at least **4 CPU cores** and **4 GiB** of RAM.

### container runtime

This has been tested with `limits.cpu=4` and `limits.memory=8GiB` configuration flags.

As running a desktop environment, the container will require more resources (than a server).  
Different `services.xserver.displayManager`, `services.xrdp.defaultWindowManager` or `services.xserver.desktopManager` can be set, up to the preferences.  
e.g: `xfce`, `plasma`, `lxde`, `gnome` etc...

A different protocol may be used than the default `xrdp` set in the example.

---

---

# notes

### wayland

**Wayland** lacks **remote desktop** support.  
It is disabled by default in the `./config/modules/` examples for better compatibility.

It may be enabled / disabled as followed:

```nix
{
  # e.g for GDM
  displayManager = {
    gdm = {
      # `false` for X11
      wayland = true;
    };
  };
}
```

### networking

In some cases, the created container may not have any `ipv4` address assigned.

This may be enabled adding the following in `configuration.nix` (enabled `./config.networking.nix`):

```nix
# "standard" dhcp, inherited from host / lxd networking usually
networking.useDHCP = lib.mkForce true;

### or

# dhcp from container interface
networking.interfaces.eth0.useDHCP = true;
# must be false, else 2 address are assigned
networking.useDHCP = lib.mkForce false;
```

### possible "black screen"

Please read: https://c-nergy.be/blog/?p=16682

It is possible that on first boot, an initial "default" login occurs.  
Issue seems to occur quite often with `gnome`.

Note that, based on the host configuration, window may just be loading (for a while).

To verify which users are logged in, run the following (from host):

```sh
$CONTAINER_NAME=""

# list all `logged in` users
lxc exec $CONTAINER_NAME /bin/who

### or

# access container shell
lxc exec $CONTAINER_NAME /bin/sh # unless /bash is set?

# then
sudo who
```

**Note**:  
If it's the first ever boot / log in attempt, container may be rebooted from within:

```sh
CONTAINER_NAME=""

# access container shell
lxc exec $CONTAINER_NAME /bin/sh

# then
sudo reboot
```

And try to log in to **remote desktop** client again.

```

---

---

# documentation and links

- https://discourse.nixos.org/t/howto-setup-lxd-on-nixos-with-nixos-guest-using-unmanaged-bridge-network-interface/21591
```
