#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <math.h>

//SDL2 includes
#include "SDL.h"
#include "SDL_render.h"

//SDL2_ttf includes
#include "SDL_ttf.h"

//definitions
#define PI 3.141592

#define SCREEN_WIDTH 800
#define SCREEN_HEIGHT 400
#define WINDOW_TITLE "CerebroImagini Viewer"

#define LINES 3

#define POINT_WIDTH 3
#define GRAPH_X_AXIS_POS 200

#define AX_FONT_SIZE 16
#define AX_FONT_HEIGHT 12
#define AX_FONT_WIDTH 10

#define V_AX_MAX 1
#define V_AX_INCREMENT 1

#define H_AX_MAX -1//-1 for scrolling
#define H_AX_INCREMENT 200
#define H_AX_RESOLUTION 20

SDL_Window* wdw;
SDL_Renderer* rend;
SDL_Rect* canvas;
SDL_Rect* point;
SDL_Color* blk;
TTF_Font* font;

int t = 0;

int last_x = 0;
int last_y = GRAPH_X_AXIS_POS;

int h_pts = (H_AX_MAX == -1) ? SCREEN_WIDTH / H_AX_RESOLUTION : H_AX_MAX;

double vratio = (SCREEN_HEIGHT / 2) / V_AX_MAX;

void draw_text(char* label, int len, int x, int y, int w, int h) {
	SDL_Surface* sur = TTF_RenderText_Blended(font, label, *blk);
	SDL_Texture* tex = SDL_CreateTextureFromSurface(rend, sur);

	SDL_Rect* rect = malloc(sizeof(struct SDL_Rect));
	rect->x = x;
	rect->y = y;
	rect->w = w;
	rect->h = h;
	
	SDL_RenderCopy(rend, tex, NULL, rect);
	
	//free(sur);
	//free(tex);
	SDL_FreeSurface(sur);
	SDL_DestroyTexture(tex);
	
	free(rect);
}

void reset_graph(int pres) {
	SDL_RenderClear(rend);
	
	SDL_SetRenderDrawBlendMode(rend, SDL_BLENDMODE_BLEND);
	
	//white bg
	SDL_SetRenderDrawColor(rend, 255, 255, 255, 255);//white
	SDL_RenderFillRect(rend, canvas);
	
	//graph lines
	SDL_SetRenderDrawColor(rend, 0, 0, 0, 255);//black
	SDL_RenderDrawLine(rend, 0, GRAPH_X_AXIS_POS, SCREEN_WIDTH, GRAPH_X_AXIS_POS);
	SDL_RenderDrawLine(rend, 0, 0, 0, SCREEN_HEIGHT);
	
	//vertical (y) axis labels
	int incr = SCREEN_HEIGHT / (V_AX_MAX / V_AX_INCREMENT) / 2;
	incr -= AX_FONT_HEIGHT / 2;
	int cur = V_AX_MAX;
	
	for (int i = 0; i < SCREEN_HEIGHT; i += incr) {
		int len = log10(abs(cur)) + 1;
		
		char label[sizeof(V_AX_MAX) + 1];
		sprintf(label, "%+i", cur);
		
		cur -= V_AX_INCREMENT;
		
		//printf("%i\n", cur);

		draw_text(&label[0], len, 2, i, AX_FONT_WIDTH * len, AX_FONT_HEIGHT);
	}

	//horizontal (x) axis labels
	int labels = SCREEN_WIDTH / H_AX_INCREMENT;
	
	for (int i = 0; i < SCREEN_WIDTH; i += H_AX_INCREMENT) {
		int len = 5;//log10(abs(t));
		
		char label[len];
		sprintf(label, "%5i", t - labels * H_AX_INCREMENT);
		
		//printf("%i\n", i);
		
		draw_text(&label[0], len, i, GRAPH_X_AXIS_POS + 1 + AX_FONT_HEIGHT, AX_FONT_WIDTH * len, AX_FONT_HEIGHT);
		
		SDL_RenderDrawLine(rend, i, 0, i, SCREEN_HEIGHT);
		
		labels--;
	}
	
	//current time display in top-right corner
	int len = 5;
	char label[len];
	sprintf(label, "%5i", t);
	
	draw_text(&label[0], len, SCREEN_WIDTH - AX_FONT_WIDTH * len - 4, 4, AX_FONT_WIDTH * len, AX_FONT_HEIGHT);
	
	last_x = 0;//for scrolling
	
	if (pres) SDL_RenderPresent(rend);
}

