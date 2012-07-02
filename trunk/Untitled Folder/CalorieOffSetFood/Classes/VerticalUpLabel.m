//
//  VerticalUpLabel.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/17.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "VerticalUpLabel.h"


@implementation VerticalUpLabel

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/***************************************************************
 * 上詰め
 ***************************************************************/
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}

/***************************************************************
 * テキスト描画
 ***************************************************************/
- (void)drawTextInRect:(CGRect)rect {
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [super dealloc];
}


@end
