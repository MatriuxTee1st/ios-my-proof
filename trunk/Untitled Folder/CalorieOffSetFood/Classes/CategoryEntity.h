//
//  CategoryEntity.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/25.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryEntity : NSObject {
    int categoryNo;
    NSString *categoryName;
}
@property(nonatomic) int categoryNo;
@property(nonatomic, retain) NSString *categoryName;

@end
