//
//  ProductCountUtil.h
//  MedicinalCooking
//
//  Created by Nolan Warner on 3/12/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ProductCountUtil : NSObject <NSURLConnectionDataDelegate> {
    id delegate;
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    NSURLConnection *conn;
}

@property (nonatomic, assign) id delegate;

- (void)getProductCount:(NSDate *) updateDate;
- (void)cancelRequest;

@end

@protocol ProductCountUtilDelegate

- (void)productCountRequestFinishedWithIDs:(NSArray *)productIdArray;
- (void)productCountRequestFailed;

@end