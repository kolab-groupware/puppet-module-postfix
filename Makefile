MODULENAME	:= postfix

install:
	mkdir -p $(DESTDIR)/var/lib/puppet/modules/postfix
	(if [ -d "files/" ]; then cp -r files $(DESTDIR)/var/lib/puppet/modules/postfix/; fi)
	(if [ -d "lib/" ]; then cp -r lib $(DESTDIR)/var/lib/puppet/modules/postfix/; fi)
	(if [ -d "manifests/" ]; then cp -r manifests $(DESTDIR)/var/lib/puppet/modules/postfix/; fi)
	(if [ -d "templates/" ]; then cp -r templates $(DESTDIR)/var/lib/puppet/modules/postfix/; fi)
