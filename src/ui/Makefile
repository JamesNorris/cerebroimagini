# dependencies:
# autoconf
# automake
# make (obviously)
# gcc
# SDL2
# SDL2_ttf
# Freetype 2

SDL_DIR=lib/SDL2-2.0.8
SDL_TTF_DIR=lib/SDL2_ttf-2.0.14
FT_DIR=$(SDL_TTF_DIR)/external/freetype-2.4.12

LIB_FLAGS=-Wno-unused-variable

all:
	$(MAKE) libs
	$(MAKE) local
	
libs:
	cd $(SDL_DIR) && ./configure && make $(LIB_FLAGS) && make install
	cd $(FT_DIR) && ./configure && make $(LIB_FLAGS) && make install
	cd $(SDL_TTF_DIR) && ./configure && make $(LIB_FLAGS) && make install

test:
	$(MAKE) local

local:
	$(MAKE) clean
	gcc wave.c -o wave.exe -llibSDL2 -llibfreetype -llibSDL2_ttf `$(SDL_DIR)/sdl2-config --cflags --libs` 
	./wave.exe
	
clean:
	rm -rf wave.exe