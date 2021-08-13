#! /bin/bash

echo "===> Installing ripgrep"
VERSION=13.0.0
DEB_HOST_ARCH="$(uname -m)"
if [ "${DEB_HOST_ARCH}" == "x86_64" ]; then
  DEB_HOST_ARCH="amd64"
fi
case "${PLATFORM}" in
  "codespace" | "linux")
    LINUX_TYPE=$(python scripts/detect-linux.py)
    case "${LINUX_TYPE}" in
      "debian")
        DEB_NAME="ripgrep_${VERSION}_${DEB_HOST_ARCH}.deb"
        curl -L "https://github.com/BurntSushi/ripgrep/releases/download/${VERSION}/ripgrep_${VERSION}_${DEB_HOST_ARCH}.deb" \
          -o "$DEB_NAME"
        sudo dpkg -i "$DEB_NAME"
        rm "$DEB_NAME"
        ;;
      *)
        echo "Auto-installation of ripgrep on ${LINUX_TYPE}-like Linux distro is not implemented."
        ;;
    esac
    ;;
  "mac")
    brew install ripgrep
    ;;
  *)
    echo "Unsupported platform for auto-installation of ripgrep."
    ;;
esac
