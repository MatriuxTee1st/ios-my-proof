//
//  RankingRequestEntity.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/26.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingRequestEntity : NSObject<NSCoding> {
    NSInteger recipeNo;
    NSString *viewDate;
}

@property(nonatomic) NSInteger recipeNo;
@property(nonatomic, retain) NSString *viewDate;

@end
