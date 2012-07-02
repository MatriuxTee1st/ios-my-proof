//
//  ImageUtil.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/24/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

// Get image data directory path (create it if it does not exist)
+ (NSString *)imageDataCacheDirectoryPath {
    NSArray *directory          = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory     = [directory objectAtIndex:0];
	NSString *dataDirectoryPath = [cacheDirectory stringByAppendingPathComponent:@"ImageData"];
    NSFileManager *fileManager       = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:dataDirectoryPath])  {
        [fileManager createDirectoryAtPath:dataDirectoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    
    return dataDirectoryPath;
}

// Saveimage
+ (BOOL)saveImage:(UIImage *)image name:(NSString*)imageName {
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    NSString *documentsDirectory = [ImageUtil imageDataCacheDirectoryPath]; //create NSString object, that holds our exact path to the documents directory
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]]; //add our image to the path
    
    BOOL success = [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    if (success) {
        PrintLog(@"Image Saved");
    } else {
        PrintLog(@"Image Failed to Save");
    }
    
    return success;
}

// Remove image
+ (void)removeImage:(NSString*)imageName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [ImageUtil imageDataCacheDirectoryPath];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    [fileManager removeItemAtPath: fullPath error:NULL];
    
    PrintLog(@"Image Removed");
}

// Load image
+ (UIImage*)loadImage:(NSString*)imageName {
    NSString *documentsDirectory = [ImageUtil imageDataCacheDirectoryPath];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    
    return image;
}

// Resize image
+ (UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height {
	
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);

	CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;	
}

@end
