//
//  DatabaseUtility.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "RecipeCellEntity.h"
#import "FoodModel.h"
#import "RecipeEntity.h"
#import "MainIngredientEntity.h"
#import "SauceEntity.h"
#import "CategoryEntity.h"

#define BASEDB @"CalorieOffSetFood.sqlite"
#define DBPATH @"CalorieOffSetFoodData.sqlite"
#define DBFLAG @"dbflag"


@interface DatabaseUtility : NSObject {
    
}

- (void)initializeDatabaseIfNeeded;
+ (NSString *)getDatabaseFilePath;
+ (NSMutableArray *)selectFoodSection;
+ (NSMutableArray *)selectRecipeCell;
+ (NSMutableArray *)selectAllRecipeData;
+ (int)selectIsFavoriteWithRecipeNo:(int)recipeNo;
+ (int)selectRecipeCount;
+ (int)selectNewProductCount;
+ (NSArray *)selectCategory;
+ (NSArray *)selectRecipeWithCategoryNo:(int)categoryNo;
+ (NSArray *)selectRelationalRecipeArrayWithRecipeNo:(int)recipeNo;
+ (NSArray *)selectRelationalRecipeNoWithRecipeNo:(int)recipeNo;
+ (NSArray *)selectMainIngredientArrayWithRecipeNo:(int)recipeNo;
+ (NSArray *)selectFoodSectionWithCategory:(NSString *)category;
+ (NSArray *)selectRecipeCellWithCategory:(NSString *)category;
+ (NSMutableArray *)selectRecipeCellWithBodyType:(NSInteger)bodyType;
+ (NSMutableArray *)selectSetRecipeArrayWithRecipeNo:(int)recipeNo;
+ (RecipeEntity *)selectSetFoodDetail:(int)recipeNo;
+ (RecipeCellEntity *)selectRecipeCellWithRecipeNo:(int)recipeNo;
+ (RecipeEntity *)selectRecipeDataWithRecipeNo:(int)recipeNo;
+ (NSMutableArray *)selectFavoritesData;
+ (NSArray *)selectSauceAArrayWithRecipeNo:(int)recipeNo;
+ (NSArray *)selectSauceBArrayWithRecipeNo:(int)recipeNo;
+ (NSArray *)selectSauceCArrayWithRecipeNo:(int)recipeNo;
+ (NSArray *)selectProcessArrayWithRecipeNo:(int)recipeNo;
+ (NSDate *)selectDownloadDate:(int)recipeNo;
+ (BOOL)checkProductExists:(int)productId;
+ (BOOL)checkDoesRecipeExist:(NSInteger)recipeNo;
+ (BOOL)updateFavoritesRecipeNo:(int)recipeNo value:(BOOL)isFavoriteBool date:(NSString *)currentDate;
+ (BOOL)insertNewRecipeForRecipeEntityArray:(NSArray *)recipeArray;
+ (BOOL)insertDownloadDateColumn;
+ (BOOL)insertProductIdColumn;
+ (BOOL)insertCostColumn;
+ (BOOL)addCostData;
+ (BOOL)insertFoodNameFuriganaColumn;
+ (BOOL)addCategoryFoodRows;
+ (BOOL)updateFoodMushroomRows;
@end
