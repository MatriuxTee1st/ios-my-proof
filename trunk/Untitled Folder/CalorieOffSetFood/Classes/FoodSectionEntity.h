//
//  FoodSectionEntity.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/14.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FoodSectionEntity : NSObject {
    int foodSearchNo;
    NSString *foodName;
    NSString *category;
    NSMutableArray *recipeCellArray;
    NSString *firstLetter;
}
@property(nonatomic) int foodSearchNo;
@property(nonatomic, retain) NSString *foodName;
@property(nonatomic, retain) NSString *category;
@property(nonatomic, retain) NSMutableArray *recipeCellArray;
@property(nonatomic, retain) NSString *firstLetter;

@end
