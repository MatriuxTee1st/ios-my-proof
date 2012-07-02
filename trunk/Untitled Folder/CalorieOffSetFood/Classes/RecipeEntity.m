//
//  RecipeEntity.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/18.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeEntity.h"


@implementation RecipeEntity
@synthesize recipeNo;
@synthesize productId;
@synthesize thumbnailPhotoName;
@synthesize photoName;
@synthesize recipeName;
@synthesize recipeFurigana;
@synthesize isFavorite;
@synthesize time;
@synthesize calorie;
@synthesize commentRecipe;
@synthesize person;
@synthesize bodyType;
@synthesize cost;
@synthesize downloadDate;
@synthesize carbQty;
@synthesize mainIngredientEntityArray;
@synthesize processArray;
@synthesize sauceAEntityArray;
@synthesize sauceBEntityArray;
@synthesize sauceCEntityArray;
@synthesize relationalRecipeCellEntityArray;
@synthesize foodInsertArray;


/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [thumbnailPhotoName release];
    [photoName release];
    [recipeName release];
    [recipeFurigana release];
    [commentRecipe release];
    [mainIngredientEntityArray release];
    [downloadDate release];
    [processArray release];
    [sauceAEntityArray release];
    [sauceBEntityArray release];
    [sauceCEntityArray release];
    [relationalRecipeCellEntityArray release];
    [foodInsertArray release];
    
    [super dealloc];    

//    PrintLog(@"}");
}

@end
