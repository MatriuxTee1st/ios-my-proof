//
//  MCDebug.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/9/11.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//  NSLog((@"%d: %s: " format), __LINE__, __FUNCTION__, ##__VA_ARGS__) 


//#define _GNU_SOURCE
#ifdef MCDEBUG
#define PrintLog(format...) MCDebug(__FILE__, __LINE__, NSStringFromSelector(_cmd), format)
#define CMD_STR NSStringFromSelector(_cmd)
#else
#define PrintLog(format, ...)
#define CMD_STR
#endif

#import <Foundation/Foundation.h>

void MCDebug(const char *fileName, int lineNumber, NSString *functionName, NSString *fmt, ...);