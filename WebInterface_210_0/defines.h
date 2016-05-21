//
//  defines.h
//  Tabelle_10*10
//
//  Created by Ruedi Heimlicher on 11.05.2016.
//
//
#include <stdio.h>
#ifndef defines_h
#define defines_h

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)


#define SHOWLOG 1

#endif /* defines_h */