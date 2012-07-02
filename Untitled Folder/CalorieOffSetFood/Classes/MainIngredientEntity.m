//
//  MainIngredientEntity.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/18.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "MainIngredientEntity.h"


@implementation MainIngredientEntity
@synthesize mainIngredientName;
@synthesize mainIngredientQty;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [mainIngredientName release];
    [mainIngredientQty release];
    [super dealloc]; 
}

@end
