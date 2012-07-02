//
//  MedicinalCarbOffDictionaryDetailViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MedicinalCarbOffDictionaryDetailViewController.h"

static NSInteger titleViewHeight = 50.f;
static NSInteger inset = 20.f;
static NSInteger titleFontSize = 16.f;
static NSInteger mainFontSize = 14.f;
static CGFloat dotLineOffset = 12.f;

@implementation MedicinalCarbOffDictionaryDetailViewController

@synthesize medicinalCarbOffDictionaryArray;
@synthesize currentRow;
@synthesize currentSection;


/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    [self navigationBarSetting];
    
    maxSection = [medicinalCarbOffDictionaryArray count] -1;
    maxRow = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] count] - 1;
    
    // Initialize background view for transition animations.
    backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)];
    
    // Initialize scroll view.
    scrollView_ = [self setScrollViewContents];
    [backgroundView_ addSubview:scrollView_];
    
    // Initialize title view.
    titleView_ = [self setTitleViewContents];
    [backgroundView_ addSubview:titleView_];
    
    [self.view addSubview:backgroundView_];
    [backgroundView_ release];
    
    CGFloat buttonWidth = 44.f;
    
    // Set next button properties.
    nextCookingTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextCookingTipButton setExclusiveTouch:YES];
    [nextCookingTipButton setFrame:CGRectMake(kDisplayWidth - buttonWidth, 0, buttonWidth, kNavigationBarHeight)];
    [nextCookingTipButton setImage:[UIImage imageNamed:kIconRightArrowImageName] forState:UIControlStateNormal];
    [nextCookingTipButton addTarget:self
                             action:@selector(nextCookingTip)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextCookingTipButton];
    
    // Set previous button properties.
    previousCookingTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousCookingTipButton setExclusiveTouch:YES];
    [previousCookingTipButton setFrame:CGRectMake(kDisplayWidth - 2 * buttonWidth, 0, buttonWidth, kNavigationBarHeight)];
    [previousCookingTipButton setImage:[UIImage imageNamed:kIconLeftArrowImageName] forState:UIControlStateNormal];
    [previousCookingTipButton addTarget:self
                                 action:@selector(previousCookingTip)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousCookingTipButton];
    
    // Disable left button if first ingredient in the list.
    if (currentRow == 0 && currentSection == 0) {
        [previousCookingTipButton setEnabled:NO];
    }
    
    // Disable right button if first ingredient in the list.
    if (currentRow == maxRow && currentSection == maxSection) {
        [nextCookingTipButton setEnabled:NO];
    }
}


/***************************************************************
 * ナビゲーションバーの設定
 ***************************************************************/
- (void)navigationBarSetting {
    // ナビゲーションバーの設定
    UIImage *navigationBarImage = [UIImage imageNamed:kNavigationBarImageName];
    UIImageView *navigationBarImageView = [[UIImageView alloc] initWithImage:navigationBarImage];
    navigationBarImageView.frame = kNavigationBarFrame;
    [self.view addSubview:navigationBarImageView];
    [navigationBarImageView release];

    NSDictionary *dictionary = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:[dictionary objectForKey:@"TITLE"]];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];

    // ナビゲーションバーの戻るボタンの設定
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:kBackButtonImageName] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(kNavigationBarLeftButtonOriginX,
                                    kNavigationBarButtonOriginY,
                                    backButton.imageView.image.size.width + kButtonTouchBuffer,
                                    backButton.imageView.image.size.height)];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}  

/***************************************************************
 * 戻るボタン押下
 ***************************************************************/
- (void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************
 * スクロールビューの設定
 ***************************************************************/
- (UIScrollView *)setScrollViewContents {
    NSDictionary *dictionary = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    CGSize descriptionLabelSize = [[dictionary objectForKey:@"CONTENTS"] sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                                                                    constrainedToSize:CGSizeMake(kDisplayWidth - 2 * inset, 3000.f)
                                                                        lineBreakMode:UILineBreakModeCharacterWrap];
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, titleViewHeight, kDisplayWidth, 368.f - titleViewHeight - dotLineOffset)] autorelease];
    [scrollView setContentSize:CGSizeMake(descriptionLabelSize.width, descriptionLabelSize.height + dotLineOffset)];
    
    // 説明テキストの設定
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, dotLineOffset, descriptionLabelSize.width, descriptionLabelSize.height)];
    [descriptionLabel setFont:[UIFont systemFontOfSize:mainFontSize]];
    [descriptionLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setText:[dictionary objectForKey:@"CONTENTS"]];
    [scrollView addSubview:descriptionLabel];
    [descriptionLabel release];
    
    // 水平区切り線    
    UIImageView *dotLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2 * dotLineOffset + descriptionLabelSize.height, kDisplayWidth, 1)];
    [dotLineImageView setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:dotLineImageView];
    [dotLineImageView release];
    
    return scrollView;
}

/***************************************************************
 * タイトルビューの設定
 ***************************************************************/
