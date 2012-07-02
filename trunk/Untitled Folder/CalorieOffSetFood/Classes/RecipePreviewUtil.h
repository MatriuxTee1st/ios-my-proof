//
//  RecipePreviewUtil.h
//  MedicinalCooking
//
//  Created by Nolan Warner on 3/16/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface RecipePreviewUtil : NSObject <NSURLConnectionDataDelegate> {
    id delegate;
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    NSURLConnection *conn;
}

@property (nonatomic, assign) id delegate;

- (void)getImage:(NSInteger)productId photoNo:(NSInteger)photoNo;
- (void)cancelRequest;

@end

@protocol RecipePreviewImageUtilDelegate

- (void)getPreviewImageFinished:(UIImage *)image;
- (void)getPreviewImageFailed;

@end