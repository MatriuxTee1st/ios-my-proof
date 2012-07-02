//
//  MedicinalCarbOffColumnDetailViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MedicinalCarbOffColumnDetailViewController.h"

static CGFloat textWidth = 285.f;
static CGFloat inset = 22.f;
static CGFloat mainFontSize = 14.f;
static CGFloat titleFontSize = 16.f;
static CGFloat singleLineHeight = 19.f;
static CGFloat dotLineOffset = 12.f;

@interface MedicinalCarbOffColumnDetailViewController ()

- (UIScrollView *)setupColumn1;
- (UIScrollView *)setupColumn2;
- (UIScrollView *)setupColumn3;
- (UIScrollView *)setupColumn4;
- (UIScrollView *)setupColumn5;
- (UIScrollView *)setupColumn6;

- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forKey:(NSString *)key;
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forName:(NSString *)name;
- (UIImageView *)dotLineImageViewWithY:(CGFloat *)y;
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key width:(CGFloat)imageWidth height:(CGFloat)imageHeight;
- (UIImageView *)imageViewWithY:(CGFloat *)y forKey:(NSString *)key;
- (UIScrollView *)addFooter:(UIScrollView *)columnScrollView;

@end

@implementation MedicinalCarbOffColumnDetailViewController

@synthesize columnDictionary;
@synthesize indexNumber;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/***************************************************************
 * メモリ警告時
 ***************************************************************/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [columnDictionary release], columnDictionary = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    [super loadView];
    
    [self navigationBarSetting];
    
    switch (indexNumber) {
        case 0: {
            UIScrollView *scrollView = [self setupColumn1];
            scrollView = [self addFooter:scrollView];
            [self.view addSubview:scrollView];
            break;
        }
        case 1: {
            UIScrollView *scrollView = [self setupColumn2];
            scrollView = [self addFooter:scrollView];
            [self.view addSubview:scrollView];
            break;
        }
        case 2: {
            UIScrollView *scrollView = [self setupColumn3];
            scrollView = [self addFooter:scrollView];
            [self.view addSubview:scrollView];
            break;
        }
        case 3: {
            UIScrollView *scrollView = [self setupColumn4];
            scrollView = [self addFooter:scrollView];
            [self.view addSubview:scrollView];
            break;
        }
        case 4: {
            UIScrollView *scrollView = [self setupColumn5];
            scrollView = [self addFooter:scrollView];
            [self.view addSubview:scrollView];
            break;
        }
        case 5: {
            UIScrollView *scrollView = [self setupColumn6];
            scrollView = [self addFooter:scrollView];
            [self.view addSubview:scrollView];
            break;
        }
        default:
            break;
    }
}

/***************************************************************
 * コラムビューの設定
 ***************************************************************/
- (UIScrollView *)setupColumn1 {
    
    // Setup ScrollView
    UIScrollView *columnScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE"];
    [title1Label setTextColor:kColorRedTitle];
    [columnScrollView addSubview:title1Label];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView1];
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [columnScrollView addSubview:text1Label];
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [columnScrollView addSubview:text2Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView2];
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [columnScrollView addSubview:text3Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView3];
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [columnScrollView addSubview:text4Label];
    
    UIImageView *dotLineImageView4 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView4];
    
    UILabel *text5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT5"];
    [columnScrollView addSubview:text5Label];
    
    [columnScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return columnScrollView;
}

/***************************************************************
 * コラムビューの設定
 ***************************************************************/
- (UIScrollView *)setupColumn2 {
    
    // Setup ScrollView
    UIScrollView *columnScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE"];
    [title1Label setTextColor:kColorRedTitle];
    [columnScrollView addSubview:title1Label];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView1];
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [columnScrollView addSubview:text1Label];
    
    y += singleLineHeight;
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [columnScrollView addSubview:text2Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView2];
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [columnScrollView addSubview:text3Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView3];
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [columnScrollView addSubview:text4Label];
    
    UIImageView *dotLineImageView4 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView4];
    
    UILabel *text5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT5"];
    [columnScrollView addSubview:text5Label];
    
    UIImageView *dotLineImageView5 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView5];
    
    UILabel *text6Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT6"];
    [columnScrollView addSubview:text6Label];
    
    [columnScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return columnScrollView;
}

