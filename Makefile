PORTNAME=	betterbird	
DISTVERSION=	140.7.1

CATEGORIES=	mail news net-im wayland
MAINTAINER=	4983626+dianeasaur@users.noreply.github.com
COMMENT=	Betterbird is a fine-tuned version of Mozilla Thunderbird	
WWW=		https://www.betterbird.eu/

.include "${.CURDIR}/Makefile.sources"

DIST_SUBDIR=	${PORTNAME}
WRKSRC=		${WRKDIR}/${PORTNAME}

BUILD_DEPENDS=

LIB_DEPENDS=	

CONFLICTS_INSTALL+=	thunderbird
CONFLICTS_INSTALL+=	thunderbird-esr

                        #cd ${WRKSRC} && ${PATCH} -s -p1 -N -F 4 -i \
                        #       ${WRKDIR}/mozilla-patch-staging/$${patch}; \

patch:
	@${ECHO_MSG} "===>   Applying mozilla patches"
	@for patch in `${AWK} '/^#/ {next} {print $$1}' ${WRKDIR}/mozilla-patch-staging/series`; do \
		if [ -f ${WRKDIR}/mozilla-patch-staging/$${patch} ]; then \
			cd ${WRKSRC} && git apply --quiet --whitespace=warn \
				${WRKDIR}/mozilla-patch-staging/$${patch}; \
		else \
			${ECHO_MSG} "===> ERROR: mozilla project patch $${patch} is missing"; \
		fi; \
	done
	@${ECHO_MSG} "===>   Applying comm patches"
	@for patch in `${AWK} '/^#/ {next} {print $$1}' ${WRKDIR}/comm-patch-staging/series`; do \
		if [ -f ${WRKDIR}/comm-patch-staging/$${patch} ]; then \
			cd ${WRKSRC} && git apply --quiet --whitespace=warn \
				${WRKDIR}/comm-patch-staging/$${patch}; \
		else \
			${ECHO_MSG} "===> ERROR: comm project patch $${patch} is missing"; \
		fi; \
	done

pre-build:

port-pre-install:

post-install:

.include <bsd.port.mk>
