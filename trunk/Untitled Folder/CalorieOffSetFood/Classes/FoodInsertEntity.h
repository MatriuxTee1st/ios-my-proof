//
//  FoodInsertEntity.h
//  MedicinalCooking
//
//  Created by Nolan Warner on 3/13/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodInsertEntity : NSObject {
    NSString *foodName;
    NSString *foodNameFurigana;
    NSString *category;
    NSString *firstLetter;
}

@property(nonatomic, retain) NSString *foodName;
@property(nonatomic, retain) NSString *foodNameFurigana;
@property(nonatomic, retain) NSString *category;
@property(nonatomic, retain) NSString *firstLetter;

@end