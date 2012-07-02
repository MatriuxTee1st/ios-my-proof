//
//  FoodInsertEntity.m
//  MedicinalCooking
//
//  Created by Nolan Warner on 3/13/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "FoodInsertEntity.h"

@implementation FoodInsertEntity

@synthesize foodName;
@synthesize foodNameFurigana;
@synthesize category;
@synthesize firstLetter;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [foodName release];
    [foodNameFurigana release];
    [category release];
    [firstLetter release];
    
    [super dealloc];
}

@end