- (UIView *)setTitleViewContents {
    NSDictionary *dictionary = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    CGSize titleLabelSize = [[dictionary objectForKey:@"TITLE"] sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                                                              constrainedToSize:CGSizeMake(3000.f, 31.f)
                                                                  lineBreakMode:UILineBreakModeTailTruncation];
    
    // Initialize title view as header in dictionary.
    UIView *titleView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, titleViewHeight)] autorelease];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
    // Set title label.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 0.f, titleLabelSize.width, titleViewHeight)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [titleLabel setText:[dictionary objectForKey:@"TITLE"]];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleView addSubview:titleLabel];
    [titleLabel release];
    
    // Set ruby label.
    UILabel *rubyLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset + titleLabelSize.width,
                                                                   0.f,
                                                                   titleView.frame.size.width - (1.5 * inset + titleLabelSize.width),
                                                                   titleViewHeight)];
    [rubyLabel setFont:[UIFont systemFontOfSize:titleFontSize]];
    [rubyLabel setText:[dictionary objectForKey:@"RUBY"]];
    [rubyLabel setTextColor:[UIColor redColor]];
    [titleView addSubview:rubyLabel];
    [rubyLabel release];
    
    // 水平区切り線    
    UIImageView *dotLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleViewHeight - 1.f, kDisplayWidth, 1)];
    [dotLineImageView setImage:[UIImage imageNamed:kLineDotImageName]];
    [titleView addSubview:dotLineImageView];
    [dotLineImageView release];
    
    return titleView;
}

#pragma mark - Private Methods

/***************************************************************
 * 前の食材に進む
 ***************************************************************/
- (void)previousCookingTip {
    // If the current tip is not the first tip in the list, go to previous with animation.
    if (!(currentRow == 0 && currentSection == 0)) {
        // Update current row and section accordingly.
        if (currentRow == 0) {
            currentSection--;
            maxRow = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] count] - 1;
            currentRow = maxRow;
        } else {
            currentRow--;
        }
        
        // Set navigation bar title
        NSDictionary *dictionary = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
        [navigationBarTitleLabel setText:[dictionary objectForKey:@"TITLE"]];
        
        // Reload view data
        [scrollView_ removeFromSuperview];
        scrollView_ = [self setScrollViewContents];
        [backgroundView_ addSubview:scrollView_];
        
        [titleView_ removeFromSuperview];
        titleView_ = [self setTitleViewContents];
        [backgroundView_ addSubview:titleView_];
        
        // Perform animation
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromLeft];
        [transition setTimingFunction:UIViewAnimationCurveEaseInOut];
        [transition setDuration:0.3];
        
        [[backgroundView_ layer] addAnimation:transition forKey:@"newScrollView"];
    }
    
    // Disable left button if first ingredient in the list.
    if (currentRow == 0 && currentSection == 0) {
        [previousCookingTipButton setEnabled:NO];
    } else {
        [previousCookingTipButton setEnabled:YES];
    }
    
    // Disable right button if first ingredient in the list.
    if (currentRow == maxRow && currentSection == maxSection) {
        [nextCookingTipButton setEnabled:NO];
    } else {
        [nextCookingTipButton setEnabled:YES];
    }
}

/***************************************************************
 * 次の食材に進む
 ***************************************************************/
- (void)nextCookingTip {
    // If the current tip is not the last tip in the list, go to next with animation.
    if (!(currentRow == maxRow && currentSection == maxSection)) {
        // Update current row and section accordingly.
        if (currentRow == maxRow) {
            currentRow = 0;
            currentSection++;
            maxRow = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] count] - 1;
        } else {
            currentRow++;
        }
        
        // Set navigation bar title
        NSDictionary *dictionary = [[[medicinalCarbOffDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
        [navigationBarTitleLabel setText:[dictionary objectForKey:@"TITLE"]];
        
        // Reload view data
        [scrollView_ removeFromSuperview];
        scrollView_ = [self setScrollViewContents];
        [backgroundView_ addSubview:scrollView_];
        
        [titleView_ removeFromSuperview];
        titleView_ = [self setTitleViewContents];
        [backgroundView_ addSubview:titleView_];
        
        // Perform animation
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromRight];
        [transition setTimingFunction:UIViewAnimationCurveEaseInOut];
        [transition setDuration:0.3];
        
        [[backgroundView_ layer] addAnimation:transition forKey:@"newScrollView"];
    }
    
    // Disable left button if first ingredient in the list.
    if (currentRow == 0 && currentSection == 0) {
        [previousCookingTipButton setEnabled:NO];
    } else {
        [previousCookingTipButton setEnabled:YES];
    }
    
    // Disable right button if first ingredient in the list.
    if (currentRow == maxRow && currentSection == maxSection) {
        [nextCookingTipButton setEnabled:NO];
    } else {
        [nextCookingTipButton setEnabled:YES];
    }
}

#pragma mark -
#pragma mark Memory management

/***************************************************************
 * メモリ警告時
 ***************************************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

/***************************************************************
 * メモリ警告後
 ***************************************************************/
- (void)viewDidUnload {
    [super viewDidUnload];
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [medicinalCarbOffDictionaryArray release], medicinalCarbOffDictionaryArray = nil;
    [navigationBarTitleLabel release];
    [super dealloc];
}

@end
