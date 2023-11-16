# FPS-Display-iOS
iOSデバイスの画面にFPS（フレームレート）を表示するためのものです。
# Hướng dẫn tạo file .deb từ mã nguồn FPS-Display

Để tạo một file .deb từ mã nguồn FPS-Display, bạn cần cài đặt Theos, một framework phát triển tweak và ứng dụng cho jailbroken iOS.

## Bước 1: Cài đặt Theos

Đầu tiên, cài đặt Xcode Command Line Tools và sau đó cài đặt Theos từ GitHub:

```bash
xcode-select --install
git clone --recursive https://github.com/theos/theos.git /opt/theos
export THEOS=/opt/theos
export PATH=$THEOS/bin:$PATH
