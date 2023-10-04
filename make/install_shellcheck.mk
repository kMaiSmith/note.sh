LOCAL_BIN=$(HOME)/.local/bin

SHELLCHECK_ROOT=$(PWD)/.fetch
SHELLCHECK_VERSION=v0.9.0
# As per https://github.com/koalaman/shellcheck/releases/tag/v0.9.0
SHELLCHECK_ARCHIVE=shellcheck-$(SHELLCHECK_VERSION).linux.$(shell uname -m).tar.xz
SHELLCHECK_BIN=$(SHELLCHECK_ROOT)/shellcheck-$(SHELLCHECK_VERSION)/shellcheck
SHELLCHECK=$(LOCAL_BIN)/shellcheck

$(LOCAL_BIN) $(SHELLCHECK_ROOT):
	mkdir -p $@

$(SHELLCHECK_ROOT)/$(SHELLCHECK_ARCHIVE): $(SHELLCHECK_ROOT)
	wget -O $@ https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_VERSION)/$(SHELLCHECK_ARCHIVE)

$(SHELLCHECK_BIN): $(SHELLCHECK_ROOT)/$(SHELLCHECK_ARCHIVE)
	tar -xf $< -C $(SHELLCHECK_ROOT);

$(SHELLCHECK): $(SHELLCHECK_BIN) $(LOCAL_BIN)
	cp $< $@;
	rm -rf $(SHELLCHECK_ROOT)