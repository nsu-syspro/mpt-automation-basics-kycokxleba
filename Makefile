CC ?= gcc
CFLAGS ?= -Wall -Wextra -O2

NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

TARGETDIR := build
TARGET := $(TARGETDIR)/$(NAME)
SRC := src/wordcount.c
TESTS := $(sort $(wildcard test/*.txt))

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(TARGETDIR)
	$(CC) $(CFLAGS) -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\" $(SRC) -o $(TARGET)


check: all
	@for test in $(TESTS); do \
		expected="$${test%.txt}.expected"; \
		./$(TARGET) "$$test" | diff -u "$$expected" - || exit 1; \
	done

clean:
	rm -rf $(TARGETDIR)