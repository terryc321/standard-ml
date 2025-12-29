/* 
	Remember to compile try:
		1) gcc hi.c -o hi -lX11
		2) gcc hi.c -I /usr/include/X11 -L /usr/X11/lib -lX11
		3) gcc hi.c -I /where/ever -L /who/knows/where -l X11

	Brian Hammond 2/9/96.    Feel free to do with this as you will!
*/


/* include the X library headers */
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>

/* include some silly stuff */
#include <stdio.h>
#include <stdlib.h>

/* width height of window */
/* border x y how much pull ball back if goes out of bounds */

#define WIDTH 300
#define HEIGHT 300
#define BORDER_X 2
#define BORDER_Y 2
#define VELOCITY_X 0.0005
#define VELOCITY_Y 0.0012

/* here are our X variables */
Display *dis;
int screen;
Window win;
GC gc;

/* here are our X routines declared! */
void init_x();
void close_x();
void redraw();

float ball_x;
float ball_y;
float ball_vx;
float ball_vy;

int redraw_count;
#define REDRAW_COUNT  200

void get_colors() {
	XColor tmp;
	XParseColor(dis, DefaultColormap(dis,screen), "chartreuse", &tmp);
	XAllocColor(dis,DefaultColormap(dis,screen),&tmp);
	//chartreuse=tmp.pixel;
};

int main(int argc,char **argv) {
  printf("press q to quit\n");
  printf("should see a ball bouncing on screen\n");
  
  
	XEvent event;		/* the XEvent declaration !!! */
	KeySym key;		/* a dealie-bob to handle KeyPress Events */	
	char text[255];		/* a char buffer for KeyPress Events */
	char text_o[2];

	ball_x = 55.0;
	ball_y = 90.0;
	ball_vx = VELOCITY_X;
	ball_vy = VELOCITY_Y; 
	sprintf(text_o, "O");

	init_x();

	/* look for events forever... */
	while(1) {		
		/* get the next event and stuff it into our event variable.
		   Note:  only events we set the mask for are detected!
		*/
		XNextEvent(dis, &event);

		ball_x = ball_x + ball_vx;
		ball_y = ball_y + ball_vy;
		if (ball_x > WIDTH){
		  ball_vx = -ball_vx;
		  ball_x = WIDTH - BORDER_X;
		}
		if (ball_x < 0){
                  ball_x = BORDER_X;
		  ball_vx = -ball_vx;
		}
		if (ball_y > HEIGHT){
		  ball_y = HEIGHT - BORDER_Y;
		  ball_vy = -ball_vy;
		}
		if (ball_y < 0){
		  ball_y = BORDER_Y;
		  ball_vy = -ball_vy;
		}
		
		/* draw something */
		XDrawString(dis,win,gc,(int)ball_x,(int)ball_y, text_o, strlen(text_o));

		unsigned int radius = 20;
		unsigned int diameter = 2 * radius;
		// XFillArc wants: x,y = top-left of bounding box, width,height = diameter
		XFillArc(dis, win, gc,
			 ball_x - radius,      // top-left x
			 ball_y - radius,      // top-left y
			 diameter,        // width
			 diameter,        // height
			 0,               // start angle (in 64ths of degree)
			 360 * 64);       // full circle: 360 degrees × 64
		
		if (event.type==Expose && event.xexpose.count==0) {
		/* the window was exposed redraw it! */
		  //redraw();
		}
		if (event.type==KeyPress&&
		    XLookupString(&event.xkey,text,255,&key,0)==1) {
		/* use the XLookupString routine to convert the invent
		   KeyPress data into regular text.  Weird but necessary...
		*/
			if (text[0]=='q') {
				close_x();
			}
			printf("You pressed the %c key!\n",text[0]);
		}
		if (event.type==ButtonPress) {
		/* tell where the mouse Button was Pressed */
			int x=event.xbutton.x,  y=event.xbutton.y;
			strcpy(text,"X is FUN!");
			XSetForeground(dis,gc,rand()%event.xbutton.x%255);
			XDrawString(dis,win,gc,x,y, text, strlen(text));			
		}

		redraw_count --;
		XClearArea(dis, win, 
			   0, 0,    /* x, y */
			   5, 5,    /* width, height */
			   True);   /* exposures = True → server generates Expose event(s) */
		  
		if (redraw_count < 1){
		  redraw_count = REDRAW_COUNT;
		  XClearArea(dis, win, 0, 0, 0, 0, True);
		  XFlush(dis);
		  //redraw();		  
		}
		
	}
}

void init_x() {
/* get the colors black and white (see section for details) */        
	unsigned long black,white;

	dis=XOpenDisplay((char *)0);
   	screen=DefaultScreen(dis);
	black=BlackPixel(dis,screen),
	white=WhitePixel(dis, screen);
   	win=XCreateSimpleWindow(dis,DefaultRootWindow(dis),0,0,	
		WIDTH, HEIGHT, 5,black, white);
	XSetStandardProperties(dis,win,"Howdy","Hi",None,NULL,0,NULL);
	XSelectInput(dis, win, ExposureMask|ButtonPressMask|KeyPressMask);
        gc=XCreateGC(dis, win, 0,0);        
	XSetBackground(dis,gc,white);
	XSetForeground(dis,gc,black);
	XClearWindow(dis, win);
	XMapRaised(dis, win);
};

void close_x() {
	XFreeGC(dis, gc);
	XDestroyWindow(dis,win);
	XCloseDisplay(dis);	
	exit(1);				
};

void redraw() {
	XClearWindow(dis, win);
};


