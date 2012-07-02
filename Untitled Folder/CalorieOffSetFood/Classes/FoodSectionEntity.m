//
//  FoodSectionEntity.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/14.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "FoodSectionEntity.h"


@implementation FoodSectionEntity
@synthesize foodSearchNo;
@synthesize foodName;
@synthesize recipeCellArray;
@synthesize category;
@synthesize firstLetter;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
 //   PrintLog(@"[dealloc] %@[%d] %d %d", foodName, [[self foodName] retainCount], [[self recipeCellArray] retainCount], [[self category] retainCount]);
    [foodName release];
    [category release];
    [recipeCellArray release];
    recipeCellArray = nil;
    [firstLetter release];
    [super dealloc];    
}

@end
