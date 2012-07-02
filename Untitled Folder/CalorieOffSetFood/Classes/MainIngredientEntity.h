//
//  MainIngredientEntity.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/18.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MainIngredientEntity : NSObject {
    NSString *mainIngredientName;
    NSString *mainIngredientQty;
}

@property(nonatomic, retain) NSString *mainIngredientName;
@property(nonatomic, retain) NSString *mainIngredientQty;
@end
