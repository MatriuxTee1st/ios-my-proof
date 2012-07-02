//
//  DatabaseUtility.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "DatabaseUtility.h"
#import "SauceInsertEntity.h"
#import "FoodInsertEntity.h"

@implementation DatabaseUtility

/***************************************************************
 * DB初期設定
 ***************************************************************/
- (void)initializeDatabaseIfNeeded {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* flagPath = [documentsDir stringByAppendingPathComponent:DBFLAG];
    
    // dbflag file check
    if (![fileManager fileExistsAtPath:flagPath]) {
        NSString* dbpath = [DatabaseUtility getDatabaseFilePath];
        NSString* templateDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:BASEDB];
        
        // remove database file
        if([fileManager fileExistsAtPath:dbpath] == YES) {
            [fileManager removeItemAtPath:dbpath error:NULL];
        }
        
        // copy database file
        if (![fileManager copyItemAtPath:templateDBPath toPath:dbpath error:&error]) {
            [error localizedDescription];
            return;
        }
        
        // dbflag file create
        [fileManager createFileAtPath:flagPath contents:nil attributes:nil];
    }
    
}

/***************************************************************
 * DBファイルパス取得
 ***************************************************************/
+ (NSString*)getDatabaseFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:DBPATH];
}


/***************************************************************
 * SQL SELECT文
 * お気に入りに登録済みかをレシピ番号から抽出する
 * ・ブックマークボタンの判定で利用
 ***************************************************************/
+ (int)selectIsFavoriteWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select is_favorite from recipe_base where recipe_no=%d", recipeNo];

    int result = 0;
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return 0;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    if ([resultSet next]) {
        result = [resultSet intForColumn:@"is_favorite"];
    }
        
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * レシピの合計を返す
 * ・レシピ追加で利用
 ***************************************************************/
