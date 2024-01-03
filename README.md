# nixos-remote-desktop-for-lxd

Demonstrate how to run a **NixOS** desktop environment in a **LXD** container.

This may comes in handy:

- to run a container instead of a virtual machine
- spin up isolated **desktop** workspaces within the same host(s)
- leverage **NixOS** declarative setup and configurations to replicate, manage and maintain effortlessly

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

### main content

Following packages are enabled and with minimal configuration to run:

- `gnome`: for desktop, display and windows management (can be replaced!)
- `xrdp`: for **remote desktop** access over `xserver`
- `auto-login`: enabled to avoid possible black screens
- `ssh`: on default port `22`
- few programs and utils (see `./config/programs.nix`)

### requirements

#### host

A host with a minimum of **4-8 CPU cores** available and **8-12 GiB** of RAM is recommended to allow **building** images, running at least **1 desktop container** and other services.

This may be tweaked up to preferences.

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

### build

**Builds** may take up quite some resources.  
Time and performance will vary based on the host configuration.

It is recommended to have at least **4 CPU cores** and **4 GiB** of RAM.

### container runtime

This has been tested with `limits.cpu=4` and `limits.memory=8GiB` configuration flags.

As running a desktop environment, the container will require more resources (than a server).  
Different `services.xserver.displayManager`, `services.xrdp.defaultWindowManager` or `services.xserver.desktopManager` can be set, up to the preferences.  
e.g: `xfce`, `plasma`, `lxde`, etc...

A different protocol may be used than the default `xrdp` set in the example.

---

---

# notes

### wayland

**Wayland** lacks **remote desktop** support.  
**X11** is used in this example.

### gdm

**GDM** may not seem to work as expected with at least **Gnome Desktop** and `xrdp` protocol.  
The example uses **SSDM** as an alternative.

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

A client may be able to login through `xserver` but the **desktop** and / or **window** manager or session fails.  
It will result in a **black screen** shortly after login into `xserver`.

This may be related to `services.xserver.displayManager`, `services.xrdp.defaultWindowManager` and / or `services.xserver.desktopManager` configurations.  
Current example has been tested and is expected working with `gnome`, `gnome-session` and `ssdm`.

Auto-login is needed to allow login into the desktop environment (enabled in the example in `./config/users.nix`).

```nix
{
  # auto-login
  services.xserver.displayManager.autoLogin = {
    enable  = true;
    user = MAIN_USER;
  };
}
```

---

---

# documentation and links

- https://discourse.nixos.org/t/howto-setup-lxd-on-nixos-with-nixos-guest-using-unmanaged-bridge-network-interface/21591
