FROM buildpack-deps

RUN apt-get update && apt-get install -y adwaita-icon-theme at-spi2-core ca-certificates-java dconf-gsettings-backend \
    dconf-service default-java-plugin default-jre-headless fonts-dejavu-extra glib-networking glib-networking-common \
    glib-networking-services gsettings-desktop-schemas icedtea-8-plugin icedtea-netx icedtea-netx-common java-common \
    libasound2 libasound2-data libasyncns0 libatk-bridge2.0-0 libatk-wrapper-java libatk-wrapper-java-jni \
    libatspi2.0-0 libcap2 libcolord2 libdconf1 libdrm-amdgpu1 libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libdrm2 \
    libegl1-mesa libepoxy0 libflac8 libfontenc1 libgbm1 libgif7 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libgtk-3-0 \
    libgtk-3-bin libgtk-3-common libjson-glib-1.0-0 libjson-glib-1.0-common libllvm3.9 libnspr4 libnss3 libogg0 \
    libpciaccess0 libpcsclite1 libproxy1v5 libpulse0 librest-0.7-0 libsensors4 libsndfile1 libsoup-gnome2.4-1 \
    libsoup2.4-1 libtext-unidecode-perl libtxc-dxtn-s2tc libvorbis0a libvorbisenc2 libwayland-client0 libwayland-cursor0 \
    libwayland-egl1-mesa libwayland-server0 libwrap0 libx11-xcb1 libxaw7 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 \
    libxcb-present0 libxcb-shape0 libxcb-sync1 libxcb-xfixes0 libxfont1 libxft2 libxkbcommon0 libxml-libxml-perl \
    libxml-namespacesupport-perl libxml-sax-base-perl libxml-sax-expat-perl libxml-sax-perl libxmu6 libxmuu1 \
    libxshmfence1 libxtst6 libxv1 libxxf86dga1 libxxf86vm1 openjdk-8-jre openjdk-8-jre-headless tcpd tex-common \
    x11-utils xfonts-encodings xkb-data bc gawk gperf lzop texinfo unzip xfonts-utils xsltproc zip \
    sudo libxml-parser-perl
VOLUME /src
WORKDIR /src