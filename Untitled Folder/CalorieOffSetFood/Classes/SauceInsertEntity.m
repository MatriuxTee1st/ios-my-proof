//
//  SauceInsertEntity.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "SauceInsertEntity.h"

@implementation SauceInsertEntity

@synthesize sauceAName;
@synthesize sauceAQty;
@synthesize sauceBName;
@synthesize sauceBQty;
@synthesize sauceCName;
@synthesize sauceCQty;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [sauceAName release];
    [sauceAQty release];
    [sauceBName release];
    [sauceBQty release];
    [sauceCName release];
    [sauceCQty release];
    
    [super dealloc];
}

@end
