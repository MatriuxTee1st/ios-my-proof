//
//  FoodModel.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/14.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FoodModel : NSObject {
    int foodSearchNo;
    NSString *foodName;
    NSString *category;
    NSString *firstLetter;
}
@property(nonatomic, readwrite) int foodSearchNo;
@property(nonatomic, readwrite, retain) NSString *foodName;
@property(nonatomic, readwrite, retain) NSString *category;
@property(nonatomic, readwrite, retain) NSString *firstLetter;

@end