/***************************************************************
 * コラムビューの設定
 ***************************************************************/
- (UIScrollView *)setupColumn3 {
    
    // Setup ScrollView
    UIScrollView *columnScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE"];
    [title1Label setTextColor:kColorRedTitle];
    [columnScrollView addSubview:title1Label];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView1];
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [columnScrollView addSubview:text1Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView2];
    
    UILabel *header1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER1"];
    [header1Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header1Label];
    
    y += 6;
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [columnScrollView addSubview:text2Label];
    
    y += 6;
    
    for (NSString *string in [columnDictionary objectForKey:@"POINTS1"]) {
        UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset - 5, y, 20, 20)];
        [dotLabel setText:@"・"];
        [dotLabel setTextColor:kColorGrayText];
        [columnScrollView addSubview:dotLabel];
        [dotLabel release];
        
        UILabel *pointLabel = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forName:string];
        [pointLabel setCenter:CGPointMake(pointLabel.center.x + 10, pointLabel.center.y)];
        [columnScrollView addSubview:pointLabel];
    }
    
    y += 6;
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [columnScrollView addSubview:text3Label];
    
    y += singleLineHeight;
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [columnScrollView addSubview:text4Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView3];
    
    UILabel *header2Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER2"];
    [header2Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header2Label];
    
    y += 6;
    
    UILabel *text5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT5"];
    [columnScrollView addSubview:text5Label];
    
    y += 6;
    
    for (NSString *string in [columnDictionary objectForKey:@"POINTS2"]) {
        UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset - 5, y, 20, 20)];
        [dotLabel setText:@"・"];
        [dotLabel setTextColor:kColorGrayText];
        [columnScrollView addSubview:dotLabel];
        [dotLabel release];
        
        UILabel *pointLabel = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forName:string];
        [pointLabel setCenter:CGPointMake(pointLabel.center.x + 10, pointLabel.center.y)];
        [columnScrollView addSubview:pointLabel];
    }
    
    y += 6;
    
    UILabel *text6Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT6"];
    [columnScrollView addSubview:text6Label];
    
    y += singleLineHeight;
    
    UILabel *text7Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT7"];
    [columnScrollView addSubview:text7Label];
    
    y += singleLineHeight;
    
    UILabel *text8Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT8"];
    [columnScrollView addSubview:text8Label];
    
    [columnScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return columnScrollView;
}

/***************************************************************
 * コラムビューの設定
 ***************************************************************/
- (UIScrollView *)setupColumn4 {
    
    // Setup ScrollView
    UIScrollView *columnScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE"];
    [title1Label setTextColor:kColorRedTitle];
    [columnScrollView addSubview:title1Label];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView1];
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [columnScrollView addSubview:text1Label];
    
    y += 6;
        
    UILabel *header1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER1"];
    [header1Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header1Label];

    UILabel *header2Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER2"];
    [header2Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header2Label];
    
    y += 6;
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [columnScrollView addSubview:text2Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView2];
    
    UILabel *header3Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER3"];
    [header3Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header3Label];
    
    y += 6;
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [columnScrollView addSubview:text3Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView3];
    
    UILabel *header4Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER4"];
    [header4Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header4Label];
    
    y += 6;
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [columnScrollView addSubview:text4Label];
    
    [columnScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return columnScrollView;
}

/***************************************************************
 * コラムビューの設定
 ***************************************************************/
- (UIScrollView *)setupColumn5 {
    
    // Setup ScrollView
    UIScrollView *columnScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE"];
    [title1Label setTextColor:kColorRedTitle];
    [columnScrollView addSubview:title1Label];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView1];
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [columnScrollView addSubview:text1Label];
    
    y += 6;
    
    UILabel *header1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER1"];
    [header1Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header1Label];
    
    UILabel *header2Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER2"];
    [header2Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header2Label];
    
    y += 6;
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [columnScrollView addSubview:text2Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView2];
    
    UILabel *header3Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER3"];
    [header3Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header3Label];
    
    y += 6;
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [columnScrollView addSubview:text3Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView3];
    
    UILabel *header4Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER4"];
    [header4Label setTextColor:kColorOrangeText];
    [columnScrollView addSubview:header4Label];
    
    y += 6;
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [columnScrollView addSubview:text4Label];
    
    [columnScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return columnScrollView;
}

