#!/bin/bash

# Remember to compile try:
# 		1) gcc hi.c -o hi -lX11
# 		2) gcc hi.c -I /usr/include/X11 -L /usr/X11/lib -lX11
#    	        3) gcc hi.c -I /where/ever -L /who/knows/where -l X11
		      
clang -o bounce bounce.c -I /usr/include/X11 -L /usr/X11/lib -lX11



