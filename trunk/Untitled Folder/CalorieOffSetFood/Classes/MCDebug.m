//
//  MCDebug.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/9/11.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "MCDebug.h"

void MCDebug(const char *fileName, int lineNumber, NSString *functionName, NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    
    static NSDateFormatter *debugFormatter = nil;
    if (debugFormatter == nil) {
        debugFormatter = [[NSDateFormatter alloc] init];
        [debugFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString *filePath = [[NSString alloc] initWithUTF8String:fileName];    
    NSString *timestamp = [debugFormatter stringFromDate:[NSDate date]];
    
    fprintf(stdout, "%s [%s:%d][%s] %s\n",
            [timestamp UTF8String],
            [[filePath lastPathComponent] UTF8String],
            lineNumber,
            [functionName UTF8String],
            [msg UTF8String]);
    
    va_end(args);
    [msg release];
    [filePath release];
}