/***************************************************************
 * コラムビューの設定
 ***************************************************************/
- (UIScrollView *)setupColumn6 {
    
    // Setup ScrollView
    UIScrollView *columnScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)] autorelease];
    
    CGFloat y = inset;
    
    UILabel *title1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:titleFontSize] forKey:@"TITLE"];
    [title1Label setTextColor:kColorRedTitle];
    [columnScrollView addSubview:title1Label];
    
    UIImageView *dotLineImageView1 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView1];
    
    UILabel *text1Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT1"];
    [columnScrollView addSubview:text1Label];
    
    y += singleLineHeight;
    
    UILabel *text2Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT2"];
    [columnScrollView addSubview:text2Label];
    
    UIImageView *dotLineImageView2 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView2];
    
    UILabel *text3Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT3"];
    [columnScrollView addSubview:text3Label];
    
    UIImageView *dotLineImageView3 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView3];
    
    UILabel *text4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT4"];
    [columnScrollView addSubview:text4Label];
    
    UIImageView *dotLineImageView4 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView4];
    
    UILabel *text5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT5"];
    [columnScrollView addSubview:text5Label];
    
    UILabel *text6Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT6"];
    [columnScrollView addSubview:text6Label];
    
    UIImageView *dotLineImageView5 = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView5];
    
    UILabel *header1Label = [self textLabelWithY:&y font:[UIFont boldSystemFontOfSize:mainFontSize] forKey:@"HEADER1"];
    [header1Label setTextColor:kColorRedTitle];
    [columnScrollView addSubview:header1Label];
    
    y += 6;
    
    UILabel *text7Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:mainFontSize] forKey:@"TEXT7"];
    [text7Label setCenter:CGPointMake(text7Label.center.x + 10, text7Label.center.y)];
    [text7Label setTextColor:kColorGrayText];
    [columnScrollView addSubview:text7Label];
    
    [columnScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return columnScrollView;
}

/***************************************************************
 * keyでラベルを返す
 ***************************************************************/
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forKey:(NSString *)key {
    CGSize size = [[NSString stringWithFormat:@"%@", [columnDictionary objectForKey:key]]
                   sizeWithFont:font
                   constrainedToSize:CGSizeMake(textWidth, 4000.f)
                   lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(inset, *y, size.width, size.height)] autorelease];
    [label setText:[NSString stringWithFormat:@"%@", [columnDictionary objectForKey:key]]];
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
    UIImage *image = [UIImage imageNamed:[columnDictionary objectForKey:key]];
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
    UIImage *image = [UIImage imageNamed:[columnDictionary objectForKey:key]];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    
    [imageView setFrame:CGRectMake((kDisplayWidth - image.size.width) / 2,
                                   *y,
                                   image.size.width,
                                   image.size.height)];
    
    *y += image.size.height;
    
    return imageView;
}

/***************************************************************
 * フッターついか
 ***************************************************************/
