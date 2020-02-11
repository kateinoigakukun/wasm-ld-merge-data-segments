MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
WASI_SDK_DIR ?= $(MAKEFILE_DIR)/.wasi-sdk
CLANG = $(WASI_SDK_DIR)/bin/clang++

ifeq  ($(shell uname),Darwin)
WASI_SDK_DOWNLOAD_URL="https://github.com/CraneStation/wasi-sdk/releases/download/wasi-sdk-8/wasi-sdk-8.0-macos.tar.gz"
else
WASI_SDK_DOWNLOAD_URL="https://github.com/CraneStation/wasi-sdk/releases/download/wasi-sdk-8/wasi-sdk-8.0-linux.tar.gz"
endif

all: .wasi-sdk main

main: foo.o bar.o main.o
	$(CLANG) $^ -v -Xlinker --no-gc-sections -o $@

%.o: %.cpp
	$(CLANG) -c $< -o $@

.wasi-sdk:
	mkdir -p $(WASI_SDK_DIR) && cd $(WASI_SDK_DIR) && \
            curl -L $(WASI_SDK_DOWNLOAD_URL) | tar xz --strip-components 1
clean:
	rm main.o foo.o bar.o
