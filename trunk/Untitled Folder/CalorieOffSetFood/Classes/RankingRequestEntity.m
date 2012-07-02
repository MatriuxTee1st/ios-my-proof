//
//  RankingRequestEntity.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/26.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "RankingRequestEntity.h"

@implementation RankingRequestEntity
@synthesize recipeNo;
@synthesize viewDate;

/***************************************************************
 * 初期化時
 ***************************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super init]) {
        recipeNo = [aDecoder decodeIntegerForKey:@"recipeNo"];
        viewDate = [[aDecoder decodeObjectForKey:@"viewDate"] retain];
        PrintLog(@"recipeNo = %d", recipeNo);
    }
    return self;
}

/***************************************************************
 * シリアライズ時
 ***************************************************************/
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:recipeNo forKey:@"recipeNo"];
    [aCoder encodeObject:viewDate forKey:@"viewDate"];
    PrintLog(@"recipeNo = %d", recipeNo);
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [viewDate release];
    [super dealloc];
}

@end