+ (int)selectRecipeCount {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select COUNT(recipe_no) from recipe_base;"];
    
    int result = 0;
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return 0;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    if ([resultSet next]) {
        result = [resultSet intForColumnIndex:0];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 新しいレシピの合計を返す
 * ・レシピ追加で利用
 ***************************************************************/
+ (int)selectNewProductCount {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select COUNT(distinct product_id) from recipe_base;"];
    
    int result = 0;
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return 0;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    if ([resultSet next]) {
        result = [resultSet intForColumnIndex:0];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 食材名をカテゴリで絞り、食材シーケンス順に取得
 * ・食材検索画面のテーブルのセクションに利用する
 ***************************************************************/
+ (NSArray *)selectFoodSectionWithCategory:(NSString *)category {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select distinct f.food_search_no, f.food_name, f.category, f.first_letter from food f, main_ingredient m where f.food_name=m.main_ingredient_name and f.category='%@' order by f.food_name_furigana asc", category];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        FoodModel *foodModel = [[FoodModel alloc] init];
        [foodModel setFoodSearchNo:[resultSet intForColumn:@"food_search_no"]];
        [foodModel setFoodName:[resultSet stringForColumn:@"food_name"]];
        [foodModel setFirstLetter:[resultSet stringForColumn:@"first_letter"]];
        NSString *category = [resultSet stringForColumn:@"category"];
        [foodModel setCategory:category];
        [result addObject:foodModel];
        [foodModel release];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * ・主菜・副菜を返す
 ***************************************************************/
+ (NSArray *)selectCategory {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select category_no, category_name from category order by category_no asc "];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
        [categoryEntity setCategoryNo:[resultSet intForColumn:@"category_no"]];
        [categoryEntity setCategoryName:[resultSet stringForColumn:@"category_name"]];
        [result addObject:categoryEntity];
        [categoryEntity release];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * ・１つの主菜・副菜からレシピ一覧を返す
 ***************************************************************/
+ (NSArray *)selectRecipeWithCategoryNo:(int)categoryNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select r.recipe_no, r.recipe_name, r.time, r.calorie, r.thumbnail_photo_no, r.carb_qty from recipe_base r, category c, category_relation_recipe cr where c.category_no=%d and c.category_no=cr.category_no and cr.relation_recipe_no=r.recipe_no", categoryNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setRecipeNo:[resultSet intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSet stringForColumn:@"recipe_name"]];
        [recipeCellEntity setTime:[resultSet intForColumn:@"time"]];
        [recipeCellEntity setCalorie:[resultSet intForColumn:@"calorie"]];
        [recipeCellEntity setThumbnailPhotoNo:[resultSet stringForColumn:@"thumbnail_photo_no"]];
        [recipeCellEntity setCarbQty:[resultSet doubleForColumn:@"carb_qty"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 食材名を食材シーケンス順に取得
 * ・食材検索画面のテーブルのセクションに利用する
 ***************************************************************/
+ (NSArray *)selectFoodSection {
    PrintLog(@"{");
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select distinct f.food_search_no, f.food_name, f.category, f.first_letter from food f, main_ingredient m where f.food_name=m.main_ingredient_name and not f.category='' order by f.food_name_furigana asc"];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    
    
    while ([resultSet next]) {
        FoodModel *foodModel = [[FoodModel alloc] init];
        [foodModel setFoodSearchNo:[resultSet intForColumn:@"food_search_no"]];
        [foodModel setFoodName:[resultSet stringForColumn:@"food_name"]];
        [foodModel setFirstLetter:[resultSet stringForColumn:@"first_letter"]];
        NSString *category = [resultSet stringForColumn:@"category"];
        if ([category length] == 0) {
            category = [[[NSString alloc] initWithUTF8String:"no"] autorelease];
        }
        [foodModel setCategory:category];
        [result addObject:foodModel];
        [foodModel release];
    }
    
    [resultSet close];
    [db close];
    
    PrintLog(@"}");
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 関連レシピをレシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (NSArray *)selectRelationalRecipeArrayWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select r.recipe_no, r.recipe_name, r.time, r.calorie, r.carb_qty, r.thumbnail_photo_no from recipe_base r, relation_recipe rr where rr.recipe_no=%d and r.recipe_no=rr.relation_recipe_no", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setRecipeNo:[resultSet intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSet stringForColumn:@"recipe_name"]];
        [recipeCellEntity setTime:[resultSet intForColumn:@"time"]];
        [recipeCellEntity setCalorie:[resultSet intForColumn:@"calorie"]];
        [recipeCellEntity setThumbnailPhotoNo:[resultSet stringForColumn:@"thumbnail_photo_no"]];
        [recipeCellEntity setCarbQty:[resultSet doubleForColumn:@"carb_qty"]];
       
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 関連レシピをレシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (NSArray *)selectRelationalRecipeNoWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select relation_recipe_no from relation_recipe where recipe_no=%d", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        [result addObject:[NSNumber numberWithInt:[resultSet intForColumn:@"relation_recipe_no"]]];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * メイン材料の配列をレシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (NSArray *)selectMainIngredientArrayWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select main_ingredient_name, main_ingredient_qty from main_ingredient where recipe_no=%d", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        MainIngredientEntity *mainIngredientEntity = [[MainIngredientEntity alloc] init];
        [mainIngredientEntity setMainIngredientName:[resultSet stringForColumn:@"main_ingredient_name"]];
        [mainIngredientEntity setMainIngredientQty:[resultSet stringForColumn:@"main_ingredient_qty"]];
        [result addObject:mainIngredientEntity];
        [mainIngredientEntity release];
    }
    
    [resultSet close];
    [db close];
    
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 調味料Aの配列をレシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (NSArray *)selectSauceAArrayWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select sauce_a_name, sauce_a_qty from sauce where recipe_no=%d", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        if ([[resultSet stringForColumn:@"sauce_a_name"] length] != 0) {
            SauceEntity *sauceEntity = [[SauceEntity alloc] init];
            [sauceEntity setSauceName:[resultSet stringForColumn:@"sauce_a_name"]];
            [sauceEntity setSauceQty:[resultSet stringForColumn:@"sauce_a_qty"]];
            [result addObject:sauceEntity];
            [sauceEntity release];            
        }
    }
    
    [resultSet close];
    [db close];
    
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 調味料Bの配列をレシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (NSArray *)selectSauceBArrayWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select sauce_b_name, sauce_b_qty from sauce where recipe_no=%d", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        if ([[resultSet stringForColumn:@"sauce_b_name"] length] != 0) {
            SauceEntity *sauceEntity = [[SauceEntity alloc] init];
            [sauceEntity setSauceName:[resultSet stringForColumn:@"sauce_b_name"]];
            [sauceEntity setSauceQty:[resultSet stringForColumn:@"sauce_b_qty"]];
            [result addObject:sauceEntity];
            [sauceEntity release];
        }
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 調味料Cの配列をレシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (NSArray *)selectSauceCArrayWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select sauce_c_name, sauce_c_qty from sauce where recipe_no=%d", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        if ([[resultSet stringForColumn:@"sauce_c_name"] length] != 0) {

            SauceEntity *sauceEntity = [[SauceEntity alloc] init];
            [sauceEntity setSauceName:[resultSet stringForColumn:@"sauce_c_name"]];
            [sauceEntity setSauceQty:[resultSet stringForColumn:@"sauce_c_qty"]];
            [result addObject:sauceEntity];
            [sauceEntity release];
        }
    }
    
    [resultSet close];
    [db close];
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 作り方テキストの配列をレシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (NSArray *)selectProcessArrayWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select recipe_no, process1, process2, process3, process4, process5, process6, process7, process8, process9  from process where recipe_no=%d", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];

    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        if ([[resultSet stringForColumn:@"process1"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process1"]];            
        }
        if ([[resultSet stringForColumn:@"process2"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process2"]];
        }
        if ([[resultSet stringForColumn:@"process3"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process3"]];
        }
        if ([[resultSet stringForColumn:@"process4"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process4"]];
        }
        if ([[resultSet stringForColumn:@"process5"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process5"]];
        }
        if ([[resultSet stringForColumn:@"process6"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process6"]];
        }
        if ([[resultSet stringForColumn:@"process7"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process7"]];
        }
        if ([[resultSet stringForColumn:@"process8"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process8"]];
        }
        if ([[resultSet stringForColumn:@"process9"] length] != 0) {
            [result addObject:[resultSet stringForColumn:@"process9"]];
        }
    }
    
    [resultSet close];
    [db close];
    
    
    return result;
}


/***************************************************************
 * SQL SELECT文
 * レシピ情報１件を、レシピ番号から抽出する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (RecipeEntity *)selectRecipeDataWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select recipe_no, recipe_name, time, calorie, photo_no, thumbnail_photo_no, comment_recipe, person, carb_qty, is_favorite from recipe_base where recipe_no=%d", recipeNo];
    RecipeEntity* result = [[[RecipeEntity alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    if ([resultSet next]) {
        [result setRecipeNo:[resultSet intForColumn:@"recipe_no"]];
        [result setRecipeName:[resultSet stringForColumn:@"recipe_name"]];
        [result setTime:[resultSet intForColumn:@"time"]];
        [result setCalorie:[resultSet intForColumn:@"calorie"]];
        [result setPhotoName:[resultSet stringForColumn:@"photo_name"]];
        [result setThumbnailPhotoName:[resultSet stringForColumn:@"thumbnail_photo_name"]];
        [result setCommentRecipe:[resultSet stringForColumn:@"comment_recipe"]];
        [result setPerson:[resultSet intForColumn:@"person"]];
        [result setCarbQty:[resultSet doubleForColumn:@"carb_qty"]];
        if ([resultSet intForColumn:@"is_favorite"] == 1) {
            [result setIsFavorite:YES];
        } else {
            [result setIsFavorite:NO];
        }
    } else {
        return result = nil;
    }
    
    [resultSet close];
    [db close];
    return result;
    
}

/***************************************************************
 * SQL SELECT文
 * レシピ情報全件を、レシピ番号から抽出する
 * ・写真から探す画面で利用
 ***************************************************************/
+ (NSMutableArray *)selectAllRecipeData {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select recipe_no, recipe_name, time, calorie, carb_qty, thumbnail_photo_no, photo_no from recipe_base where recipe_no > %d order by download_date desc, recipe_no asc", kRecipeCount];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    
    // アドオンレシピをDBから読み込む
    FMResultSet* resultSetPurchase = nil;
    resultSetPurchase = [db executeQuery:sql];
    
    while ([resultSetPurchase next]) {
        RecipeEntity *recipeEntity = [[RecipeEntity alloc] init];
        [recipeEntity setRecipeNo:[resultSetPurchase intForColumn:@"recipe_no"]];
        [recipeEntity setRecipeName:[resultSetPurchase stringForColumn:@"recipe_name"]];
        [recipeEntity setTime:[resultSetPurchase intForColumn:@"time"]];
        [recipeEntity setCalorie:[resultSetPurchase intForColumn:@"calorie"]];
        [recipeEntity setThumbnailPhotoNo:[resultSetPurchase stringForColumn:@"thumbnail_photo_no"]];
        [recipeEntity setPhotoNo:[resultSetPurchase stringForColumn:@"photo_no"]];
        [recipeEntity setCarbQty:[resultSetPurchase doubleForColumn:@"carb_qty"]];
        [result addObject:recipeEntity];
        [recipeEntity release];
    }   
    
    [resultSetPurchase close];
    
    // オリジナルレシピをDBじから読み込む
    sql = [NSString stringWithFormat:@"select recipe_no, recipe_name, time, calorie, carb_qty, thumbnail_photo_no, photo_no from recipe_base where recipe_no <= %d", kRecipeCount];
    FMResultSet* resultSetOriginal = nil;
    resultSetOriginal = [db executeQuery:sql];
    
    while ([resultSetOriginal next]) {
        RecipeEntity *recipeEntity = [[RecipeEntity alloc] init];
        [recipeEntity setRecipeNo:[resultSetOriginal intForColumn:@"recipe_no"]];
        [recipeEntity setRecipeName:[resultSetOriginal stringForColumn:@"recipe_name"]];
        [recipeEntity setTime:[resultSetOriginal intForColumn:@"time"]];
        [recipeEntity setCalorie:[resultSetOriginal intForColumn:@"calorie"]];
        [recipeEntity setThumbnailPhotoNo:[resultSetOriginal stringForColumn:@"thumbnail_photo_no"]];
        [recipeEntity setPhotoNo:[resultSetOriginal stringForColumn:@"photo_no"]];
        [recipeEntity setCarbQty:[resultSetOriginal doubleForColumn:@"carb_qty"]];
        [result addObject:recipeEntity];
        [recipeEntity release];
    }   
    
    [resultSetOriginal close];
    [db close];
    
    return result;
    
}


/***************************************************************
 * SQL SELECT文
 * レシピ情報一覧をカテゴリで絞り、食材シーケンス順に取得
 * ・食材検索画面のテーブルのセクション内のセルに利用する
 ***************************************************************/
/*
+ (NSArray *)selectRecipeCellWithCategory:(NSString *)category {
    PrintLog(@"{");
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select distinct f.food_search_no food_search_no, m.recipe_no, r.recipe_name, r.time, r.calorie, r.carb_qty, r.thumbnail_photo_no from food f, main_ingredient m, recipe_base r where f.category='%@' and f.food_name = m.main_ingredient_name and r.recipe_no = m.recipe_no and r.recipe_no > %d order by r.download_date desc", category, kRecipeCount];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    // 購入したレシピを読み込む
    FMResultSet* resultSetPurchase = nil;
    resultSetPurchase = [db executeQuery:sql];
    
    while ([resultSetPurchase next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setSearchNo:[resultSetPurchase intForColumn:@"food_search_no"]];
        [recipeCellEntity setRecipeNo:[resultSetPurchase intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSetPurchase stringForColumn:@"recipe_name"]];
        [recipeCellEntity setTime:[resultSetPurchase intForColumn:@"time"]];
        [recipeCellEntity setCalorie:[resultSetPurchase intForColumn:@"calorie"]];
        [recipeCellEntity setThumbnailPhotoNo:[resultSetPurchase stringForColumn:@"thumbnail_photo_no"]];
        [recipeCellEntity setCarbQty:[resultSetPurchase doubleForColumn:@"carb_qty"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSetPurchase close];
    
    // オリジナルレシピを読み込む
    sql = [NSString stringWithFormat:@"select distinct f.food_search_no food_search_no, m.recipe_no, r.recipe_name, r.time, r.calorie, r.carb_qty, r.thumbnail_photo_no from food f, main_ingredient m, recipe_base r where f.category='%@' and f.food_name = m.main_ingredient_name and r.recipe_no = m.recipe_no and r.recipe_no <= %d order by f.food_search_no asc", category, kRecipeCount];
    FMResultSet* resultSetOriginal = nil;
    resultSetOriginal = [db executeQuery:sql];
    
    while ([resultSetOriginal next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setSearchNo:[resultSetOriginal intForColumn:@"food_search_no"]];
        [recipeCellEntity setRecipeNo:[resultSetOriginal intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSetOriginal stringForColumn:@"recipe_name"]];
        [recipeCellEntity setTime:[resultSetOriginal intForColumn:@"time"]];
        [recipeCellEntity setCalorie:[resultSetOriginal intForColumn:@"calorie"]];
        [recipeCellEntity setThumbnailPhotoNo:[resultSetOriginal stringForColumn:@"thumbnail_photo_no"]];
        [recipeCellEntity setCarbQty:[resultSetOriginal doubleForColumn:@"carb_qty"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSetOriginal close];
	
    
    [db close];
    PrintLog(@"}");
    
    return result;
}
*/

/***************************************************************
 * SQL SELECT文
 * レシピ情報一覧をカテゴリで絞り、食材シーケンス順に取得
 * ・食材検索画面のテーブルのセクション内のセルに利用する
 ***************************************************************/
+ (NSArray *)selectRecipeCellWithCategory:(NSString *)category {
    PrintLog(@"{");
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select set_no, set_name, calorie, thumbnail_photo_name, photo_name, type from set_food", category, kRecipeCount];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    // オリジナルレシピを読み込む
    FMResultSet* resultSetOriginal = nil;
    resultSetOriginal = [db executeQuery:sql];
    
    while ([resultSetOriginal next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setRecipeNo:[resultSetOriginal intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSetOriginal stringForColumn:@"recipe_name"]];
        [recipeCellEntity setCalorie:[resultSetOriginal intForColumn:@"calorie"]];
        [recipeCellEntity setThumbnailPhotoName:[resultSetOriginal stringForColumn:@"thumbnail_photo_name"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSetOriginal close];

    
    [db close];
    PrintLog(@"}");
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * レシピ情報一覧を体質で絞り、食材シーケンス順に取得
 * ・体質別検索画面のテーブルのセクション内のセルに利用する
 ***************************************************************/
+ (NSMutableArray *)selectRecipeCellWithBodyType:(NSInteger)bodyType {
    PrintLog(@"{");
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select a.set_no, a.set_name, sum(b.cost) as cost, a.calorie, a.thumbnail_photo_name, a.type from set_food a left outer join separate_recipe b on a.set_no = b.set_no where type='%d' group by a.set_no", bodyType];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];

    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    // オリジナルレシピを読み込む
    FMResultSet* resultSetOriginal = nil;
    resultSetOriginal = [db executeQuery:sql];
    
    while ([resultSetOriginal next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setRecipeNo:[resultSetOriginal intForColumn:@"set_no"]];
        [recipeCellEntity setRecipeName:[resultSetOriginal stringForColumn:@"set_name"]];
        [recipeCellEntity setCost:[resultSetOriginal intForColumn:@"cost"]];
        [recipeCellEntity setCalorie:[resultSetOriginal intForColumn:@"calorie"]];
        [recipeCellEntity setThumbnailPhotoName:[resultSetOriginal stringForColumn:@"thumbnail_photo_name"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSetOriginal close];
    
    
    [db close];
    PrintLog(@"}");
    
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 
 * ・
 ***************************************************************/
+ (RecipeEntity *)selectSetFoodDetail:(int)setNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select a.set_no, a.set_name, sum(b.cost) as cost, a.calorie, a.photo_name, a.comment from set_food a left outer join separate_recipe b on a.set_no = b.set_no where a.set_no='%d' group by a.set_no", setNo];
    RecipeEntity* result = [[[RecipeEntity alloc] init] autorelease];
	
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    if ([resultSet next]) {
        [result setRecipeNo:[resultSet intForColumn:@"set_no"]];
        [result setRecipeName:[resultSet stringForColumn:@"set_name"]];
        [result setCost:[resultSet intForColumn:@"cost"]];
        [result setCalorie:[resultSet intForColumn:@"calorie"]];
        [result setPhotoName:[resultSet stringForColumn:@"photo_name"]];
        [result setCommentRecipe:[resultSet stringForColumn:@"comment"]];
    } else {
        return result = nil;
    }

    [resultSet close];
    [db close];
    return result;
}

/***************************************************************
 * SQL SELECT文
 * 定食番号から関係するレシピを抽出する
 * ・定食詳細画面で利用
 ***************************************************************/
+ (NSMutableArray *)selectSetRecipeArrayWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select recipe_no, recipe_name, cost, calorie, cooking_time, thumbnail_photo_name from separate_recipe where set_no='%d'", recipeNo];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
	// オリジナルレシピを読み込む
    FMResultSet* resultSetOriginal = nil;
    resultSetOriginal = [db executeQuery:sql];
    
    while ([resultSetOriginal next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setRecipeNo:[resultSetOriginal intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSetOriginal stringForColumn:@"recipe_name"]];
        [recipeCellEntity setCost:[resultSetOriginal intForColumn:@"cost"]];
        [recipeCellEntity setCalorie:[resultSetOriginal intForColumn:@"calorie"]];
        [recipeCellEntity setCookingTime:[resultSetOriginal intForColumn:@"cooking_time"]];
        [recipeCellEntity setThumbnailPhotoName:[resultSetOriginal stringForColumn:@"thumbnail_photo_name"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSetOriginal close];
    
    
    [db close];
    return result;
}

/***************************************************************
 * SQL SELECT文
 * レシピ情報一覧を食材シーケンス順に取得
 * ・食材毎にレシピを返す
 * ・レシピは重複する
 * ・食材検索画面のテーブルのセクション内のセルに利用する
 ***************************************************************/
+ (NSArray *)selectRecipeCell {
    PrintLog(@"{");
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select distinct f.food_search_no food_search_no, m.recipe_no, r.recipe_name, r.time, r.calorie, r.carb_qty, r.thumbnail_photo_no from food f, main_ingredient m, recipe_base r where f.food_name = m.main_ingredient_name and r.recipe_no = m.recipe_no and not f.category='' and r.recipe_no > %d order by r.download_date desc", kRecipeCount];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];

    // 購入したレシピを読み込む
    FMResultSet* resultSetPurchase = nil;
    resultSetPurchase = [db executeQuery:sql];
    
    while ([resultSetPurchase next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setSearchNo:[resultSetPurchase intForColumn:@"food_search_no"]];
        [recipeCellEntity setRecipeNo:[resultSetPurchase intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSetPurchase stringForColumn:@"recipe_name"]];
        [recipeCellEntity setTime:[resultSetPurchase intForColumn:@"time"]];
        [recipeCellEntity setCalorie:[resultSetPurchase intForColumn:@"calorie"]];
        NSString *thumbnailPhotoNo = [resultSetPurchase stringForColumn:@"thumbnail_photo_no"];
        [recipeCellEntity setThumbnailPhotoNo:thumbnailPhotoNo];
        [recipeCellEntity setCarbQty:[resultSetPurchase doubleForColumn:@"carb_qty"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSetPurchase close];
    
    // オリジナルレシピを読み込む
    sql = [NSString stringWithFormat:@"select distinct f.food_search_no food_search_no, m.recipe_no, r.recipe_name, r.time, r.calorie, r.carb_qty, r.thumbnail_photo_no from food f, main_ingredient m, recipe_base r where f.food_name = m.main_ingredient_name and r.recipe_no = m.recipe_no and not f.category='' and r.recipe_no <= %d order by f.food_search_no asc", kRecipeCount];
    FMResultSet* resultSetOriginal = nil;
    resultSetOriginal = [db executeQuery:sql];
    
    while ([resultSetOriginal next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setSearchNo:[resultSetOriginal intForColumn:@"food_search_no"]];
        [recipeCellEntity setRecipeNo:[resultSetOriginal intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSetOriginal stringForColumn:@"recipe_name"]];
        [recipeCellEntity setTime:[resultSetOriginal intForColumn:@"time"]];
        [recipeCellEntity setCalorie:[resultSetOriginal intForColumn:@"calorie"]];
        NSString *thumbnailPhotoNo = [resultSetOriginal stringForColumn:@"thumbnail_photo_no"];
        [recipeCellEntity setThumbnailPhotoNo:thumbnailPhotoNo];
        [recipeCellEntity setCarbQty:[resultSetOriginal doubleForColumn:@"carb_qty"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }
    
    [resultSetOriginal close];
    
    [db close];
    PrintLog(@"}");
    
    return result;
    
}

/***************************************************************
 * SQL SELECT文
 * レシピ情報をレシピ番号から抽出する
 * ・ランキング画面のセルに利用する
 ***************************************************************/
+ (RecipeCellEntity *)selectRecipeCellWithRecipeNo:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select recipe_no, recipe_name, time, calorie, carb_qty, thumbnail_photo_no from recipe_base where recipe_no=%d", recipeNo];
    RecipeCellEntity* result = [[[RecipeCellEntity alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    if ([resultSet next]) {
        [result setRecipeNo:[resultSet intForColumn:@"recipe_no"]];
        [result setRecipeName:[resultSet stringForColumn:@"recipe_name"]];
        [result setTime:[resultSet intForColumn:@"time"]];
        [result setCalorie:[resultSet intForColumn:@"calorie"]];
        [result setThumbnailPhotoNo:[resultSet stringForColumn:@"thumbnail_photo_no"]];
        [result setCarbQty:[resultSet doubleForColumn:@"carb_qty"]];
    }
    
    [resultSet close];
    [db close];
    
    return result;
}


/***************************************************************
 * SQL SELECT文
 * レシピ情報全件を、お気に入りから抽出する
 * ・お気に入り一覧画面で利用
 ***************************************************************/
+ (NSMutableArray *)selectFavoritesData {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select recipe_no, recipe_name, time, calorie, carb_qty, thumbnail_photo_no from recipe_base where is_favorite = 1 order by favorite_date desc"];
    NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
        [recipeCellEntity setRecipeNo:[resultSet intForColumn:@"recipe_no"]];
        [recipeCellEntity setRecipeName:[resultSet stringForColumn:@"recipe_name"]];
        [recipeCellEntity setTime:[resultSet intForColumn:@"time"]];
        [recipeCellEntity setCalorie:[resultSet intForColumn:@"calorie"]];
        [recipeCellEntity setThumbnailPhotoNo:[resultSet stringForColumn:@"thumbnail_photo_no"]];
        [recipeCellEntity setCarbQty:[resultSet doubleForColumn:@"carb_qty"]];
        [result addObject:recipeCellEntity];
        [recipeCellEntity release];
    }   
    
    [resultSet close];
    [db close];
    return result;
}

/***************************************************************
 * SQL SELECT文
 * ダウンロード日付を返す
 ***************************************************************/
+ (NSDate *)selectDownloadDate:(int)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select download_date from recipe_base where recipe_no = %d", recipeNo];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return nil;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    NSString *dateString = nil;
    while ([resultSet next]) {
        dateString = [resultSet stringForColumn:@"download_date"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSDate *downloadDate = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    
    [resultSet close];
    [db close];
    return downloadDate;
}

/***************************************************************
 * SQL SELECT文
 * プロダクトが存在するがどうかを返す
 ***************************************************************/
+ (BOOL)checkProductExists:(int)productId {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select product_id from recipe_base where product_id = %d", productId];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    BOOL exists = NO;
    if ([resultSet next]) {
        exists = YES;
    }   
    
    [resultSet close];
    [db close];
    
    return exists;
}

/***************************************************************
 * SQL SELECT文
 * レシピが存在するがどうかを返す
 ***************************************************************/
+ (BOOL)checkDoesRecipeExist:(NSInteger)recipeNo {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql = [NSString stringWithFormat:@"select recipe_no from recipe_base where recipe_no = %d", recipeNo];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    FMResultSet* resultSet = nil;
    resultSet = [db executeQuery:sql];
    
    BOOL exists = NO;
    if ([resultSet next]) {
        exists = YES;
    }   
    
    [resultSet close];
    [db close];
    
    return exists;
}

/***************************************************************
 * SQL UPDATE文
 * レシピ基本テーブルに、お気に入りを更新する
 * ・個別レシピ画面で利用
 ***************************************************************/
+ (BOOL)updateFavoritesRecipeNo:(int)recipeNo value:(BOOL)isFavoriteBool date:(NSString *)currentDate {
    
    int isFavorite;
    if (isFavoriteBool) {
        isFavorite = 1;
    } else {
        isFavorite = 0;
    }
    
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    NSString* sql1 = [NSString stringWithFormat:@"update recipe_base set is_favorite = %d where recipe_no = %d", isFavorite, recipeNo];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    BOOL success1 = [db executeUpdate:sql1];
    
    NSString* sql2 = [NSString stringWithFormat:@"update recipe_base set favorite_date = %@ where recipe_no = %d", currentDate, recipeNo];
    
    BOOL success2 = [db executeUpdate:sql2];
    
    BOOL success = success1 * success2;
    
    [db close];
    return success;
}

/***************************************************************
 * SQL INSERT文
 * 新しいレシピをデータベースに入れます。
 ***************************************************************/
+ (BOOL)insertNewRecipeForRecipeEntityArray:(NSArray *)recipeArray {
    BOOL successTotal = YES;
    
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    [db executeUpdate:@"BEGIN;"];
    
    PrintLog(@"Start DB save recipe data.");
    PrintLog(@"{");
    for (RecipeEntity *recipeEntity in recipeArray) {
        NSString* sql;
        BOOL success;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release];
        
        // レシピ基本情報を追加
        sql = [NSString stringWithFormat:@"INSERT INTO recipe_base (recipe_no,recipe_name,recipe_name_furigana,time,calorie,thumbnail_photo_no,photo_no,person,carb_qty,comment_recipe,is_favorite,download_date,product_id,body_type,cost) VALUES ('%d','%@','%@','%d','%d','%@','%@','%d','%f','%@','0','%@','%d','%d','%d');",
               recipeEntity.recipeNo,
               recipeEntity.recipeName,
               recipeEntity.recipeFurigana,
               recipeEntity.time,
               recipeEntity.calorie,
               [NSString stringWithFormat:@"thumb_%@", recipeEntity.photoName],
               recipeEntity.photoName,
               recipeEntity.person,
               recipeEntity.carbQty,
               recipeEntity.commentRecipe,
               dateString,
               recipeEntity.productId,
               recipeEntity.bodyType,
               recipeEntity.cost];
        success = [db executeUpdate:sql];
        PrintLog(@"recipe_base success: %d", success);
        successTotal = successTotal & success;
        
        // 材料を追加
        for (MainIngredientEntity *mainIngredientEntity in recipeEntity.mainIngredientEntityArray) {
            sql = [NSString stringWithFormat:@"INSERT INTO main_ingredient(recipe_no,main_ingredient_name,main_ingredient_qty) VALUES ('%d','%@','%@');",
                   recipeEntity.recipeNo,
                   mainIngredientEntity.mainIngredientName,
                   mainIngredientEntity.mainIngredientQty];
            success = [db executeUpdate:sql];
            PrintLog(@"main_ingredient success: %d", success);
            successTotal = successTotal & success;
        }
        
        // 手順を追加
        sql = [NSString stringWithFormat:@"INSERT INTO process(recipe_no,process1,process2,process3,process4,process5,process6,process7,process8,process9) VALUES ('%d','%@','%@','%@','%@','%@','%@','%@','%@','%@');",
               recipeEntity.recipeNo,
               [recipeEntity.processArray objectAtIndex:0],
               [recipeEntity.processArray objectAtIndex:1],
               [recipeEntity.processArray objectAtIndex:2],
               [recipeEntity.processArray objectAtIndex:3],
               [recipeEntity.processArray objectAtIndex:4],
               [recipeEntity.processArray objectAtIndex:5],
               [recipeEntity.processArray objectAtIndex:6],
               [recipeEntity.processArray objectAtIndex:7],
               [recipeEntity.processArray objectAtIndex:8]];
        success = [db executeUpdate:sql];
        PrintLog(@"process success: %d", success);
        successTotal = successTotal & success;
        
        // ソースを追加
        for (SauceInsertEntity *sauceInsertEntity in recipeEntity.sauceAEntityArray) {
            sql = [NSString stringWithFormat:@"INSERT INTO sauce(recipe_no,sauce_a_name,sauce_a_qty,sauce_b_name,sauce_b_qty,sauce_c_name,sauce_c_qty) VALUES ('%d','%@','%@','%@','%@','%@','%@');",
                   recipeEntity.recipeNo,
                   sauceInsertEntity.sauceAName,
                   sauceInsertEntity.sauceAQty,
                   sauceInsertEntity.sauceBName,
                   sauceInsertEntity.sauceBQty,
                   sauceInsertEntity.sauceCName,
                   sauceInsertEntity.sauceCQty];
            success = [db executeUpdate:sql];
            PrintLog(@"sauce success: %d", success);
            successTotal = successTotal & success;
        }
        
        // 関連レシピ番号を追加
        for (NSNumber *relationalRecipeNo in recipeEntity.relationalRecipeCellEntityArray) {
            sql = [NSString stringWithFormat:@"INSERT INTO relation_recipe(recipe_no,relation_recipe_no) VALUES ('%d','%@');", recipeEntity.recipeNo, relationalRecipeNo];
            success = [db executeUpdate:sql];
            PrintLog(@"relation_recipe success: %d", success);
            successTotal = successTotal & success;
        }
        
        // 最大food_search_noを取得
        FMResultSet* resultSet = nil;
        resultSet = [db executeQuery:@"select max(food_search_no) as \"food_search_no\" from food"];
        
        NSInteger newFoodSearchValue = 0;
        while ([resultSet next]) {
            newFoodSearchValue = [resultSet intForColumn:@"food_search_no"] + 1;
        }
        
        [resultSet close];
        
        // 食材を追加
        for (FoodInsertEntity *foodInsertEntity in recipeEntity.foodInsertArray) {
            // 食材が存在するかチェック
            sql = [NSString stringWithFormat:@"select food_name from food where food_name = '%@'", foodInsertEntity.foodName];

            FMResultSet* resultSet = nil;
            resultSet = [db executeQuery:sql];
            
            BOOL exists = NO;
            while ([resultSet next]) {
                exists = YES;
            }
            if (!exists) {
                sql = [NSString stringWithFormat:@"INSERT INTO food(food_search_no,food_name,food_name_furigana,category,first_letter) VALUES ('%d','%@','%@','%@','%@');",
                       newFoodSearchValue,
                       foodInsertEntity.foodName,
                       foodInsertEntity.foodNameFurigana,
                       foodInsertEntity.category,
                       foodInsertEntity.firstLetter];
                success = [db executeUpdate:sql];
                PrintLog(@"food success: %d", success);
                successTotal = successTotal & success;
                newFoodSearchValue++;
            }
            
            [resultSet close];
        }
    }
    
    PrintLog(@"}");
    PrintLog(@"End DB save recipe data.");
    
    if (!successTotal) {
        [db rollback];
    } else {
        [db commit];
    }

    [db close];

    return successTotal;
}

/***************************************************************
 * SQL UPDATE文
 * レシピ基本テーブルに、DownloadDateコラムを追加する
 ***************************************************************/
+ (BOOL)insertDownloadDateColumn {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE recipe_base ADD COLUMN download_date TEXT;"];
    BOOL success = [db executeUpdate:sql];
    
    [db close];
    
    return success;
}

/***************************************************************
 * SQL UPDATE文
 * レシピ基本テーブルに、ProductIdコラムを追加する
 ***************************************************************/
+ (BOOL)insertProductIdColumn {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE recipe_base ADD COLUMN product_id INTEGER;"];
    BOOL success = [db executeUpdate:sql];
    
    [db close];
    
    return success;
}

/***************************************************************
 * SQL UPDATE文
 * レシピ基本テーブルに、costコラムを追加する
 ***************************************************************/
+ (BOOL)insertCostColumn {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE recipe_base ADD COLUMN cost INTEGER;"];
    BOOL success = [db executeUpdate:sql];
    
    [db close];
    
    return success;
}

/***************************************************************
 * SQL UPDATE文
 * CostコラムにCostデータを追加する
 ***************************************************************/
+ (BOOL)addCostData {
    int costArray[kRecipeCount] = {
        450,200,348,450,450,300,230,45,80,520,
        410,170,680,650,230,480,350,550,260,250,
        450,420,770,330,490,310,280,230,180,530,
        110,60,280,170,170,160,110,120,230,90,
        110,290,100,170,330,320,150,170,590,230,
        150,320,340,190,190};
    
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    BOOL success = YES;
    for (int i = 1; i <= kRecipeCount; i++) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE recipe_base SET cost = '%d' WHERE recipe_no = '%d';", costArray[i-1], i];
        success = success & [db executeUpdate:sql];
    }
    
    [db close];
    
    return success;
}

/***************************************************************
 * SQL UPDATE文
 * 食材一覧テーブルに、FoodNameFuriganaコラムを追加する
 ***************************************************************/
+ (BOOL)insertFoodNameFuriganaColumn {
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE food ADD COLUMN food_name_furigana TEXT;"];
    BOOL success = [db executeUpdate:sql];
    
    [db close];
    
    return success;
}

/***************************************************************
 * SQL UPDATE文
 * 食材一覧テーブルに、FoodNameFuriganaコラムを追加する
 ***************************************************************/
+ (BOOL)addCategoryFoodRows {
    NSArray *sqlArray = [NSArray arrayWithObjects:
                         @"あさり", @"あじ", @"あすぱらがす", @"あぼかど", @"いんげん", @"えしゃろっと", @"えのきだけ", @"おおば　", @"えび", @"えりんぎ",
                         @"かつお", @"かに", @"かぶ", @"かりふらわー", @"かんこくのり", @"きくらげ", @"きっか", @"きぬさや", @"きゃべつ", @"きゅうり",
                         @"ぎゅうにく", @"くうしんさい", @"きんしんさい", @"くこのみ", @"ぐりーんぴーず", @"くるみ", @"ごーや", @"こまつな", @"さけ", @"さば",
                         @"さやえんどう", @"しいたけ", @"ししとう", @"しめじ", @"しゃんつぁい", @"しゅんぎく", @"しょうが", @"しろきくらげ", @"しろみざかな", @"すずき",
                         @"ずっきーに", @"すぷらうと", @"すもーくさーもん", @"たい", @"だいこん", @"たまご", @"たまねぎ", @"ちーず", @"ちんげんさい", @"ちんぴ",
                         @"とうがん", @"とうふ", @"とまと", @"とりにく", @"ながいも", @"ながねぎ", @"なす", @"なまりぶし", @"にら", @"にんじん",
                         @"にんいく", @"にんにくのめ", @"はくさい", @"ぱせり", @"ぱぷりか", @"はむ", @"ばんのうねぎ", @"ぴーまん", @"ぶろっこりー", @"ぶたにく",
                         @"べーこん", @"ほうれんそう", @"ほたて", @"まいたけ", @"まっしゅるーむ", @"めかぶ", @"みずな", @"みつば", @"みにとまと", @"ゆずかわ",
                         @"らっかせい", @"らっきょう", @"れもん", @"ろーずまりー", nil];
    
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    BOOL success = YES;
    for (int i = 1; i <= 84; i++) {
        success = success & [db executeUpdate:[NSString stringWithFormat:@"UPDATE food SET food_name_furigana = '%@' WHERE food_search_no = '%d';", [sqlArray objectAtIndex:i-1], i]];
    }
    
    [db close];
    
    return success;
}

/***************************************************************
 * SQL UPDATE文
 * 食材一覧テーブルに、FoodNameFuriganaコラムを追加する
 ***************************************************************/
+ (BOOL)updateFoodMushroomRows {
    NSArray *sqlArray = [NSArray arrayWithObjects:
                         @"update food set category = '野菜、果物' where food_name = 'エリンギ';",
                         @"update food set category = '野菜、果物' where food_name = '菊花';",
                         @"update food set category = '野菜、果物' where food_name = 'しいたけ';",
                         @"update food set category = '野菜、果物' where food_name = 'しめじ';",
                         @"update food set category = '野菜、果物' where food_name = 'えのきだけ';",
                         @"update food set category = '野菜、果物' where food_name = '舞茸';",
                         @"update food set category = '野菜、果物' where food_name = 'マッシュルーム';",
                         nil];
    
    NSString* dbPath = [DatabaseUtility getDatabaseFilePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if(![db open]) {
        return NO;
    }
    [db setShouldCacheStatements:YES];
    
    BOOL success = YES;
    for (int i = 0; i < [sqlArray count]; i++) {
        success = success & [db executeUpdate:[sqlArray objectAtIndex:i]];
    }
    
    [db close];
    
    return success;
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [super dealloc];
}

@end
