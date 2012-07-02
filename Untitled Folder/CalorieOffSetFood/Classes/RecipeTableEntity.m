//
//  RecipeTableEntity.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/21/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeTableEntity.h"

@implementation RecipeTableEntity

@synthesize appStoreProductId;
@synthesize productId;
@synthesize productName;
@synthesize productLeadCell;
@synthesize productLeadDetail;
@synthesize price;
@synthesize recipeNoArray;
@synthesize recipeSizeArray;
@synthesize productImage;
@synthesize previewCount;

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    PrintLog(@"{");
    
    [appStoreProductId release];
    [productName release];
    [productLeadCell release];
    [productLeadDetail release];
    [recipeNoArray release];
    [recipeSizeArray release];
    [productImage release];
    
    [super dealloc];    
    
    PrintLog(@"}");
}

@end