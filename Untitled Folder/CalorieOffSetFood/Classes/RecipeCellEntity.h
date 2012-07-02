//
//  RecipeCellEntity.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/14.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RecipeCellEntity : NSObject {
    int searchNo;
    int recipeNo;
    NSString *recipeName;
    int cookingTime;
    int calorie;
    NSDate *downloadDate;
    NSString *thumbnailPhotoName;
    int productId;
    float carbQty;
    int bodyType;
    int cost;
}

@property(nonatomic, readwrite) int searchNo;
@property(nonatomic, readwrite) int recipeNo;
@property(nonatomic, readwrite, retain) NSString *recipeName;
@property(nonatomic, readwrite) int cookingTime;
@property(nonatomic, readwrite) int calorie;
@property(nonatomic, readwrite, retain) NSString *thumbnailPhotoName;
@property(nonatomic, readwrite) int productId;
@property(nonatomic, readwrite, retain) NSDate *downloadDate;
@property(nonatomic, readwrite) float carbQty;
@property(nonatomic) int bodyType;
@property(nonatomic) int cost;

@end
