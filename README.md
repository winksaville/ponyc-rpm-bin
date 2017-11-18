# Install ponyc binaries from .rpm files
This installs ponyc using `makepkg -si` from the release .rpm
files on [bintray](https://bintray.com/pony-language/ponyc-rpm).

The current ponyc package installed via pacman is not compatible with
LLVM5 and fails, see Arch Linux bug
[55170](https://bugs.archlinux.org/task/55170) archlinux bug.
It is also not possible to build ponyc from source for
the same reason. [Issue 2303](https://github.com/ponylang/ponyc/pull/2303)
is tracking the problem.

## Pony install/uninstall using ponyc-rpm-bin
### Prerequisites: `git` `zlib` `ncurses5-compat-libs`

Install `git` and `zlib` using pacman:
```
sudo pacman -Syu git zlib
```

Install AUR package [`ncurses5-compat-libs`](https://aur.archlinux.org/packages/ncurses5-compat-libs/)
manually by cloning its git repo, and using makepkg to install. For example:
```
git clone https://aur.archlinux.org/ncurses5-compat-libs.git
cd ncurses5-compat-libs
makepkg -si
```
If you get a `FAILED (unknown public key xxxx)` see [Install pgp keys](#install-pgp-keys)

### Install:
Clone the repo, change directory to the repo, run `makepkg -si`
or use your favorite AUR package manager.
```
git clone https://aur.archlinux.org/ponyc-rpm-bin.git
cd ponyc-rpm-bin
makepkg -si
```
Again, if you get a `FAILED (unknown public key xxxx)` see [Install pgp keys](#install-pgp-keys)

### Uninstall:
```
sudo pacman -Rs ponyc-rpm-bin
```

## Ponyc Usage
You must pass the `--pic` parameter to ponyc on Arch Linux
```
ponyc --pic
```

## Example
Create a directory `helloworld`, with the file `main.pony`,
compile with `ponyc --pic` and then run `./helloworld`:
```
(mkdir helloworld ;\
cd helloworld ;\
echo 'actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")' > main.pony ;\
ponyc --pic ;\
./helloworld )
```
This should result in something like:
```
$ mkdir helloworld
wink@wink-envy:~/prgs/ponylang
$ cd helloworld
wink@wink-envy:~/prgs/ponylang/helloworld
$ echo 'actor Main
>   new create(env: Env) =>
>     env.out.print("Hello, world!")' > main.pony
wink@wink-envy:~/prgs/ponylang/helloworld
$ ponyc --pic
Building builtin -> /usr/lib/pony/0.20.0-4003.0b2a2d2/packages/builtin
Building . -> /home/wink/prgs/ponylang/helloworld
Generating
 Reachability
 Selector painting
 Data prototypes
 Data types
 Function prototypes
 Functions
 Descriptors
Optimising
Writing ./helloworld.o
Linking ./helloworld
Warning: environment variable $CC undefined, using gcc as the linker
wink@wink-envy:~/prgs/ponylang/helloworld
$ ./helloworld
Hello, world!
```

## Install PGP keys
To install the gpg use `gpg --recv-keys <public key fingerprint>` where the
short fingerprint, `379CE192D401AB61`, was printed in the error message:
```
==> Verifying source file signatures with gpg...
    ponyc-0.20.0-4003.0b2a2d2.x86_64.rpm ... FAILED (unknown public key 379CE192D401AB61)
==> ERROR: One or more PGP signatures could not be verified!
```
The full fingerprint is also available in the PKGBUILD as `validpgpkeys` and notice that
the last 64bits is the short fingerprint:
```
validpgpkeys=('8756C4F765C9AC3CB6B85D62379CE192D401AB61')
```

The short or full fingerprint maybe used to add the keys, here we use the short one:
```
$ gpg --recv-keys 379CE192D401AB61
gpg: key 379CE192D401AB61: public key "Bintray (by JFrog) <bintray@bintray.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

Now reexecute `makepkg -si` to install the package

## Acknowledgements
This PKGBUILD was based on a guide from
[nemrod](http://nemrod.se/guides/install-rpm-packages-on-arch-linux)
and in particular the
[comment from Hi-Angel](http://nemrod.se/guides/install-rpm-packages-on-arch-linux/#comment-183470)
in January 2017.
