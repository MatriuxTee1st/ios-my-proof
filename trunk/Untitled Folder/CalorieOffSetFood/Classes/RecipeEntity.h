//
//  RecipeEntity.h
//  MedicinalCarbOff
//
//  個別レシピ画面のデータ
//
//  Created by 近藤 雅人 on 11/10/18.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RecipeEntity : NSObject {
    int recipeNo;
    int productId;
    NSString *thumbnailPhotoName;
    NSString *photoName;
    NSString *recipeName;
    NSString *recipeFurigana;
    BOOL isFavorite;
    int time;
    int calorie;
    NSString *commentRecipe;
    int person;
    NSDate *downloadDate;
    float carbQty;
    int bodyType;
    int cost;
    NSMutableArray *mainIngredientEntityArray;
    NSMutableArray *processArray;
    NSMutableArray *sauceAEntityArray;
    NSMutableArray *sauceBEntityArray;
    NSMutableArray *sauceCEntityArray;
    NSMutableArray *relationalRecipeCellEntityArray;
    NSMutableArray *foodInsertArray;
}

@property(nonatomic) int recipeNo;
@property(nonatomic) int productId;
@property(nonatomic, retain) NSString *thumbnailPhotoName;
@property(nonatomic, retain) NSString *photoName;
@property(nonatomic, retain) NSString *recipeName;
@property(nonatomic, retain) NSString *recipeFurigana;
@property(nonatomic, assign) BOOL isFavorite;
@property(nonatomic) int time;
@property(nonatomic) int calorie;
@property(nonatomic, retain) NSString *commentRecipe;
@property(nonatomic) int person;
@property(nonatomic, retain) NSDate *downloadDate;
@property(nonatomic) float carbQty;
@property(nonatomic) int bodyType;
@property(nonatomic) int cost;
@property(nonatomic, retain) NSMutableArray *mainIngredientEntityArray;
@property(nonatomic, retain) NSMutableArray *processArray;
@property(nonatomic, retain) NSMutableArray *sauceAEntityArray;
@property(nonatomic, retain) NSMutableArray *sauceBEntityArray;
@property(nonatomic, retain) NSMutableArray *sauceCEntityArray;
@property(nonatomic, retain) NSMutableArray *relationalRecipeCellEntityArray;
@property(nonatomic, retain) NSMutableArray *foodInsertArray;

@end
