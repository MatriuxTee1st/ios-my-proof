//
//  EditorIntroductionViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditorIntroductionViewController.h"

#import "Utility.h"

static CGFloat inset = 22.f;
static CGFloat textWidth = 285.f;
static CGFloat mainFontSize = 14.f;
static CGFloat titleFontSize = 16.f;
static CGFloat singleLineHeight = 19.f;
static CGFloat dotLineOffset = 12.f;

@interface EditorIntroductionViewController ()

- (UIScrollView *)setupEditorScrollView;
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forKey:(NSString *)key;
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forName:(NSString *)name;
- (UIImageView *)dotLineImageViewWithY:(CGFloat *)y;
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key width:(CGFloat)imageWidth height:(CGFloat)imageHeight;
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key;

@end

@implementation EditorIntroductionViewController

/***************************************************************
 * ビュー読み込み時
 ***************************************************************/
- (void)loadView {
    [super loadView];
    PrintLog(@"[loadView] {");
    
    [self navigationBarSetting];
    
    editorDictionary = [Utility getEditorDictionary];
    
    UIScrollView *editorScrollView = [self setupEditorScrollView];
    [self.view addSubview: editorScrollView];
    
    PrintLog(@"[loadView] }");
}

/***************************************************************
 * スクロールビューの設定
 ***************************************************************/
- (UIScrollView *)setupEditorScrollView {
    
    // Setup ScrollView
    UIScrollView *editorScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    // Setup leadlabel and add to scrollView.
    UILabel *leadLabel = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"LEAD"];
    [editorScrollView addSubview:leadLabel];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [editorScrollView addSubview:dotLineImageView1];
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE1"];
    [title1Label setTextColor:kColorRedTitle];
    [editorScrollView addSubview:title1Label];
    
    UILabel *subtitle1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"SUBTITLE1"];
    [subtitle1Label setTextColor:kColorGrayText];
    [editorScrollView addSubview:subtitle1Label];
    
    UIImageView *imageView1 = [self imageViewWithY:&y forKey:@"IMAGE1" width:57.f height:57.f];
    [editorScrollView addSubview:imageView1];
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [editorScrollView addSubview:text1Label];
    
    y += 10.f;
    
    NSArray *sectionArray = [editorDictionary objectForKey:@"SECTIONS"];
    for (NSDictionary *dict in sectionArray) {
        UILabel *braceLabel = [self textLabelWithY:&y
                                              font:[UIFont boldSystemFontOfSize:mainFontSize]
                                           forName:[dict objectForKey:@"BRACE"]];
        [editorScrollView addSubview:braceLabel];
        
        UILabel *textLabel = [self textLabelWithY:&y 
                                             font:[UIFont systemFontOfSize:mainFontSize] 
                                          forName:[dict objectForKey:@"TEXT"]];
        [editorScrollView addSubview:textLabel];
        
        y += singleLineHeight;
    }
    
    UIImageView *imageView2 = [self imageViewWithY:&y forKey:@"IMAGE2" width:100.f height:117.f];
    [editorScrollView addSubview:imageView2];
    
    y += singleLineHeight;
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [editorScrollView addSubview:text2Label];
    
    y += singleLineHeight;
    
    UILabel *brace1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"BRACE1"];
    [editorScrollView addSubview:brace1Label];
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [editorScrollView addSubview:text3Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [editorScrollView addSubview:dotLineImageView2];
    
    UILabel *title2Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE2"];
    [title2Label setTextColor:kColorRedTitle];
    [editorScrollView addSubview:title2Label];
    
    UILabel *subtitle2Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"SUBTITLE2"];
    [subtitle2Label setTextColor:kColorGrayText];
    [editorScrollView addSubview:subtitle2Label];
    
    y += dotLineOffset;
    
    UIImageView *imageView3 = [self imageViewWithY:&y forKey:@"IMAGE3" width:88.f height:76.f];
    [editorScrollView addSubview:imageView3];

    y += dotLineOffset;
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [editorScrollView addSubview:text4Label];
    
    y += singleLineHeight;
    
    UILabel *brace2Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"BRACE2"];
    [editorScrollView addSubview:brace2Label];
    
    UILabel *text5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT5"];
    [editorScrollView addSubview:text5Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [editorScrollView addSubview:dotLineImageView3];
    
    UILabel *title3Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE3"];
    [title3Label setTextColor:kColorRedTitle];
    [editorScrollView addSubview:title3Label];
    
    UILabel *subtitle3Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"SUBTITLE3"];
    [subtitle3Label setTextColor:kColorGrayText];
    [editorScrollView addSubview:subtitle3Label];
    
    y += dotLineOffset;
    
    UIImageView *imageView4 = [self imageViewWithY:&y forKey:@"IMAGE4" width:105.f height:85.f];
    [editorScrollView addSubview:imageView4];
    
    y += dotLineOffset;
    
    UILabel *text6Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT6"];
    [editorScrollView addSubview:text6Label];
    
    UIImageView *dotLineImageView4 = [self dotLineImageViewWithY:&y];
    [editorScrollView addSubview:dotLineImageView4];
    
    UILabel *title4Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE4"];
    [title4Label setTextColor:kColorRedTitle];
    [editorScrollView addSubview:title4Label];
    
    UILabel *subtitle4Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"SUBTITLE4"];
    [subtitle4Label setTextColor:kColorGrayText];
    [editorScrollView addSubview:subtitle4Label];
    
    UIImageView *dotLineImageView5 = [self dotLineImageViewWithY:&y];
    [editorScrollView addSubview:dotLineImageView5];
    
    UILabel *title5Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE5"];
    [title5Label setTextColor:kColorRedTitle];
    [editorScrollView addSubview:title5Label];
    
    UILabel *subtitle5Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"SUBTITLE5"];
    [subtitle5Label setTextColor:kColorGrayText];
    [editorScrollView addSubview:subtitle5Label];
    
    y += dotLineOffset;
    
    UIImageView *imageView5 = [self imageViewWithY:&y forKey:@"IMAGE5"];
    [imageView5 setBackgroundColor:[UIColor whiteColor]];
    [editorScrollView addSubview:imageView5];
    
    UIImageView *dotLineImageView6 = [self dotLineImageViewWithY:&y];
    [editorScrollView addSubview:dotLineImageView6];
    
    [editorScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return editorScrollView;
}

