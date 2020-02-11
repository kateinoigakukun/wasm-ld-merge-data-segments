MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
WASI_SDK_DIR ?= $(MAKEFILE_DIR)/.wasi-sdk
CLANG ?= $(WASI_SDK_DIR)/bin/clang++
WASM_LD ?= $(WASI_SDK_DIR)/bin/wasm-ld
SYSROOT := $(WASI_SDK_DIR)/share/wasi-sysroot

ifeq  ($(shell uname),Darwin)
WASI_SDK_DOWNLOAD_URL="https://github.com/CraneStation/wasi-sdk/releases/download/wasi-sdk-8/wasi-sdk-8.0-macos.tar.gz"
else
WASI_SDK_DOWNLOAD_URL="https://github.com/CraneStation/wasi-sdk/releases/download/wasi-sdk-8/wasi-sdk-8.0-linux.tar.gz"
endif

all: .wasi-sdk main

main: foo.o bar.o main.o
	$(WASM_LD) -L$(SYSROOT)/lib/wasm32-wasi $(SYSROOT)/lib/wasm32-wasi/crt1.o $^ --no-gc-sections \
	    -lc++ -lc++abi -lc \
	    $(WASI_SDK_DIR)/lib/clang/9.0.0/lib/wasi/libclang_rt.builtins-wasm32.a -o $@


%.o: %.cpp
	$(CLANG) -c $< -o $@

.wasi-sdk:
	mkdir -p $(WASI_SDK_DIR) && cd $(WASI_SDK_DIR) && \
            curl -L $(WASI_SDK_DOWNLOAD_URL) | tar xz --strip-components 1
clean:
	rm main.o foo.o bar.o
