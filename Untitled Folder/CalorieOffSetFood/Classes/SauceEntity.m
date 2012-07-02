//
//  SauceEntity.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/18.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "SauceEntity.h"


@implementation SauceEntity
@synthesize sauceName;
@synthesize sauceQty;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [sauceName release];
    [sauceQty release];
    [super dealloc]; 
}


@end
