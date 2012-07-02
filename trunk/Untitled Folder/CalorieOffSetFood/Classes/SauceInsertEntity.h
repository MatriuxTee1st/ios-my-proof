//
//  SauceInsertEntity.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SauceInsertEntity : NSObject {
    NSString *sauceAName;
    NSString *sauceAQty;
    NSString *sauceBName;
    NSString *sauceBQty;
    NSString *sauceCName;
    NSString *sauceCQty;
}

@property(nonatomic, retain) NSString *sauceAName;
@property(nonatomic, retain) NSString *sauceAQty;
@property(nonatomic, retain) NSString *sauceBName;
@property(nonatomic, retain) NSString *sauceBQty;
@property(nonatomic, retain) NSString *sauceCName;
@property(nonatomic, retain) NSString *sauceCQty;

@end
