# Contributor: Timo Teras <timo.teras@iki.fi>
# Contributor: Jakub Jirutka <jakub@jirutka.cz>
# Maintainer: Timo Teras <timo.teras@iki.fi>
pkgname=openjdk8
_icedteaver=3.14.0
# pkgver is <JDK version>.<JDK update>.<JDK build>
# Check https://icedtea.classpath.org/wiki/Main_Page when updating!
pkgver=8.232.09
pkgrel=0
pkgdesc="OpenJDK 8 provided by IcedTea"
url="https://icedtea.classpath.org/"
arch="all"
license="custom"
depends="$pkgname-jre java-cacerts nss"
options="sover-namecheck"
makedepends="bash findutils tar zip file paxmark gawk util-linux libxslt
	autoconf automake linux-headers sed xz coreutils
	openjdk7 ca-certificates
	nss-dev nss-static cups-dev jpeg-dev giflib-dev libpng-dev libxt-dev
	lcms2-dev libxp-dev libxtst-dev libxinerama-dev zlib-dev
	libxrender-dev alsa-lib-dev freetype-dev fontconfig-dev
	gtk+2.0-dev krb5-dev attr-dev pcsc-lite-dev lksctp-tools-dev
	libxcomposite-dev"

case $CARCH in
x86)	_jarch=i386;;
x86_64)	_jarch=amd64;;
arm*)	_jarch=aarch32;;
*)	_jarch="$CARCH";;
esac

_bootstrap_java_home="/usr/lib/jvm/java-1.7-openjdk"
_java_home="/usr/lib/jvm/java-1.8-openjdk"
_jrelib="$_java_home/jre/lib/$_jarch"

# Exclude xawt from ldpath to avoid duplicate provides for libmawt.so
# (also in headless). in future this should be a virtual provides.
ldpath="$_jrelib:$_jrelib/native_threads:$_jrelib/headless:$_jrelib/server:$_jrelib/jli"
sonameprefix="$pkgname:"

subpackages="$pkgname-dbg $pkgname-jre-lib:jrelib:noarch $pkgname-jre $pkgname-jre-base:jrebase
	$pkgname-doc $pkgname-demos"

_dropsver=$_icedteaver
_dropsurl="https://icedtea.classpath.org/download/drops/icedtea8/$_dropsver"

source="https://icedtea.classpath.org/download/source/icedtea-$_icedteaver.tar.xz
	openjdk-$_dropsver.tar.xz::$_dropsurl/openjdk.tar.xz
	corba-$_dropsver.tar.xz::$_dropsurl/corba.tar.xz
	jaxp-$_dropsver.tar.xz::$_dropsurl/jaxp.tar.xz
	jaxws-$_dropsver.tar.xz::$_dropsurl/jaxws.tar.xz
	jdk-$_dropsver.tar.xz::$_dropsurl/jdk.tar.xz
	langtools-$_dropsver.tar.xz::$_dropsurl/langtools.tar.xz
	hotspot-$_dropsver.tar.xz::$_dropsurl/hotspot.tar.xz
	nashorn-$_dropsver.tar.xz::$_dropsurl/nashorn.tar.xz
	fix-paxmark.patch

	icedtea-hotspot-musl.patch
	icedtea-hotspot-musl-ppc.patch
	icedtea-hotspot-noagent-musl.patch
	icedtea-jdk-execinfo.patch
	icedtea-jdk-fix-ipv6-init.patch
	icedtea-jdk-fix-libjvm-load.patch
	icedtea-jdk-musl.patch
	icedtea-jdk-includes.patch
	icedtea-jdk-getmntent-buffer.patch
	icedtea-autoconf-config.patch
	"
builddir="$srcdir/icedtea-$_icedteaver"

