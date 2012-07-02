//
//  ImageUtil.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/24/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject

+ (NSString *)imageDataCacheDirectoryPath;
+ (BOOL)saveImage:(UIImage *)image name:(NSString*)imageName;
+ (void)removeImage:(NSString*)imageName;
+ (UIImage*)loadImage:(NSString*)imageName;
+ (UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height;

@end
