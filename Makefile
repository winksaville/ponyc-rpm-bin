# Makefile which Installs, Tests and Uninstalls ponyc from bintray rpm releases

# Returns a key variable from validpgpkeys or empty if none
get_key_from_PKGBUILD = `grep '^validpgpkeys' PKGBUILD | sed "s/.*('\(.*\)').*/\1/"`

# Execute the function passed
# parameter 1 = function to execute and passing function the key from PKGBUILD
doKeyFunc = \
	@{ \
	  key=$(get_key_from_PKGBUILD) ;\
	  if [ -n "$$key" ] ; then \
	    eval "$(1) $$key" ;\
	  else \
	    echo "BUG: Key was not found in PKGBUILD" ;\
	  fi ;\
	}

.PHONY: all
all: help

.PHONY: help
help:
	@echo "Usage make <cmd>"
	@echo "  install    -- Install ponyc"
	@echo "  test       -- Test ponyc prints 'Hello, World!' on success"
	@echo "  uninstall  -- Uninstall ponyc"

.PHONY: install
install: condaddkey
	makepkg -si

.PHONY: uninstall
uninstall:
	pacman -Rs ponyc-rpm-bin

.PHONY: test
test:
	@{ \
	  rm -rf helloworld ;\
	  mkdir helloworld ;\
	  cd helloworld ;\
	  printf 'actor Main\n  new create(env: Env) =>\n    env.out.print("Hello, world!")\n' > main.pony ;\
	  ponyc --pic ;\
	  ./helloworld ;\
	  cd .. ;\
	}

#-- The following targets are for managing this package --

.PHONY: push
push: generate
	@{ \
	  status=`git status -s`;\
	  if [ -z "$$status" ]; then \
	    echo "can push" ;\
	  else \
	    git status ;\
	    printf "\n** $$(tput setaf 1)Can't PUSH$$(tput sgr 0) **\n" ;\
	  fi ;\
	}

.PHONY: generate
generate: .SRCINFO README.html

README.html: README.md Makefile
	pandoc README.md -t HTML5 -o README.html

.SRCINFO: PKGBUILD Makefile
	makepkg --printsrcinfo > .SRCINFO

.PHONY: listkeys
listkeys:
	gpg -k

.PHONY: condaddkey
condaddkey:
	@{ \
	  key=$(get_key_from_PKGBUILD) ;\
	  locate_resp=$$(gpg --locate-keys $$key) ;\
	  if [ -z "$$locate_resp" ] ; then \
	    printf "Key $$key is not installed.\n" ;\
	    read -p 'Install the key using "gpg --recv-keys" (Y/n): ' response ;\
	    if [ "$$response" = "" ] \
	       || [ "$$response" = 'Y' ] \
	       || [ "$$response" = 'y' ]; then \
	      gpg --recv-keys $$key ;\
	    fi ;\
	  fi ;\
	}

.PHONY: locatekey
locatekey:
	@{ \
	  key=$(get_key_from_PKGBUILD) ;\
	  locate_resp=$$(gpg --locate-keys $$key) ;\
	  if [ -z "$$locate_resp" ] ; then \
	    printf "Key $$key is not installed.\n" ;\
	  else \
	    printf "$$locate_resp\n" ;\
	  fi ;\
	}

.PHONY: addkey
addkey:
	$(call doKeyFunc,"gpg --recv-keys")

.PHONY: delkey
delkey:
	$(call doKeyFunc,"gpg --batch --delete-key")

.PHONY: getkey
getkey:
	$(call doKeyFunc,"echo")

.PHONY: clean
clean:
	rm -rf LICENSE ponyc-* src/ pkg/ helloworld