# secfixes:
#   8.232.09-r0:
#     - CVE-2019-2933
#     - CVE-2019-2945
#     - CVE-2019-2949
#     - CVE-2019-2958
#     - CVE-2019-2964
#     - CVE-2019-2962
#     - CVE-2019-2973
#     - CVE-2019-2975
#     - CVE-2019-2978
#     - CVE-2019-2981
#     - CVE-2019-2983
#     - CVE-2019-2987
#     - CVE-2019-2988
#     - CVE-2019-2989
#     - CVE-2019-2992
#     - CVE-2019-2999
#     - CVE-2019-2894
#   8.222.10-r0:
#     - CVE-2019-2745
#     - CVE-2019-2762
#     - CVE-2019-2766
#     - CVE-2019-2769
#     - CVE-2019-2786
#     - CVE-2019-2816
#     - CVE-2019-2842
#     - CVE-2019-7317
#   8.212.04-r0:
#     - CVE-2019-2602
#     - CVE-2019-2684
#     - CVE-2019-2698
#   8.201.08-r0:
#     - CVE-2019-2422
#     - CVE-2019-2426
#     - CVE-2018-11212
#   8.191.12-r0:
#     - CVE-2018-3136
#     - CVE-2018-3139
#     - CVE-2018-3149
#     - CVE-2018-3169
#     - CVE-2018-3180
#     - CVE-2018-3183
#     - CVE-2018-3214
#     - CVE-2018-13785
#     - CVE-2018-16435
#   8.181.13-r0:
#     - CVE-2018-2938
#     - CVE-2018-2940
#     - CVE-2018-2952
#     - CVE-2018-2973
#     - CVE-2018-3639

unpack() {
	if [ -z "$force" ]; then
		verify
		initdcheck
	fi
	mkdir -p "$srcdir"
	msg "Unpacking sources..."
	tar -C "$srcdir" -Jxf icedtea-$_icedteaver.tar.xz
}

prepare() {
	cd "$builddir"

	local ver_u=$(sed -En 's/^\s*JDK_UPDATE_VERSION\s*=\s*(\S+).*/\1/p' acinclude.m4)
	local ver_b=$(sed -En 's/^\s*BUILD_VERSION\s*=\s*b(\S+).*/\1/p' acinclude.m4)
	[ "${pkgver#*.}" = "$ver_u.$ver_b" ] \
		|| die "Version mismatch, source is 8.$ver_u.$ver_b, but abuild defines $pkgver!"

	# Busybox sha256 does not support longopts.
	sed -e "s/--check/-c/g" -i Makefile.am

	local patch; for patch in $source; do
		case $patch in
		icedtea-*.patch)
			cp ../$patch patches
			;;
		*.patch)
			msg "Applying patch $patch"
			patch -p1 -i "$srcdir"/$patch
			;;
		esac
	done

	./autogen.sh
}

build() {
	export JAVA_HOME="$_bootstrap_java_home"
	export PATH="$JAVA_HOME/bin:$PATH"

	if [ -z "$JOBS" ]; then
		export JOBS=$(printf '%s\n' "$MAKEFLAGS" | sed -n -e 's/.*-j\([0-9]\+\).*/\1/p')
	fi

	DISTRIBUTION_PATCHES=""
	local patch; for patch in $source; do
		case $patch in
		icedtea-*.patch)
			DISTRIBUTION_PATCHES="$DISTRIBUTION_PATCHES patches/$patch"
			;;
		esac
	done
	export DISTRIBUTION_PATCHES
	echo "icedtea patches: $DISTRIBUTION_PATCHES"

	cd "$builddir"
	bash ./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix="$_java_home" \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--localstatedir=/var \
		--disable-dependency-tracking \
		--disable-downloading \
		--disable-precompiled-headers \
		--with-parallel-jobs=${JOBS:-2} \
		--with-hotspot-build=default \
		--with-openjdk-src-zip="$srcdir/openjdk-$_dropsver.tar.xz" \
		--with-hotspot-src-zip="$srcdir/hotspot-$_dropsver.tar.xz" \
		--with-corba-src-zip="$srcdir/corba-$_dropsver.tar.xz" \
		--with-jaxp-src-zip="$srcdir/jaxp-$_dropsver.tar.xz" \
		--with-jaxws-src-zip="$srcdir/jaxws-$_dropsver.tar.xz" \
		--with-jdk-src-zip="$srcdir/jdk-$_dropsver.tar.xz" \
		--with-langtools-src-zip="$srcdir/langtools-$_dropsver.tar.xz" \
		--with-nashorn-src-zip="$srcdir/nashorn-$_dropsver.tar.xz" \
		--with-pax=paxmark \
		--with-jdk-home="$_bootstrap_java_home" \
		--with-pkgversion="Alpine ${pkgver}-r${pkgrel}" \
		--enable-nss \
		--enable-sunec \
		--enable-non-nss-curves
	make
}

# TODO: Run tests or at least try to compile and run hello world.
check() {
	cd "$builddir"/openjdk.build/images/j2sdk-image

	./bin/java -version
}

