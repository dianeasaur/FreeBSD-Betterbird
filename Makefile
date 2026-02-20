PORTNAME=	betterbird	
DISTVERSION=	140.7.1

CATEGORIES=	mail news net-im wayland
MAINTAINER=	4983626+dianeasaur@users.noreply.github.com
COMMENT=	Betterbird is a fine-tuned version of Mozilla Thunderbird	
WWW=		https://www.betterbird.eu/

LICENSE=	MPL20
LICENSE_FILE=	LICENSE

.include "${.CURDIR}/Makefile.sources"

DIST_SUBDIR=	${PORTNAME}
WRKSRC_SUBDIR=	${PORTNAME}

PATCH_DEPENDS=	git>0:devel/git

BUILD_DEPENDS=	nspr>=4.32:devel/nspr \
	nss>=3.112:security/nss \
	libevent>=2.1.8:devel/libevent \
	harfbuzz>=10.1.0:print/harfbuzz \
	graphite2>=1.3.14:graphics/graphite2 \
	png>=1.6.45:graphics/png \
	dav1d>=1.0.0:multimedia/dav1d \
	libvpx>=1.15.0:multimedia/libvpx \
	${PYTHON_PKGNAMEPREFIX}sqlite3>0:databases/py-sqlite3@${PY_FLAVOR} \
	v4l_compat>0:multimedia/v4l_compat \
	nasm:devel/nasm \
	yasm:devel/yasm \
	zip:archivers/zip \
	${LOCALBASE}/share/wasi-sysroot/lib/wasm32-wasi/libc++abi.a:devel/wasi-libcxx${LLVM_VERSION} \
	${LOCALBASE}/share/wasi-sysroot/lib/wasm32-wasi/libc.a:devel/wasi-libc@${LLVM_VERSION} \
	wasi-compiler-rt${LLVM_VERSION}>0:devel/wasi-compiler-rt${LLVM_VERSION}

LIB_DEPENDS=	libjson-c.so:devel/json-c

USE_GECKO=	gecko
USE_MOZILLA=	-icu -sqlite

MOZ_OPTIONS=	--enable-application=comm/mail
MOZ_OPTIONS+=	--with-system-bz2 --with-system-jsonc
MOZ_OPTIONS+=	--with-wasi-sysroot=${LOCALBASE}/share/wasi-sysroot
MOZ_OPTIONS+=	--with-branding=comm/mail/branding/betterbird
MOZ_OPTIONS+=	--disable-official-branding
MOZ_OPTIONS+=	--disable-updater
MOZ_OPTIONS+=	--disable-crashreporter
MOZ_OPTIONS-=	--enable-update-channel=release

MOZ_MK_OPTIONS=	 MOZ_THUNDERBIRD=1 MOZ_BRANDING_DIRECTORY=betterbird
MOZ_MK_OPTIONS+= MAIL_PKG_SHARED=1 MOZ_TELEMETRY_REPORTING=
MOZ_MK_OPTIONS+= MOZ_APP_REMOTINGNAME=eu.betterbird.Betterbird
MOZ_EXPORT=	 MOZ_THUNDERBIRD=1 MOZ_BRANDING_DIRECTORY=betterbird
MOZ_EXPORT+=	 MAIL_PKG_SHARED=1 MOZ_TELEMETRY_REPORTING=
MOZ_EXPORT+=	 MOZ_APP_REMOTINGNAME=eu.betterbird.Betterbird

CONFLICTS_INSTALL+=	thunderbird
CONFLICTS_INSTALL+=	thunderbird-esr

PORTNAME_ICON=		${MOZILLA}.png
PORTNAME_ICON_SRC=	${PREFIX}/lib/${MOZILLA}/chrome/icons/default/default48.png

SYSTEM_PREFS=		${FAKEDIR}/lib/${PORTNAME}/defaults/pref/${PORTNAME}.js

OPTIONS_DEFINE+=	CANBERRA DBUS DEBUG EXPERIMENTAL FFMPEG \
			LIBPROXY LTO OPTIMIZED_CFLAGS PROFILE TEST

OPTIONS_DEFAULT+=	CANBERRA DBUS FFMPEG OPTIMIZED_CFLAGS PROFILE \
			${OPTIONS_GROUP_AUDIO:NALSA}

OPTIONS_GROUP+=		AUDIO
OPTIONS_GROUP_AUDIO=	ALSA JACK PULSEAUDIO SNDIO

AUDIO_DESC?=		Extra cubeb audio backends (OSS is always available)
CANBERRA_DESC?=		Sound theme alerts
LIBPROXY_DESC?=		Proxy support via libproxy
LIGHTNING_DESC?=	Calendar extension

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MEXPERIMENTAL}
CONFIGURE_ENV+=	DEVELOPER_MODE=yes DEVELOPER=1
USES-= nodejs:24
USES+= nodejs:25
BUILD_DEPENDS+= node25>25.0:www/node25
.else
BUILD_DEPENDS+= node24>24.0:www/node24
.endif

pre-patch:
	@${ECHO_MSG} "===>   Applying ${PORTNAME} patches"
	@for project in ${WRKSRC} ${WRKSRC}/comm; do \
		for patch in `${AWK} '/^#/ {next} {print $$1}' $${project}/${PORTNAME}-patches/series`; do \
		if [ -f $${project}/${PORTNAME}-patches/$${patch} ]; then \
			cd $${project}; \
			if ${PATCH} --dry-run -s -N -f -u -p1 -i ${PORTNAME}-patches/$${patch}; then \
				${PATCH} -s -N -f -u -p1 -i ${PORTNAME}-patches/$${patch}; \
			else \
				${ECHO_MSG} "===>   Patch $${patch} failed, trying git" && \
				git apply --whitespace=warn ${PORTNAME}-patches/$${patch} || \
				${ECHO_MSG} "===>   Both patch and git apply failed for $${patch}"; \
			fi; \
		else \
			${ECHO_MSG} "===>   ERROR: patch $${patch} is missing in $${project}"; \
		fi; \
		done; \
	done

post-patch:
	@${REINPLACE_CMD} -e 's|%%LOCALBASE%%|${LOCALBASE}|g' \
		${WRKSRC}/comm/mail/app/nsMailApp.cpp
	@${REINPLACE_CMD} -e 's|%%RELEASE_M%%|${RELEASE_M}|g' ${WRKSRC}/sourcestamp.txt
	@${REINPLACE_CMD} -e 's|%%COMM_REV%%|${COMM_REV}|g' ${WRKSRC}/sourcestamp.txt
	@${REINPLACE_CMD} -e 's|%%MOZILLA_REV%%|${MOZILLA_REV}|g' ${WRKSRC}/sourcestamp.txt

port-pre-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/lib/${PORTNAME}/defaults

post-install:
	${INSTALL_DATA} ${WRKDIR}/${MOZILLA_EXEC_NAME}.desktop ${STAGEDIR}${PREFIX}/share/applications
	${LN} -sf ${PORTNAME_ICON_SRC} ${STAGEDIR}${PREFIX}/share/pixmaps/${PORTNAME_ICON}

.include <bsd.port.mk>
