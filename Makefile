.PHONY: check lazytest lazyadd lazypush

check: 
	md5sum apache2buddy.pl
	cat md5sums.txt
	@echo
	sha256sum apache2buddy.pl
	cat sha256sums.txt

sums: md5sums.txt sha256sums.txt

md5sums.txt: apache2buddy.pl
	md5sum apache2buddy.pl >md5sums.txt

sha256sums.txt: apache2buddy.pl
	sha256sum apache2buddy.pl >sha256sums.txt

lazytest:
	sudo perl apache2buddy.pl

lazyadd:
	git add apache2buddy.pl md5sums.txt sha256sums.txt

lazypush:
	git push origin staging
