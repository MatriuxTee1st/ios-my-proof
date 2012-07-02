//
//  CategoryEntity.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/25.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "CategoryEntity.h"

@implementation CategoryEntity
@synthesize categoryNo;
@synthesize categoryName;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [categoryName release];
    [super dealloc];    
}


@end