package() {
	cd "$builddir"

	mkdir -p "$pkgdir"/$_java_home

	cp -a openjdk.build/images/j2sdk-image/* "$pkgdir"/$_java_home/
	rm "$pkgdir"/$_java_home/src.zip

	# This archive contains absolute paths from the build environment,
	# so it does not work on the target system. User can generate it
	# running `java -Xshare:dump`.
	rm -f "$pkgdir"/$_jrelib/server/classes.jsa

	# pax mark again (due to fakeroot xattr handling bug)
	./pax-mark-vm "$pkgdir"/$_java_home true

	# symlink to shared java cacerts store
	rm -f "$pkgdir"/$_java_home/jre/lib/security/cacerts
	ln -sf /etc/ssl/certs/java/cacerts \
		"$pkgdir"/$_java_home/jre/lib/security/cacerts
}

jrelib() {
	pkgdesc="OpenJDK 8 Java Runtime (class libraries)"
	depends=""

	local file dir
	for file in jre/lib/images \
			jre/lib/*.jar \
			jre/lib/security \
			jre/lib/ext/*.jar \
			jre/lib/cmm \
			jre/ASSEMBLY_EXCEPTION \
			jre/THIRD_PARTY_README \
			jre/LICENSE; do

		dir=${file%/*}
		mkdir -p "$subpkgdir"/$_java_home/$dir
		mv "$pkgdir"/$_java_home/$file "$subpkgdir"/$_java_home/$dir
	done
}

jre() {
	pkgdesc="OpenJDK 8 Java Runtime"
	local file dir

	mkdir -p "$subpkgdir"
	for file in jre/bin/policytool \
			bin/appletviewer \
			bin/policytool \
			jre/lib/$_jarch/libawt_xawt.so \
			jre/lib/$_jarch/libfontmanager.so \
			jre/lib/$_jarch/libjawt.so \
			jre/lib/$_jarch/libjsoundalsa.so \
			jre/lib/$_jarch/libsplashscreen.so; do

		dir=${file%/*}
		mkdir -p "$subpkgdir"/$_java_home/$dir
		mv "$pkgdir"/$_java_home/$file "$subpkgdir"/$_java_home/$dir
	done

	# Pax mark again (due to fakeroot xattr handling bug).
	"$builddir"/pax-mark-vm "$subpkgdir"/$_java_home true
}

jrebase() {
	pkgdesc="OpenJDK 8 Java Runtime (no GUI support)"
	depends="$pkgname-jre-lib java-common java-cacerts nss"

	mkdir -p "$subpkgdir"/$_java_home/bin \
		"$subpkgdir"/$_java_home/lib/$_jarch

	mv "$pkgdir"/$_java_home/lib/$_jarch/jli \
		"$subpkgdir"/$_java_home/lib/$_jarch/

	local file; for file in java orbd rmid servertool unpack200 keytool \
			pack200 rmiregistry tnameserv; do
		mv "$pkgdir"/$_java_home/bin/$file "$subpkgdir"/$_java_home/bin/
	done

	# Rest of the jre subdir (which were not taken by -jre subpkg).
	mv "$pkgdir"/$_java_home/jre "$subpkgdir"/$_java_home/

	# Pax mark again (due to fakeroot xattr handling bug).
	"$builddir"/pax-mark-vm "$subpkgdir"/$_java_home true
}

doc() {
	default_doc

	mkdir -p "$subpkgdir"/$_java_home/
	mv "$pkgdir"/$_java_home/man "$subpkgdir"/$_java_home/
}

demos() {
	pkgdesc="OpenJDK 8 Java Demos and Samples"
	depends="$pkgname"

	mkdir -p "$subpkgdir"/$_java_home/
	mv "$pkgdir"/$_java_home/demo "$pkgdir"/$_java_home/sample \
		"$subpkgdir"/$_java_home/
}

sha512sums="6cd366a1adde12b5cc2c0c64c0c353ebf9ad5b0ad79b77c5cca3acc93219752110eb222b74bd62180fe0bf5b063db12df6316c334d5940d1636c9d10824085ed  icedtea-3.14.0.tar.xz
1e8009155a9ad39405e11704bb1f8b4c51ae0f64563baa7a7ce29a79613339e82b8776193a0076b993f8839b1c5959edff18cdadaa7f2f163fa5d3b7f7d60396  openjdk-3.14.0.tar.xz
5aedab2cff0dd8b4cb98121643009593d10da9abd150ab938cf45f5b8f18cae5f31dcc31c30090b736cf52413a290b6b11e6fc42b3575ea50e213bf334a07159  corba-3.14.0.tar.xz
16a34a65b20650f66eece6e33e82aefaf46bbf46c8332bac8c266405839168b924235395cbf7d6c5210d35b416ee0ab2ed0bd09c3f1c90195bff35d3db4b596d  jaxp-3.14.0.tar.xz
706b9ce4d32c92adca44d9643e44ebe757e8503798e2b24b2591660774f4a4719f2015d3edb02f3374ec4b88c5b2f0b5578369345a9db4c5def1ff37f630bb5d  jaxws-3.14.0.tar.xz
2e44c646bcbf56ce7e91be0fdb46db9887cfe7f538f866e61d757e657a4a3726caca50bd885355a85675451ea8ff9810bccb7ea026239219373688455dcc8476  jdk-3.14.0.tar.xz
ceef08eb53e895156afd0ec342a045c3aa29551a7939803cd821121286ec05fb3538d3b46a44c99f1a2805163b6e7351ec42b1486aaf6a8ecb7fdccc526c410d  langtools-3.14.0.tar.xz
258cca176c6f930268f189f77dd4e6bd683fb90fbd7866870d22ca42105292cedeca7d274b70979e59af15229ebba22da64444ef14c641066e10688286ec302d  hotspot-3.14.0.tar.xz
59af524388b501c63c567dd36abbe29b3254b3f05191730740aec84e73f93cf77850ab36d9972528781bbf47a6541a75d7e80e26c4c425d6cbb6460e2b4bdbda  nashorn-3.14.0.tar.xz
1f470432275d5beaa8b4e4352a2f24a4a00593546dc4f3bd857794c89e521e8e6d6abc540762bbd769be3e1e3da058e134dc5dc066d12b9b8a1f0656040a795c  fix-paxmark.patch
28709285390a997adbd56ebda42ef718fbc08daf572b8568f484436d255514f9d25f033e3333dff8aa352fc9846057ac5bb42fa955d3e5e44eddc96dc273c07c  icedtea-hotspot-musl.patch
e5cf4d70f96fc1e72ae8b97a887adb96092ff36584711cbb8de9d9fa9e859cb8731d638838de0d9591239fc44ffe5c74422d1842bd9f10a0c00dff1627bdeeef  icedtea-hotspot-musl-ppc.patch
19459dbb922f5a71cd15b53199481498626a783c24f91d2544d55b7dddd2cdb34a64bbf0226b99548612dd1743af01b3f9ff32c30abbbc90ce727ca2dbbbd1f9  icedtea-hotspot-noagent-musl.patch
f6365cfafafa008bd6c1bf0ccec01a63f8a39bd1a8bc87baa492a27234d47793ba02d455e5667a873ef50148df3baaf6a8421e2da0b15faac675867da714dd5f  icedtea-jdk-execinfo.patch
48533f87fc2cf29d26b259be0df51087d2fe5b252e72d00c6ea2f4add7b0fb113141718c116279c5905e03f64a1118082e719393786811367cf4d472b5d36774  icedtea-jdk-fix-ipv6-init.patch
b135991c76b0db8fa7c363e0903624668e11eda7b54a943035c214aa4d7fc8c3e8110ed200edcec82792f3c9393150a9bd628625ddf7f3e55720ff163fbbb471  icedtea-jdk-fix-libjvm-load.patch
1fbc32ddc528c7c0099dbc1e48f88d29dccf55e7b8997793aa1d3d8408003a1223d898cca4248e1a12d343d3feec5144f875e6cdac8460d763c73ab3ad7e49f9  icedtea-jdk-musl.patch
e8d9f1b867bf4fc84aa00d1237b264bcf503b1ed5f34735e14b0b747a728953fe0051a5af69ed058d377fbf65d8be1ed9e38fe5fc6edb2d50b31f34bf3ba91dc  icedtea-jdk-includes.patch
7e6fa46b10c630517bfa46943858aea1d032c12d32ba3fcb7a2143ae1e896c34fa4cb8f925af80cb19f8e29149b835aa054adfd30ebb00539f6c78588d6f5211  icedtea-jdk-getmntent-buffer.patch
662d662d0a7a84be2978e921317589f212f3ba3b7629527ba0f1140b5ac4c1024893e0ed176211688ed1a4505968c4befc841ed57ffcdbb9d355c2cb0571b167  icedtea-autoconf-config.patch"
