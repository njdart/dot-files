#!/usr/bin/python3
# setup script for my dot files
#
# from http://github.com/njdart/dot-files

import os.path
import sys
from typing import Callable, Optional
from pathlib import Path

ERRORCOLOUR = "\033[91m"
WARNINGCOLOUR = '\033[93m'
SUCCESS_COLOUR = '\033[32m'
NOCOLOUR = "\033[0m"

class ConfigItem():
    src: Path
    dest: Path

    def __init__(self, src: str, dest: str):
        self.src = Path(os.path.expandvars(src)).absolute()
        self.dest = Path(os.path.expandvars(dest)).absolute()

    def describe(self) -> str:
        return f"""{self.__class__.__name__}("{self.src}" -> "{self.dest}")"""

    def check_src(self) -> bool:
        return self.src.exists()

    def ensure_destination(self):
        """ ensure_destination ensures the destination directory exists,
            creating it if it doesn't. """
        dest_dir = self.dest.parent
        if not dest_dir.exists():
            dest_dir.mkdir(parents=True)

        if not dest_dir.is_dir():
            raise Exception(f"{dest_dir} exists but is not a directory!")

    def symlink_src_to_dest(self) -> Optional[str]:
        """ symlink_src_to_dest will attempt to symlink the destination
            file to the """

        existing_src = None
        if self.dest.is_symlink():
            existing_src = self.dest.readlink()
            if existing_src == self.src:
                return None
            self.dest.unlink()
        self.dest.symlink_to(self.src, target_is_directory=self.src.is_dir())
        return existing_src

    def setup(self):
        if not self.check_src():
            raise Exception(f"Source {self.src} does not exist")

        try:
            self.ensure_destination()
        except OSError as e:
            raise Exception(f"Error creating destination: {str(e)}")

        try:
            existed = self.symlink_src_to_dest()
            if existed is not None:
                raise Exception(f"Link {self.dest} already exists, linking to {existed}. Re-linking to {self.src}")
        except Exception as e:
            raise Exception(f"Error creating symlink: {str(e)}")

class EmptyDir(ConfigItem):
    def __init__(self, dest: str):
        super().__init__("", dest)

    def describe(self) -> str:
        return f"""EmptyDir("{self.dest}")"""

    def symlink_src_to_dest(self) -> Optional[str]:
        """ This doesn't need to do anything, since calling
            ConfigItem.ensure_Destination() will do all the work
        """
        pass

def warn(s: str) -> str:
    return f"{WARNINGCOLOUR}{s}{NOCOLOUR}"

def error(s: str) -> str:
    return f"{ERRORCOLOUR}{s}{NOCOLOUR}"

def setup(configs: list[ConfigItem]):
    errors = False
    for config in configs:
        print(config.describe())
        try:
            config.setup()
        except Exception as e:
            print(warn(str(e)))
            errors = True
    return errors

def globFiles(srcs: str, dest: str) -> list[ConfigItem]:
    srcs_path = Path(srcs)
    dest_path = Path(dest)
    return [ConfigItem(str(s), str(dest_path/s.name)) for s in srcs_path.parent.glob(srcs_path.name)]

if __name__ == "__main__":
    errors = setup([
        *globFiles("bin/*", "$HOME/bin"),
        ConfigItem(".zshrc", "$HOME/.zshrc"),
        ConfigItem(".tmux.conf", "$HOME/.tmux.conf"),
        ConfigItem("nvim", "$HOME/.config/nvim"),
        ConfigItem("terminator", "$HOME/.config/terminator"),
        ConfigItem("gitignore_global", "$HOME/.config/gitignore_global"),
        ConfigItem("rofi", "$HOME/.config/rofi"),
        ConfigItem("dunst", "$HOME/.config/dunst"),
        ConfigItem("polybar", "$HOME/.config/polybar"),
        ConfigItem("picom.conf", "$HOME/.config/picom.conf"),
        ConfigItem("systemd", "$HOME/.config/systemd"),
        ConfigItem("./bspwm/sxhkdrc", "$HOME/.config/sxhkd/sxhkdrc"),
        ConfigItem("./bspwm/bspwmrc", "$HOME/.config/bspwm/bspwmrc"),
        ConfigItem("./vscode/User", "$HOME/.config/Code/User"),
        ConfigItem("./vscode/User", "$HOME/.config/Code - OSS/User"),

        # Create the screenshot directory for the scrot alias in .zshrc
        EmptyDir("$HOME/screenshots"),
    ])

    if errors:
        sys.exit(1)
