CC ?= gcc
CFLAGS ?= -Wall -Wextra -O2

NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

TARGETDIR := build
TARGET := $(TARGETDIR)/$(NAME)
SRC := src/wordcount.c
TESTS := $(sort $(wildcard test/*.txt))
TEST_TARGETS := $(TESTS:.txt=.test)

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(TARGETDIR)
	$(CC) $(CFLAGS) -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\" $(SRC) -o $(TARGET)


check: $(TEST_TARGETS)
	test/%.test: test/%.txt test/%.expected $(TARGET)
		./$(TARGET) $< | diff -u test/$*.expected -

clean:
	rm -rf $(TARGETDIR)