//
//  DiagnosisResultViewController.m
//  MedicinalCarbOff
//
//  体質タイプのプロパティを１つ受け取り、
//  体質タイプを１つに関する情報を表示する
//
//  Created by 近藤 雅人 on 11/10/11.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "DiagnosisResultViewController.h"
#import "BodyTypeSearchTableViewController.h"

static CGFloat mainFontSize = 14.f;
static CGFloat titleFontSize = 16.f;
static CGFloat textWidth = 285;
static CGFloat inset = 22;
static CGFloat dotLineOffset = 12;

@interface DiagnosisResultViewController ()

- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forKey:(NSString *)key;
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forName:(NSString *)name;
- (UIImageView *)dotLineImageViewWithY:(CGFloat *)y;
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key width:(CGFloat)imageWidth height:(CGFloat)imageHeight;
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key;

@end

@implementation DiagnosisResultViewController
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithType:(NSInteger)type_ {
    self = [super init];
    if (self) {
        
        type = type_;
        resultDictionary = [[[Utility getConstitutionDiagnosisResultDictionary] objectAtIndex:type_] retain];
        
    }
    return self;
}

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    PrintLog(@"{");
    
    self.view = [[[UIView alloc] init] autorelease];
    
    [self setTitle:@"診断結果"];
    [self navigationBarSetting];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, kDisplayMinHeight)];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollView];
    [scrollView release];

    CGFloat y = inset;
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE"];
    [title1Label setTextColor:kColorRedTitle];
    [scrollView addSubview:title1Label];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [scrollView addSubview:dotLineImageView1];
    
    UILabel *header1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER1"];
    [header1Label setTextColor:kColorGrayText];
    [scrollView addSubview:header1Label];
    
    y += 6;
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [scrollView addSubview:text1Label];
    
    y += 6;
    
    UILabel *dot1Label = [[UILabel alloc] initWithFrame:CGRectMake(inset - 5, y, 20, 20)];
    [dot1Label setText:@"・"];
    [dot1Label setTextColor:kColorGrayText];
    [scrollView addSubview:dot1Label];
    [dot1Label release];
    
    UILabel *point1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"POINT1"];
    [point1Label setCenter:CGPointMake(point1Label.center.x + 10, point1Label.center.y)];
    [scrollView addSubview:point1Label];
    
    UILabel *dot2Label = [[UILabel alloc] initWithFrame:CGRectMake(inset - 5, y, 20, 20)];
    [dot2Label setText:@"・"];
    [dot2Label setTextColor:kColorGrayText];
    [scrollView addSubview:dot2Label];
    [dot2Label release];
    
    UILabel *point2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"POINT2"];
    [point2Label setCenter:CGPointMake(point2Label.center.x + 10, point2Label.center.y)];
    [scrollView addSubview:point2Label];
    
    UILabel *dot3Label = [[UILabel alloc] initWithFrame:CGRectMake(inset - 5, y, 20, 20)];
    [dot3Label setText:@"・"];
    [dot3Label setTextColor:kColorGrayText];
    [scrollView addSubview:dot3Label];
    [dot3Label release];
    
    UILabel *point3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"POINT3"];
    [point3Label setCenter:CGPointMake(point3Label.center.x + 10, point3Label.center.y)];
    [scrollView addSubview:point3Label];
    
    y += 6;
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [scrollView addSubview:text2Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [scrollView addSubview:dotLineImageView2];
    
    UILabel *header2Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER2"];
    [header2Label setTextColor:kColorGrayText];
    [scrollView addSubview:header2Label];
    
    y += 6;
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [scrollView addSubview:text3Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [scrollView addSubview:dotLineImageView3];
    
    UILabel *header3Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER3"];
    [header3Label setTextColor:kColorGrayText];
    [scrollView addSubview:header3Label];
    
    y += 6;
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [scrollView addSubview:text4Label];
    
    UIImageView *dotLineImageView4 = [self dotLineImageViewWithY:&y];
    [scrollView addSubview:dotLineImageView4];
    
    
    NSString *typeString;
    if (type == kBodyTypeA) {
        typeString = [NSString stringWithFormat:kBodyTypeKachiButtonImageName];
    } else if (type == kBodyTypeB) {
        typeString = [NSString stringWithFormat:kBodyTypePuyoButtonImageName];
    } else {
        // Never Enter This Case
        PrintLog(@"Should not enter this case!");
        typeString = [NSString stringWithFormat:@""];
    }
    
    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeButton setFrame:CGRectMake(20, y, 280, 70)];
    [typeButton setImage:[UIImage imageNamed:typeString] forState:UIControlStateNormal];
    [typeButton setTag:type];
    [typeButton addTarget:self action:@selector(typeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:typeButton];

    y += dotLineOffset + 70;
    
    [scrollView setContentSize:CGSizeMake(kDisplayWidth, y)];

    PrintLog(@"}");
}


/***************************************************************
 * 体質別検索に遷移
 ***************************************************************/
- (void)typeButtonPressed:(UIButton *)button {
    BodyTypeSearchTableViewController *bodyTypeSearchTableViewController = [[BodyTypeSearchTableViewController alloc] initWithType:type];
    [self.navigationController pushViewController:bodyTypeSearchTableViewController animated:YES];
    [bodyTypeSearchTableViewController release];
}

/***************************************************************
 * keyでラベルを返す
 ***************************************************************/
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forKey:(NSString *)key {
    CGSize size = [[NSString stringWithFormat:@"%@", [resultDictionary objectForKey:key]]
                   sizeWithFont:font
                   constrainedToSize:CGSizeMake(textWidth, 4000.f)
                   lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(inset, *y, size.width, size.height)] autorelease];
    [label setText:[NSString stringWithFormat:@"%@", [resultDictionary objectForKey:key]]];
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
    UIImage *image = [UIImage imageNamed:[resultDictionary objectForKey:key]];
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
    UIImage *image = [UIImage imageNamed:[resultDictionary objectForKey:key]];
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
    [navigationBarTitleLabel setText:kNavigationBarTitleShindankekkaName];
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
    [resultDictionary release];
    [super dealloc];
    
}


@end
