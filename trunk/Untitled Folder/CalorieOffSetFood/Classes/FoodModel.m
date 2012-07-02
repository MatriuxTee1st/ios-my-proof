//
//  FoodModel.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/14.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "FoodModel.h"


@implementation FoodModel
@synthesize foodSearchNo;
@synthesize foodName;
@synthesize category;
@synthesize firstLetter;


/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
 //   PrintLog(@"[dealloc]");
    [foodName release];
    [category release];
    [firstLetter release];
    [super dealloc];
}


@end