- (UIScrollView *)addFooter:(UIScrollView *)columnScrollView {
    
    CGFloat y = columnScrollView.contentSize.height;
    
    // 水平区切り線    
    UIImageView *dotLineImageView = [self dotLineImageViewWithY:&y];
    [columnScrollView addSubview:dotLineImageView];
    
    // Set leadSupervisor1 label
    UILabel *leadSupervisor1Label = [[UILabel alloc] initWithFrame:CGRectMake(inset - 4.f, y, 60, 22)];
    [leadSupervisor1Label setNumberOfLines:0];
    [leadSupervisor1Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor1Label setTextColor:[UIColor redColor]];
    [leadSupervisor1Label setText:kLeadConstitutionDiagnosisSupervisor1];
    [columnScrollView addSubview:leadSupervisor1Label];
    [leadSupervisor1Label release];
    
    // Set leadSupervisor2 label    
    UILabel *leadSupervisor2Label = [[UILabel alloc] initWithFrame:CGRectMake(inset + 44.f, y, 140, 22)];
    [leadSupervisor2Label setNumberOfLines:0];
    [leadSupervisor2Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor2Label setTextColor:[UIColor blackColor]];
    [leadSupervisor2Label setText:kLeadConstitutionDiagnosisSupervisor2];
    [columnScrollView addSubview:leadSupervisor2Label];
    [leadSupervisor2Label release];
    
    y += singleLineHeight;
    
    // Set leadSupervisor3 label
    UILabel *leadSupervisor3Label = [[UILabel alloc] initWithFrame:CGRectMake(inset + 2.f, y, 282, 22)];
    [leadSupervisor3Label setNumberOfLines:0];
    [leadSupervisor3Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor3Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    [leadSupervisor3Label setText:kLeadConstitutionDiagnosisSupervisor3];
    [columnScrollView addSubview:leadSupervisor3Label];
    [leadSupervisor3Label release];
    
    y += singleLineHeight + dotLineOffset;
    
    // Set leadSupervisor4 label
    UILabel *leadSupervisor4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor4];
    [leadSupervisor4Label setCenter:CGPointMake(leadSupervisor4Label.center.x - 6, leadSupervisor4Label.center.y)];
    [leadSupervisor4Label setTextColor:[UIColor redColor]];
    [columnScrollView addSubview:leadSupervisor4Label];

    y += 6;
    
    // Set leadSupervisor7 label
    CGSize size7 = [kLeadConstitutionDiagnosisSupervisor7 sizeWithFont:[UIFont systemFontOfSize:13]];
    UILabel *leadSupervisor7Label = [[UILabel alloc] initWithFrame:CGRectMake(kDisplayWidth - inset - size7.width, y, size7.width, size7.height)];
    [leadSupervisor7Label setNumberOfLines:0];
    [leadSupervisor7Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor7Label setTextColor:[UIColor blackColor]];
    [leadSupervisor7Label setText:kLeadConstitutionDiagnosisSupervisor7];
    [columnScrollView addSubview:leadSupervisor7Label];
    [leadSupervisor7Label release];
    
    // Set leadSupervisor5 label
    UILabel *leadSupervisor5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor5];
    [leadSupervisor5Label setTextColor:[UIColor blackColor]];
    [columnScrollView addSubview:leadSupervisor5Label];
    
    // Set leadSupervisor6 label
    UILabel *leadSupervisor6Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor6];
    [leadSupervisor6Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    [columnScrollView addSubview:leadSupervisor6Label];
    
    y += 6;
    
    // Set leadSupervisor10 label
    CGSize size10 = [kLeadConstitutionDiagnosisSupervisor10 sizeWithFont:[UIFont systemFontOfSize:13]];
    UILabel *leadSupervisor10Label = [[UILabel alloc] initWithFrame:CGRectMake(kDisplayWidth - inset - size10.width, y, size10.width, size10.height)];
    [leadSupervisor10Label setNumberOfLines:0];
    [leadSupervisor10Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor10Label setTextColor:[UIColor blackColor]];
    [leadSupervisor10Label setText:kLeadConstitutionDiagnosisSupervisor10];
    [columnScrollView addSubview:leadSupervisor10Label];
    [leadSupervisor10Label release];
    
    // Set leadSupervisor8 label
    UILabel *leadSupervisor8Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor8];
    [leadSupervisor8Label setTextColor:[UIColor blackColor]];
    [columnScrollView addSubview:leadSupervisor8Label];
    
    // Set leadSupervisor9 label
    UILabel *leadSupervisor9Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor9];
    [leadSupervisor9Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    [columnScrollView addSubview:leadSupervisor9Label];
    
    y += dotLineOffset;
    
    [columnScrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    return columnScrollView;
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
    [navigationBarTitleLabel setText:kNavigationBarTitleOshieteName];
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
