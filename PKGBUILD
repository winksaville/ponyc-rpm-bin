# Maintainer: Wink Saville <wink@saville.com>
pkgname=ponyc-rpm-bin
_ver="0.20.0"
_ver_sig="4003.0b2a2d2"
pkgver="${_ver}_${_ver_sig}"
pkgrel=1
pkgdesc="An actor model, capabilities, high performance programming language (bintray rpm binaries)"
arch=('x86_64')
url="https://www.ponylang.org/"
license=('BSD')
depends=('zlib' 'ncurses5-compat-libs')
makedepends=('gnupg' 'git' 'make' 'pandoc')
provides=("ponyc=$_ver")
conflicts=('ponyc' 'ponyc-rpm')

validpgpkeys=('8756C4F765C9AC3CB6B85D62379CE192D401AB61')
source=("https://raw.githubusercontent.com/ponylang/ponyc/${_ver}/LICENSE")
sha256sums=('c22151b202623f11638a8f6e3eb07c5767b941b75e7585f2e270d5b87f72758a')

source_x86_64=("https://dl.bintray.com/pony-language/ponyc-rpm/ponyc-${_ver}-${_ver_sig}.x86_64.rpm"{,.asc})
sha256sums_x86_64=('0b7dd70759603535061a19d47d12f8059656880dcb9d00550dd833c515125fcf'
                   '034db15e4e931606279e43b8d2a8c790a800b4ea9950960a6c39c0d46ce05323')

package() {
  cp -a "usr" "$pkgdir/"
  install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
