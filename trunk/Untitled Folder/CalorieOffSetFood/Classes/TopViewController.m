//
//  TopTableViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/13.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "TopViewController.h"
#import "NSData+Base64.h"
#import "BannerLinkViewController.h"

typedef enum {
    TopTableRowSetFoodSearch = 0,
    TopTableRowPhotoSearch,
    TopTableRowBodyTypeSearch,
    TopTableRowHealthTest,
    TopTableRowCount,
    TopTableRowCategorySearch,
} TopTableRows;

static CGFloat cellHeight = 72.f;

@implementation TopViewController

#pragma mark -
#pragma mark Initialization
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    self.view = [[[UIView alloc] init] autorelease];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    /*
     * トップ画面
     */
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, 125.f)];
    [topImageView setImage:[UIImage imageNamed:kTopIconTopImageName]];
    [self.view addSubview:topImageView];
    [topImageView release];
    
    /*
     * トップのテーブル
     */
    UITableView *topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 125.f, kDisplayWidth, 412.f - 124.f) style:UITableViewStylePlain];
    [topTableView setDataSource:self];
    [topTableView setDelegate:self];
    [topTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:topTableView];
    [topTableView release];
}

- (void)viewWillAppear:(BOOL)animated {
    [self insertBanner:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeBanner];
}

#pragma mark - Banner methods

/***************************************************************
 * バナー表示
 ***************************************************************/
- (void)insertBanner:(BOOL)animated {
    if (!isShowingBanner && delay > 0) {
        PrintLog(@"Inserting Banner");
        isShowingBanner = YES;
        
        CGFloat bannerWidth = bannerImage.size.width > 320 ? bannerImage.size.width / 2 : bannerImage.size.width;
        CGFloat bannerHeight = bannerImage.size.width > 320 ? bannerImage.size.height / 2 : bannerImage.size.height;
        bannerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [bannerButton setFrame:CGRectMake((kDisplayWidth - bannerWidth) / 2, 412.f - bannerHeight, bannerWidth, bannerHeight)];
        [bannerButton setImage:bannerImage forState:UIControlStateNormal];
        [bannerButton setImage:bannerImage forState:UIControlStateHighlighted];
        [bannerButton addTarget:self
                         action:@selector(goToBannerURL:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bannerButton];
        if (animated) {
            CATransition *bannerTransition = [CATransition animation];
            [bannerTransition setType:kCATransitionReveal];
            [bannerTransition setSubtype:kCATransitionFromTop];
            [bannerTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
            [bannerTransition setDuration:1.f];
            [bannerButton.layer addAnimation:bannerTransition forKey:nil];
        }
        [self performSelector:@selector(setupRemoveBanner) withObject:nil afterDelay:delay];
    }
}

/***************************************************************
 * バナー非表示準備
 ***************************************************************/
- (void)setupRemoveBanner {
    if (isShowingBanner) {
        CATransition *bannerTransition = [CATransition animation];
        [bannerTransition setType:kCATransitionPush];
        [bannerTransition setSubtype:kCATransitionFromBottom];
        [bannerTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [bannerTransition setDuration:1.f];
        [bannerTransition setDelegate:self];
        [bannerButton.layer addAnimation:bannerTransition forKey:nil];
        
        [bannerButton setFrame:CGRectMake(bannerButton.frame.origin.x,
                                          bannerButton.frame.origin.y + bannerButton.frame.size.height,
                                          bannerButton.frame.size.width,
                                          bannerButton.frame.size.height)];
    }
}

/***************************************************************
 * バナー非表示
 ***************************************************************/
- (void)removeBanner {
    if (isShowingBanner) {
        PrintLog(@"Removing Banner");
        isShowingBanner = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setupRemoveBanner) object:nil];
        [bannerButton removeFromSuperview];
    }
}

/***************************************************************
 * アニメーション終了時
 ***************************************************************/
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (isShowingBanner) {
        PrintLog(@"Animation Done, released bannerview");
        [self removeBanner];
    }
}

/***************************************************************
 * 
 ***************************************************************/
- (void)goToBannerURL:(UIButton *)button {
    PrintLog(@"Banner button pressed");
    BannerLinkViewController *bannerLinkViewController = [[BannerLinkViewController alloc] init];
    [bannerLinkViewController setBannerURL:bannerURL];
    [self presentModalViewController:bannerLinkViewController animated:YES];
    [bannerLinkViewController release];
}

#pragma mark - Network methods

/***************************************************************
 * バナーデータ取得
 ***************************************************************/
