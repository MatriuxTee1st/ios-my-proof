//
//  AboutThisAppViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutThisAppViewController.h"
#import "Utility.h"

static CGFloat inset = 22.f;
static CGFloat textWidth = 285.f;
static CGFloat mainFontSize = 14.f;
static CGFloat titleFontSize = 16.f;
static CGFloat singleLineHeight = 19.f;
static CGFloat dotLineOffset = 12.f;

@interface AboutThisAppViewController ()

- (UIScrollView *)setupIntroductionScrollView;

@end


@implementation AboutThisAppViewController

/***************************************************************
 * ビュー読み込み時
 ***************************************************************/
- (void)loadView {
    [super loadView];
    PrintLog(@"[loadView] {");
    
    [self navigationBarSetting];
    
    UIScrollView *introScrollView = [self setupIntroductionScrollView];
    [self.view addSubview:introScrollView];
    
    PrintLog(@"[loadView] }");
}

/***************************************************************
 * スクロールビューの設定
 ***************************************************************/
- (UIScrollView *)setupIntroductionScrollView {
    NSDictionary *introDictionary = [Utility getIntroductionDictionary];
    
    // Setup ScrollView
    UIScrollView *introScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    // Setup text1label and add to scrollView.
    CGSize text1Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT1"]]
                        sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                        constrainedToSize:CGSizeMake(textWidth, 4000.f)
                        lineBreakMode:UILineBreakModeWordWrap];
    UILabel *text1Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, text1Size.width, text1Size.height)];
    [text1Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT1"]]];
    [text1Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [text1Label setNumberOfLines:0];
    [text1Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:text1Label];
    [text1Label release];
    
    y += text1Size.height + singleLineHeight;
    
    // Setup text2label and add to scrollView.
    CGSize text2Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT2"]]
                        sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                        constrainedToSize:CGSizeMake(textWidth, 4000.f)
                        lineBreakMode:UILineBreakModeWordWrap];
    UILabel *text2Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, text2Size.width, text2Size.height)];
    [text2Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT2"]]];
    [text2Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [text2Label setNumberOfLines:0];
    [text2Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:text2Label];
    [text2Label release];
    
    y += text2Size.height + singleLineHeight;
    
    // Setup text3label and add to scrollView.
    CGSize text3Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT3"]]
                        sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                        constrainedToSize:CGSizeMake(textWidth, 4000.f)
                        lineBreakMode:UILineBreakModeWordWrap];
    UILabel *text3Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, text3Size.width, text3Size.height)];
    [text3Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT3"]]];
    [text3Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [text3Label setNumberOfLines:0];
    [text3Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:text3Label];
    [text3Label release];
    
    y += text3Size.height + dotLineOffset;
    
    // 水平区切り線    
    UIImageView *dotLineImageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDisplayWidth, 1)];
    [dotLineImageView0 setImage:[UIImage imageNamed:kLineDotImageName]];
    [introScrollView addSubview:dotLineImageView0];
    [dotLineImageView0 release];
    
    y += dotLineOffset;
    
    // Setup title0label and add to scrollView.
    CGSize title0Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TITLE0"]]
                         sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                         constrainedToSize:CGSizeMake(textWidth, 4000.f)
                         lineBreakMode:UILineBreakModeWordWrap];
    UILabel *title0Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, title0Size.width, title0Size.height)];
    [title0Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TITLE0"]]];
    [title0Label setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [title0Label setNumberOfLines:0];
    [title0Label setTextColor:kColorRedTitle];
    [introScrollView addSubview:title0Label];
    [title0Label release];
    
    y += title0Size.height + dotLineOffset;
    
    // Setup header1label and add to scrollView.
    CGSize header1Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER1"]]
                         sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                         constrainedToSize:CGSizeMake(textWidth, 4000.f)
                         lineBreakMode:UILineBreakModeWordWrap];
    UILabel *header1Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, header1Size.width, header1Size.height)];
    [header1Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER1"]]];
    [header1Label setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [header1Label setNumberOfLines:0];
    [header1Label setTextColor:kColorGrayText];
    [introScrollView addSubview:header1Label];
    [header1Label release];
    
    y += header1Size.height;
    
    // Setup headerText1label and add to scrollView.
    CGSize headerText1Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT1"]]
                        sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                        constrainedToSize:CGSizeMake(textWidth, 4000.f)
                        lineBreakMode:UILineBreakModeWordWrap];
    UILabel *headerText1Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, headerText1Size.width, headerText1Size.height)];
    [headerText1Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT1"]]];
    [headerText1Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [headerText1Label setNumberOfLines:0];
    [headerText1Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:headerText1Label];
    [headerText1Label release];
    
    y += headerText1Size.height + singleLineHeight;
    
    // Setup header2label and add to scrollView.
    CGSize header2Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER2"]]
                          sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                          constrainedToSize:CGSizeMake(textWidth, 4000.f)
                          lineBreakMode:UILineBreakModeWordWrap];
    UILabel *header2Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, header2Size.width, header2Size.height)];
    [header2Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER2"]]];
    [header2Label setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [header2Label setNumberOfLines:0];
    [header2Label setTextColor:kColorGrayText];
    [introScrollView addSubview:header2Label];
    [header2Label release];
    
    y += header2Size.height;
    
    // Setup headerText2label and add to scrollView.
    CGSize headerText2Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT2"]]
                              sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                              constrainedToSize:CGSizeMake(textWidth, 4000.f)
                              lineBreakMode:UILineBreakModeWordWrap];
    UILabel *headerText2Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, headerText2Size.width, headerText2Size.height)];
    [headerText2Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT2"]]];
    [headerText2Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [headerText2Label setNumberOfLines:0];
    [headerText2Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:headerText2Label];
    [headerText2Label release];
    
    y += headerText2Size.height + singleLineHeight;
    
    // Setup header3label and add to scrollView.
    CGSize header3Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER3"]]
                          sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                          constrainedToSize:CGSizeMake(textWidth, 4000.f)
                          lineBreakMode:UILineBreakModeWordWrap];
    UILabel *header3Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, header3Size.width, header3Size.height)];
    [header3Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER3"]]];
    [header3Label setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [header3Label setNumberOfLines:0];
    [header3Label setTextColor:kColorGrayText];
    [introScrollView addSubview:header3Label];
    [header3Label release];
    
    y += header3Size.height;
    
    // Setup headerText3label and add to scrollView.
    CGSize headerText3Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT3"]]
                              sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                              constrainedToSize:CGSizeMake(textWidth, 4000.f)
                              lineBreakMode:UILineBreakModeWordWrap];
    UILabel *headerText3Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, headerText3Size.width, headerText3Size.height)];
    [headerText3Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT3"]]];
    [headerText3Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [headerText3Label setNumberOfLines:0];
    [headerText3Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:headerText3Label];
    [headerText3Label release];
    
    y += headerText3Size.height + singleLineHeight;
    
    // Setup header4label and add to scrollView.
    CGSize header4Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER4"]]
                          sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                          constrainedToSize:CGSizeMake(textWidth, 4000.f)
                          lineBreakMode:UILineBreakModeWordWrap];
    UILabel *header4Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, header4Size.width, header4Size.height)];
    [header4Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADER4"]]];
    [header4Label setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [header4Label setNumberOfLines:0];
    [header4Label setTextColor:kColorGrayText];
    [introScrollView addSubview:header4Label];
    [header4Label release];
    
    y += header4Size.height;
    
    // Setup headerText4label and add to scrollView.
    CGSize headerText4Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT4"]]
                              sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                              constrainedToSize:CGSizeMake(textWidth, 4000.f)
                              lineBreakMode:UILineBreakModeWordWrap];
    UILabel *headerText4Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, headerText4Size.width, headerText4Size.height)];
    [headerText4Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"HEADERTEXT4"]]];
    [headerText4Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [headerText4Label setNumberOfLines:0];
    [headerText4Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:headerText4Label];
    [headerText4Label release];
    
    y += headerText4Size.height + dotLineOffset;
    
    // 水平区切り線    
    UIImageView *dotLineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDisplayWidth, 1)];
    [dotLineImageView1 setImage:[UIImage imageNamed:kLineDotImageName]];
    [introScrollView addSubview:dotLineImageView1];
    [dotLineImageView1 release];
    
    y += dotLineOffset;
    
    // Setup title1label and add to scrollView.
    CGSize title1Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TITLE1"]]
                         sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                         constrainedToSize:CGSizeMake(textWidth, 4000.f)
                         lineBreakMode:UILineBreakModeWordWrap];
    UILabel *title1Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, title1Size.width, title1Size.height)];
    [title1Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TITLE1"]]];
    [title1Label setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [title1Label setNumberOfLines:0];
    [title1Label setTextColor:kColorRedTitle];
    [introScrollView addSubview:title1Label];
    [title1Label release];
    
    y += title1Size.height;
    
    // Setup text4label and add to scrollView.
    CGSize text4Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT4"]]
                        sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                        constrainedToSize:CGSizeMake(textWidth, 4000.f)
                        lineBreakMode:UILineBreakModeWordWrap];
    UILabel *text4Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, text4Size.width, text4Size.height)];
    [text4Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT4"]]];
    [text4Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [text4Label setNumberOfLines:0];
    [text4Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:text4Label];
    [text4Label release];
    
    y += text4Size.height + singleLineHeight;
    
//    // Setup text5label and add to scrollView.
//    CGSize text5Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT5"]]
//                        sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
//                        constrainedToSize:CGSizeMake(textWidth, 4000.f)
//                        lineBreakMode:UILineBreakModeWordWrap];
//    UILabel *text5Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, text5Size.width, text5Size.height)];
//    [text5Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT5"]]];
//    [text5Label setFont:[UIFont systemFontOfSize:mainFontSize]];
//    [text5Label setNumberOfLines:0];
//    [text5Label setLineBreakMode:UILineBreakModeWordWrap];
//    [introScrollView addSubview:text5Label];
//    [text5Label release];
//    
//    y += text5Size.height + dotLineOffset;
    
    // 水平区切り線    
    UIImageView *dotLineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDisplayWidth, 1)];
    [dotLineImageView2 setImage:[UIImage imageNamed:kLineDotImageName]];
    [introScrollView addSubview:dotLineImageView2];
    [dotLineImageView2 release];
    
    y += dotLineOffset;
    
    // Setup title2label and add to scrollView.
    CGSize title2Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TITLE2"]]
                         sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize]
                         constrainedToSize:CGSizeMake(textWidth, 4000.f)
                         lineBreakMode:UILineBreakModeWordWrap];
    UILabel *title2Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, title2Size.width, title2Size.height)];
    [title2Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TITLE2"]]];
    [title2Label setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [title2Label setNumberOfLines:0];
    [title2Label setTextColor:kColorRedTitle];
    [introScrollView addSubview:title2Label];
    [title2Label release];
    
    y += title2Size.height;
    
    // Setup text5label and add to scrollView.
    CGSize text5Size = [[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT5"]]
                        sizeWithFont:[UIFont systemFontOfSize:mainFontSize]
                        constrainedToSize:CGSizeMake(textWidth, 4000.f)
                        lineBreakMode:UILineBreakModeWordWrap];
    UILabel *text5Label = [[UILabel alloc] initWithFrame:CGRectMake(inset, y, text5Size.width, text5Size.height)];
    [text5Label setText:[NSString stringWithFormat:@"%@", [introDictionary objectForKey:@"TEXT5"]]];
    [text5Label setFont:[UIFont systemFontOfSize:mainFontSize]];
    [text5Label setNumberOfLines:0];
    [text5Label setLineBreakMode:UILineBreakModeWordWrap];
    [introScrollView addSubview:text5Label];
    [text5Label release];
    
    y += text5Size.height + dotLineOffset;
    
    // 水平区切り線    
    UIImageView *dotLineImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDisplayWidth, 1)];
    [dotLineImageView3 setImage:[UIImage imageNamed:kLineDotImageName]];
    [introScrollView addSubview:dotLineImageView3];
    [dotLineImageView3 release];
    
    y += dotLineOffset;
    
    [introScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return introScrollView;
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
    [navigationBarTitleLabel setText:kNavigationBarTitleAboutName];
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