void graph_arr(double* arr, int n, int r, int g, int b, int pres) {
	SDL_SetRenderDrawColor(rend, r, g, b, 255);
	
	for (int i = 1; i <= n; i++) {
		SDL_RenderDrawLine(rend, (i-1) * H_AX_RESOLUTION, arr[i-1], i * H_AX_RESOLUTION, arr[i]);
	}
	
	if (pres) SDL_RenderPresent(rend);
}

double scale_y(double y) {
	return GRAPH_X_AXIS_POS - y * vratio;
}

void shift_in_arr(double* arr, double val, int loc) {
	for (int i = 0; i < loc; i++){        
		arr[i]=arr[i+1];
	}
	arr[loc] = val;
}

int exit_check() {
	SDL_Event evt;
	SDL_PollEvent(&evt);
	switch (evt.type) {
		case SDL_QUIT:
		case SDL_APP_TERMINATING:
		case SDL_APP_LOWMEMORY:
			_exit(0); return 1;
		default: break;//nothing
	}
	return 0;
}

int main(int argc, char* argv[]) {
	SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS);
	TTF_Init();
	
	atexit(TTF_Quit);
	atexit(SDL_Quit);
	
	wdw = SDL_CreateWindow(WINDOW_TITLE, 
		SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, //undefined x, y = centered
		SCREEN_WIDTH, SCREEN_HEIGHT, 
		SDL_WINDOW_SHOWN);
		
	rend = SDL_CreateRenderer(wdw, -1, //-1 = next available
		SDL_RENDERER_ACCELERATED);
	
	canvas = malloc(sizeof(struct SDL_Rect));
	canvas->x = 0;
	canvas->y = 0;
	canvas->w = SCREEN_WIDTH;
	canvas->h = SCREEN_HEIGHT;
	
	point = malloc(sizeof(struct SDL_Rect));
	point->x = 0;
	point->y = 0;
	point->w = POINT_WIDTH;
	point->h = POINT_WIDTH;
	
	blk = malloc(sizeof(struct SDL_Color));
	blk->r = 0;
	blk->g = 0;
	blk->b = 0;
	blk->a = 255;
	
	font = TTF_OpenFont("res/pixelFJ/pixelFJ8pt1__.TTF", AX_FONT_SIZE);
	
	reset_graph(1);
	
	double red[h_pts + 1];
	double blue[h_pts + 1];
	double grn[h_pts + 1];
	
	double period = h_pts / PI;//arbitrary testing period for wave functions
	
	while(!exit_check()) {
		usleep(2);//read every 2 microseconds
		
		t++;
			
		int loc = t < h_pts ? t : h_pts;
			
		shift_in_arr(&red[0], scale_y(sin(t / period)), loc);
		shift_in_arr(&blue[0], scale_y(cos(t / period)), loc);
		shift_in_arr(&grn[0], scale_y(tan(t / period)), loc);
			
		graph_arr(&red[0], h_pts, 255, 0, 0, 0);
		graph_arr(&blue[0], h_pts, 0, 255, 0, 0);
		graph_arr(&grn[0], h_pts, 0, 0, 255, t >= 200);
			
		reset_graph(0);
	}
	
	//necessary?
	SDL_DestroyRenderer(rend);
	SDL_DestroyWindow(wdw);
	free(canvas);
	free(point);
	free(blk);
	
	return 0;
}