- (void)getBannerData {
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerGetBanner];
        NSURL *url = [NSURL URLWithString:urlString];

        NSData *requestData 
        = [[NSString stringWithFormat:@"%@", kRankingServerPassword] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

/***************************************************************
 * 通信開始時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    receivedData = [[NSMutableData alloc] init];
    PrintLog(@"通信開始");
}


/***************************************************************
 * データ受信時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
//    PrintLog(@"データ受信中");
}


/***************************************************************
 * 通信完了
 ***************************************************************/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    PrintLog(@"通信完了");
    NSString *result = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    [receivedData release];
    NSDictionary *bannerDictionary = [result JSONValue];
    
    if (![[bannerDictionary objectForKey:@"bannerImage"] isEqualToString:@""]) {
        bannerImage = [[UIImage imageWithData:[NSData dataWithBase64EncodedString:[bannerDictionary objectForKey:@"bannerImage"]]] retain];
        delay = [[bannerDictionary objectForKey:@"displayTime"] intValue] / 1000.f;
        bannerURL = [[NSURL URLWithString:[bannerDictionary objectForKey:@"url"]] retain];
        
        if (!(0 < delay && delay <= NSIntegerMax)) {
            delay = 5;
        }
    }
    
    [self insertBanner:YES];
}

#pragma mark - UITableView datasource

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TopTableRowCount;
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
//        UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(110.f, (cellHeight - 40.f) / 2, 180.f, 40.f)] autorelease];
//        [textLabel setFont:[UIFont systemFontOfSize:18.f]];
//        [textLabel setTag:9900];
//        [textLabel setTextColor:kColorGrayText];
//
//        [cell.contentView addSubview:textLabel];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90.f, 0.f, 230.f, 56.f)];
        [titleImageView setTag:9001];
        [cell.contentView addSubview:titleImageView];
        [titleImageView release];
        
        UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.f, floorf((cellHeight - 50) / 2.f), 54, 50)];
        [thumbnailImageView setTag:9002];
        [cell.contentView addSubview:thumbnailImageView];
        [thumbnailImageView release];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(278.f, 
                                                                                    floorf((cellHeight - 19) / 2.f),
                                                                                    19, 
                                                                                    19)];
        [arrowImageView setImage:[UIImage imageNamed:kTopArrowImageName]];
        [cell.contentView addSubview:arrowImageView];
        [arrowImageView release];
        
        UIImageView *dotLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        [dotLineImageView setImage:[UIImage imageNamed:kTopLineDotImageName]];
        [cell.contentView addSubview:dotLineImageView];
        [dotLineImageView release];
    }
    
    UIImageView *titleImageView = (UIImageView *)[cell viewWithTag:9001];
    UIImageView *thumbnailImageView = (UIImageView *)[cell viewWithTag:9002];

    switch ([indexPath row]) {
        case TopTableRowCategorySearch:
            break;
        case TopTableRowSetFoodSearch:
            [thumbnailImageView setImage:[UIImage imageNamed:kTopIconImage1]];
            [titleImageView setImage:[UIImage imageNamed:kTopIconWord1]];
            break;
        case TopTableRowPhotoSearch:
            [thumbnailImageView setImage:[UIImage imageNamed:kTopIconImage2]];
            [titleImageView setImage:[UIImage imageNamed:kTopIconWord2]];
            break;
        case TopTableRowBodyTypeSearch:
            [thumbnailImageView setImage:[UIImage imageNamed:kTopIconImage3]];
            [titleImageView setImage:[UIImage imageNamed:kTopIconWord3]];
            break;
        case TopTableRowHealthTest:
            [thumbnailImageView setImage:[UIImage imageNamed:kTopIconImage4]];
            [titleImageView setImage:[UIImage imageNamed:kTopIconWord4]];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([indexPath row]) {
        // 主菜・副菜から探すセル押下時
        case TopTableRowCategorySearch:{
            CategorySearchTableViewController *nextPage = [[CategorySearchTableViewController alloc] init];
            [self.navigationController pushViewController:nextPage animated:YES];
            [nextPage release];
            break;
        }
            
        // 食材から探すセル押下時
        case TopTableRowSetFoodSearch:{
            SetFoodSearchTableViewController *nextPage = [[SetFoodSearchTableViewController alloc] initWithType:kBodyTypeB];
            [self.navigationController pushViewController:nextPage animated:YES];
            [nextPage release];
            break;
        }
            
        // 写真から探すセル押下時
        case TopTableRowPhotoSearch:{
            PhotoSearchViewController *nextPage = [[PhotoSearchViewController alloc] init];
            [self.navigationController pushViewController:nextPage animated:YES];
            [nextPage release];
            break;
        }
            
            // 写真から探すセル押下時
        case TopTableRowBodyTypeSearch:{
            BodyTypeSearchTableViewController *nextPage = [[BodyTypeSearchTableViewController alloc] initWithType:kBodyTypeB];
            [self.navigationController pushViewController:nextPage animated:YES];
            [nextPage release];
            break;
        }
            
        // 体質診断セル押下時
        case TopTableRowHealthTest:{
            ConstitutionDiagnosisTableViewController *nextPage = [[ConstitutionDiagnosisTableViewController alloc] init];
            [self.navigationController pushViewController:nextPage animated:YES];
            [nextPage release];
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [bannerButton release];
    [bannerImage release];
    [bannerURL release];
    [super dealloc];
}


@end

