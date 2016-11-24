all: release

system:
	./scripts/image

release:
	./scripts/image release

image:
	./scripts/image mkimage

noobs:
	./scripts/image noobs

amlpkg:
	./scripts/image amlpkg

clean:
	rm -rf build.*

src-pkg:
	tar cvjf sources.tar.bz2 sources .stamps
