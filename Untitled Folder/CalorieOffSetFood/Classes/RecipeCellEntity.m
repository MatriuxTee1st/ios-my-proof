//
//  RecipeCellEntity.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/14.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeCellEntity.h"


@implementation RecipeCellEntity
@synthesize searchNo;
@synthesize recipeNo;
@synthesize recipeName;
@synthesize cookingTime;
@synthesize calorie;
@synthesize thumbnailPhotoName;
@synthesize productId;
@synthesize downloadDate;
@synthesize carbQty;
@synthesize bodyType;
@synthesize cost;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
//    PrintLog(@"[dealloc] %@[%d] %d %@", recipeName, [recipeName retainCount], [thumbnailPhotoNo retainCount], thumbnailPhotoNo);
    [recipeName release];
    [thumbnailPhotoName release];
    [downloadDate release];
    [super dealloc];
}


@end
