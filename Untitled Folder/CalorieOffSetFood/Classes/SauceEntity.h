//
//  SauceEntity.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/18.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SauceEntity : NSObject {
    NSString *sauceName;
    NSString *sauceQty;
}

@property(nonatomic, retain) NSString *sauceName;
@property(nonatomic, retain) NSString *sauceQty;

@end
