PORTNAME=	betterbird	
DISTVERSION=	140.7.1

CATEGORIES=	mail news net-im wayland
MAINTAINER=	4983626+dianeasaur@users.noreply.github.com
COMMENT=	Betterbird is a fine-tuned version of Mozilla Thunderbird	
WWW=		https://www.betterbird.eu/

.include "${.CURDIR}/Makefile.sources"

DIST_SUBDIR=	${PORTNAME}
WRKSRC=		${WRKDIR}/${PORTNAME}

BUILD_DEPENDS=	mercurial>0:devel/mercurial@${PY_FLAVOR}

LIB_DEPENDS=	

CONFLICTS_INSTALL+=	thunderbird
CONFLICTS_INSTALL+=	thunderbird-esr

do-patch:
#	WIP
#      @for line in `$(CAT) ${WRKSRC}/comm/.hg/patches/series`; do \
#              if [ -f ${WRKSRC}/comm/.hg/patches/$${line} ]; then \
#              cd ${WRKSRC}/comm && \
#              echo patch -p1 -N --ignore-whitespace -i ../patches/$${line}; \
#              fi; \
#      done

pre-build:

port-pre-install:

post-install:

.include <bsd.port.mk>
