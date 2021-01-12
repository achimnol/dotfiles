unset CFLAGS
unset LDFLAGS
export PKG_CONFIG_PATH
export LDFLAGS="-L$(brew --prefix xz)/lib $LDFLAGS"
export CPPFLAGS="-I$(brew --prefix xz)/include $CPPFLAGS"
export PKG_CONFIG_PATH="$(brew --prefix xz)/lib/pkgconfig:$PKG_CONFIG_PATH"