/***************************************************************
 * keyでラベルを返す
 ***************************************************************/
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forKey:(NSString *)key {
    CGSize size = [[NSString stringWithFormat:@"%@", [editorDictionary objectForKey:key]]
                   sizeWithFont:font
                   constrainedToSize:CGSizeMake(textWidth, 4000.f)
                   lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(inset, *y, size.width, size.height)] autorelease];
    [label setText:[NSString stringWithFormat:@"%@", [editorDictionary objectForKey:key]]];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeCharacterWrap];
    
    *y += size.height;

    return label;
}

/***************************************************************
 * nameでラベルを返す
 ***************************************************************/
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forName:(NSString *)name {
    CGSize size = [[NSString stringWithFormat:@"%@", name]
                   sizeWithFont:font
                   constrainedToSize:CGSizeMake(textWidth, 4000.f)
                   lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(inset, *y, size.width, size.height)] autorelease];
    [label setText:[NSString stringWithFormat:@"%@", name]];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeCharacterWrap];
    
    *y += size.height;
    
    return label;
}

/***************************************************************
 * dotLineImageViewを返す
 ***************************************************************/
- (UIImageView *)dotLineImageViewWithY:(CGFloat *)y {
    *y += dotLineOffset;
    
    // 水平区切り線    
    UIImageView *dotLineImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, *y, kDisplayWidth, 1)] autorelease];
    [dotLineImageView setImage:[UIImage imageNamed:kLineDotImageName]];
    
    *y += dotLineOffset;
    
    return dotLineImageView;
}

/***************************************************************
 * imageViewを返す
 ***************************************************************/
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key width:(CGFloat)imageWidth height:(CGFloat)imageHeight {
    UIImage *image = [UIImage imageNamed:[editorDictionary objectForKey:key]];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2,
                                                                           *y,
                                                                           imageWidth,
                                                                           imageHeight)] autorelease];
    [imageView setImage:image];
    
    *y += imageHeight;
    
    return imageView;
}

/***************************************************************
 * imageViewを返す
 ***************************************************************/
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key {
    UIImage *image = [UIImage imageNamed:[editorDictionary objectForKey:key]];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    [imageView setFrame:CGRectMake((kDisplayWidth - image.size.width) / 2,
                                   *y,
                                   image.size.width,
                                   image.size.height)];
    
    *y += image.size.height;
    
    return imageView;
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
    
    // ナビゲーションバーのタイトルの設定
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:kNavigationBarTitleKanshushaName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
    
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

@end
