//
//  RecipeTableEntity.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/21/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeTableEntity : NSObject {
    NSString *appStoreProductId;
    int productId;
    NSString *productName;
    NSString *productLeadCell;
    NSString *productLeadDetail;
    int price;
    NSMutableArray *recipeNoArray;
    NSMutableArray *recipeSizeArray;
    UIImage *productImage;
    NSInteger previewCount;
}

@property(nonatomic, retain) NSString *appStoreProductId;
@property(nonatomic) int productId;
@property(nonatomic, retain) NSString *productName;
@property(nonatomic, retain) NSString *productLeadCell;
@property(nonatomic, retain) NSString *productLeadDetail;
@property(nonatomic) int price;
@property(nonatomic, retain) NSMutableArray *recipeNoArray;
@property(nonatomic, retain) NSMutableArray *recipeSizeArray;
@property(nonatomic, retain) UIImage *productImage;
@property(nonatomic) NSInteger previewCount;

@end
