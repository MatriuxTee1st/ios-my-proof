//
//  MixiView.h
//  Masuda
//
//  Created by ShinjiYamamoto on 11/06/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// mixi
#import "Mixi.h"

@interface MixiView : UIView <UITextViewDelegate> {
    
    id delegate;
    NSString *defaultWord;
    UITextView *inputView;
    UIBarButtonItem *cancelBtn;
    UIActivityIndicatorView *indicator;
    
    int inputMaxLength;

    Mixi *mixi;
}


- (id)initWithFrame:(CGRect)frame defaultWord:(NSString *)_defaultWord delegate:(id)_delegate;
- (void) mixiPostsVoice;

@end
