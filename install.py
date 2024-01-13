# -------------------------------------------- #
#      ** Install my bspwn config  **          #
# - Author: ramsy0dev                          #
# - github: github.com/ramsy0dev/dotfiles      #
# - Website: ramsy0dev.github.io               #
# -------------------------------------------- #

import os
import sys
import subprocess

try:
    import typer

    from rich import print
    from rich.console import Console
    from rich.prompt import Prompt
except:
    print("Please install `rich` and `typer` lib using `sudo pip install rich typer` and try again.")
    sys.exit(1)

# Init cli
cli = typer.Typer()

# Init console
console = Console()

# Init prompt
prompt = Prompt()

console._log_render.omit_repeated_times = False

PACKAGES = {
    "arch": "./packages/arch-packages.txt",
    "debian": "./packages/debian-packages.txt"
}

APPS = {
    "arch": "./apps/arch-apps.txt",
    "debian": "./apps/debian-apps.txt"
}
SPECIAL_PACKAGES = {
    "eza": "cargo install eza"
}

FAILD_TO_INSTALL_PACKAGES = []
FAILD_TO_INSTALL_APPS = []

BANNER_ART = """
[bold green]▄▄▌ ▐ ▄▌[bold green]▪  [bold green]·▄▄▄▄• ▄▄▄· ▄▄▄  ·▄▄▄▄  
[bold green]██· █▌▐█[bold green]██ [bold green]▪▀·.█▌▐█ ▀█ ▀▄ █·██▪ ██ 
[bold green]██▪▐█▐▐▌[bold green]▐█·[bold green]▄█▀▀▀•▄█▀▀█ ▐▀▀▄ ▐█· ▐█▌
[bold green]▐█▌██▐█▌[bold green]▐█▌[bold green]█▌▪▄█▀▐█ ▪▐▌▐█•█▌██. ██ 
[bold green] ▀▀▀▀ ▀▪[bold green]▀▀▀[bold green]·▀▀▀ • ▀  ▀ .▀  ▀▀▀▀▀▀•  Dotfiles [italic]by[bold] ramsy0dev
"""

IGNORE_WARNINGS = [
    '\nWARNING: apt does not have a stable CLI interface. Use with caution in scripts.\n\n' # Classic warning that gets raised by APT when being used in scripts
]

def banner() -> None: print(BANNER_ART)

def is_root() -> bool: return os.geteuid() == 0

def install_packages_apps(prefix: str, packages: list[str] | None = None, apps: list[str] | None = None) -> None:
    """ Install needed packages and apps """
    command = lambda package_manager, flags, package_name: f"sudo {package_manager} {flags} {package_name}"
    
    package_manager = "apt" if prefix == "debian" else "pacman"
    flags = "install -y" if prefix == "debian" else "-Syu --noconfirm"

    names = packages if packages is not None else apps
    _type = "Package" if packages is not None else "App"
    
    with console.status("") as status:
        for name in names:
            status.update(f"Installing [bold green]`{name}`[bold white]...")

            command_process = subprocess.run(
                command(
                    package_name=name,
                    flags=flags,
                    package_manager=package_manager
                ),
                shell=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )

            stdout = command_process.stdout.decode()
            stderr = command_process.stderr.decode()

            if len(stderr) > 0 and stderr not in IGNORE_WARNINGS:
                console.log(f"[bold yellow] [ ! ] [bold white]Faild to install [bold green]`{name}`[bold white]")

                if _type == "Package": FAILD_TO_INSTALL_PACKAGES.append(name)
                if _type == "App": FAILD_TO_INSTALL_APPS.append(name)
            else:
                console.log(f"[bold green] [ + ] [bold white]{_type} [bold green]`{name}`[bold white] installed")
        
        if len(FAILD_TO_INSTALL_PACKAGES) > 0 and _type == "Package":
            faild_packages = "".join(["\n" + " "*7 + "- " + package for package in FAILD_TO_INSTALL_PACKAGES])
            console.log(f"[bold red] [ - ] [bold white]Faild to install [bold red]`{len(FAILD_TO_INSTALL_PACKAGES)}`[bold white] package(s), which are: {faild_packages}")
        elif len(FAILD_TO_INSTALL_APPS) > 0 and _type == "App":
            faild_apps = "".join(["\n" + " "*7 + "- " + app for app in FAILD_TO_INSTALL_APPS])
            console.log(f"[bold red] [ - ] [bold white]Faild to install [bold red]`{len(FAILD_TO_INSTALL_APPS)}`[bold white] package(s), which are: {faild_apps}")

def install_special_packages() -> None: ...

def setup_zsh_config() -> None: ...

def setup_system_wide_configs() -> None: ...

def setup_spicetify_theme() -> None: ...

def install_yarn() -> None: ...

def detect_distribution() -> str:
    """
    Detect what distribution is being used
    
    Args:
        None
    
    Returns:
        str | None: the distribution, in case its unable to detect it None is returned.
    """
    path = "/etc/os-release"
    content = open(path, "r").read()

    if "debian" in content:
        return "debian"

    if "arch" in content:
        return "arch"
    
    return None

@cli.command()
def packages() -> None:
    """ Install needed packages and apps"""
    packages_list: list[str] = None
    apps_list: list[str] = None
    
    prefix = detect_distribution()

    if prefix is None:
        console.log("[bold yellow] [ ! ] [bold white]Unable to detect the distribution.")

        prefix = prompt.ask("What is your distribution?", choices=["arch", "debian"], show_choices=True)

    packages_file_path = PACKAGES[prefix]
    apps_file_path = APPS[prefix]

    with open(packages_file_path, "r") as packages_file:
        packages_list = [line.strip() for line in packages_file.readlines()]
    
    with open(apps_file_path, "r") as apps_file:
        apps_list = [line.strip() for line in apps_file.readlines()]
    
    # Install packages
    console.log("[bold green] [ + ] [bold white]Installing packages...")
    install_packages_apps(
        prefix=prefix,
        packages=packages_list
    )

    # Install apps
    console.log("[bold green] [ + ] [bold white]Installing apps...")
    install_packages_apps(
        prefix=prefix,
        apps=apps_list
    )

def run():
    if not is_root():
        console.log("[bold red] [ ! ] [bold white]Must be [bold red]root[bold white].")
        sys.exit(1)
    
    cli()

if __name__ == "__main__":
    banner()
    run()
