# [Dot Files](https://gitlab.com/njdart/dot-files)

I use BSPWM on Arch linux on both my desktop and laptops, here are some configurations for them :)

I've tried to automate this as much as possible. Running the `setup.py` file should symlink everything into place.

## Installing packages

```
# put all explicitly installed packages (minus AUR) into a file
# can be run as user
pacman -Qqe | grep -Fvx "$(pacman -Qqm)" > ./packages

# reinstall from said file (deps will be pulled in automatically)
# must run as root
xargs pacman -S --needed --noconfirm < ./packages
```

## Installing Configs

    ./setup.py

## Pulseaudio

Enable the user-speciffic unit file;

```bash
systemctl --user enable pulseaudio
```

## VSCode

To get a list of extensions, prefixed with the install command, run;

```
code --list-extensions | xargs -L 1 echo code --install-extension
```

## Dockerfile

```
docker run --rm -it registry.gitlab.com/njdart/dot-files:latest
```

Or use a monthly image tag, eg `feb-2024`, or a (short) commit sha, eg `fef2dc5`

## Kubectl

See the `kubectl-debug` alias in [.zshrc](.zshrc)
