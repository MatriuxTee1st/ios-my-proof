//
//  TimerViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/21.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "TimerViewController.h"

static NSString *animationTypeKey = @"animationType";
static NSString *removeBackgroundValue = @"removeBackground";
static NSString *removeTimeViewValue = @"removeTimeView";
static NSString *removeStopScreenValue = @"removeStopScreen";
static NSString *removeMainViewValue = @"removeMainView";

@interface TimerViewController ()

- (void)startTimer;
- (void)stopTimer;
- (void)removeBackground:(BOOL)animated;
- (void)removeStopScreen;

@end

@implementation TimerViewController

@synthesize delegate;
@synthesize isVisible;

static TimerViewController *sharedTimerViewController = nil;

/***************************************************************
 * TimerViewシングルトン
 ***************************************************************/
+ (TimerViewController *)sharedTimerViewController {
    if (sharedTimerViewController == nil) {
        sharedTimerViewController = [[super allocWithZone:NULL] init];
    }
    
    return sharedTimerViewController;
}


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
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [super dealloc];
}

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    PrintLog(@"");
    [self.view setFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kDisplayHeight - kTabBarHeight - kStatusBarHeight)];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.4f]];
    invisibleCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [invisibleCancelButton setBackgroundColor:[UIColor clearColor]];
    [invisibleCancelButton setExclusiveTouch:YES];
    [invisibleCancelButton setFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kDisplayHeight - kTabBarHeight - kStatusBarHeight)];
    [invisibleCancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invisibleCancelButton];
    
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    
    if (setCategoryError) { /* handle the error condition */ }
}

/***************************************************************
 * タブ切替時
 ***************************************************************/
- (void)removeFromSuperviewInBackground {
    PrintLog(@"Removing timer view in background from different tab");
    
    if (kitchenPlayer) {
        [kitchenPlayer release], kitchenPlayer = nil;
    }
    
    if (backgroundView) {
        [self removeBackground:NO];
        [backgroundView removeFromSuperview], backgroundView = nil;
    } else if (stopButton) {
        [stopButton removeFromSuperview], stopButton = nil;
    }
    
    [self.view removeFromSuperview];
}

/***************************************************************
 * Display Timer Selection View
 ***************************************************************/
- (void)addTimerSelectionView {
    
    isVisible = YES;
    
    CGFloat timeSelectLabelY = 44.f;
    CGFloat timeButtonY = 110.f;
    CGFloat controlButtonY = 180.f;
    
    selectedTime = 0;
    if (!isTiming) {
        [invisibleCancelButton setTag:4001];
        
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 172.f, kDisplayWidth, 240.f)];
        [backgroundView setBackgroundColor:[UIColor blackColor]];

        // Set up wood background.
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, 240.f)];
        [backgroundImageView setImage:[UIImage imageNamed:kTimerBackgroundImageName]];
        [backgroundView addSubview:backgroundImageView];
        [backgroundImageView release];
    
        // Setup cancel button.
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [cancelButton setExclusiveTouch:YES];
        [cancelButton setFrame:CGRectMake(kDisplayWidth - 30.f, 0.f, 30.f, 30.f)];
        [cancelButton setImage:[UIImage imageNamed:kTimerCancelButtonImageName] forState:UIControlStateNormal];
        [cancelButton setTag:4002];
        [cancelButton addTarget:self
                         action:@selector(cancelButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:cancelButton];
        
        // Setup clock image view.
        UIImageView *clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 5.f, kDisplayWidth, 105.f)];
        [clockImageView setImage:[UIImage imageNamed:kTimerClockIconImageName]];
        [backgroundView addSubview:clockImageView];
        [clockImageView release];
        
        // Setup colon label.
        UILabel *colonLabel = [[UILabel alloc] initWithFrame:CGRectMake(153.f, timeSelectLabelY, 14.f, 40.f)];
        [colonLabel setBackgroundColor:[UIColor clearColor]];
        [colonLabel setFont:[UIFont systemFontOfSize:36.f]];
        [colonLabel setText:@":"];
        [colonLabel setTextAlignment:UITextAlignmentCenter];
        [colonLabel setTextColor:[UIColor whiteColor]];
        [backgroundView addSubview:colonLabel];
        [colonLabel release];
        
        // Setup minutes label.
        minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(107.f, timeSelectLabelY + 2, 50.f, 40.f)];
        [minutesLabel setBackgroundColor:[UIColor clearColor]];
        [minutesLabel setFont:[UIFont systemFontOfSize:36.f]];
        [minutesLabel setText:[NSString stringWithFormat:@"%02d", selectedTime / 60]];
        [minutesLabel setTextAlignment:UITextAlignmentRight];
        [minutesLabel setTextColor:[UIColor whiteColor]];
        [backgroundView addSubview:minutesLabel];
        [minutesLabel release];
        
        // Setup seconds label.
        secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(163.f, timeSelectLabelY + 2, 50.f, 40.f)];
        [secondsLabel setBackgroundColor:[UIColor clearColor]];
        [secondsLabel setFont:[UIFont systemFontOfSize:36.f]];
        [secondsLabel setText:[NSString stringWithFormat:@"%02d", selectedTime % 60]];
        [secondsLabel setTextAlignment:UITextAlignmentLeft];
        [secondsLabel setTextColor:[UIColor whiteColor]];
        [backgroundView addSubview:secondsLabel];
        [secondsLabel release];
        
        // Setup plusTenMinutes button.
        plusTenMinutesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusTenMinutesButton setExclusiveTouch:YES];
        [plusTenMinutesButton setFrame:CGRectMake(0.f, timeButtonY, 113.f, 64.f)];
        [plusTenMinutesButton setImage:[UIImage imageNamed:kTimerPlusTenMinButtonImageName] forState:UIControlStateNormal];
        [plusTenMinutesButton setTag:600];
        [plusTenMinutesButton addTarget:self action:@selector(plusTimeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:plusTenMinutesButton];

        // Setup plusOneMinute button.
        plusOneMinuteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusOneMinuteButton setExclusiveTouch:YES];
        [plusOneMinuteButton setFrame:CGRectMake(113.f, timeButtonY, 93.f, 64.f)];
        [plusOneMinuteButton setImage:[UIImage imageNamed:kTimerPlusOneMinButtonImageName] forState:UIControlStateNormal];
        [plusOneMinuteButton setTag:60];
        [plusOneMinuteButton addTarget:self action:@selector(plusTimeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:plusOneMinuteButton];
        
        // Setup plusTenSeconds button.
        plusTenSecondsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusTenSecondsButton setExclusiveTouch:YES];
        [plusTenSecondsButton setFrame:CGRectMake(206.f, timeButtonY, 113.f, 64.f)];
        [plusTenSecondsButton setImage:[UIImage imageNamed:kTimerPlusTenSecButtonImageName] forState:UIControlStateNormal];
        [plusTenSecondsButton setTag:10];
        [plusTenSecondsButton addTarget:self action:@selector(plusTimeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:plusTenSecondsButton];
        
        // Set up start button.
        startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [startButton setEnabled:NO];
        [startButton setExclusiveTouch:YES];
        [startButton setFrame:CGRectMake(0.f, controlButtonY, 158.f, 50.f)];
        [startButton setImage:[UIImage imageNamed:kTimerStartButtonImageName] forState:UIControlStateNormal];
        [startButton addTarget:self
                        action:@selector(startButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:startButton];
        
        // Setup reset time selection button
        resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [resetButton setEnabled:NO];
        [resetButton setExclusiveTouch:YES];
        [resetButton setFrame:CGRectMake(158.f, controlButtonY, 162.f, 50.f)];
        [resetButton setImage:[UIImage imageNamed:kTimerResetButtonImageName] forState:UIControlStateNormal];
        [resetButton addTarget:self action:@selector(resetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:resetButton];
        
        // Setup bottom space filler.
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 257.f, kDisplayWidth, 17.f)];
        [bottomLabel setBackgroundColor:[UIColor colorWithRed:0.1563f green:0.1641f blue:0.2227f alpha:1.f]];
        [backgroundView addSubview:bottomLabel];
        [bottomLabel release];
        
        // Enter screen animation.
        CATransition *enterTransition = [CATransition animation];
        [enterTransition setType:kCATransitionMoveIn];
        [enterTransition setSubtype:kCATransitionFromTop];
        [enterTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [backgroundView.layer addAnimation:enterTransition forKey:nil];
        
        [self.view addSubview:backgroundView];
        [backgroundView release];
    } else {
        [invisibleCancelButton setTag:4000];
        
        // Enter screen animation.
        CATransition *enterTransition = [CATransition animation];
        [enterTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [enterTransition setType:kCATransitionReveal];
        
        // Set up stop button.
        stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [stopButton setFrame:CGRectMake(0.f, 165.f, 320.f, 70.f)];
        [stopButton setImage:[UIImage imageNamed:kTimerStopButtonImageName] forState:UIControlStateNormal];
        [stopButton addTarget:self
                       action:@selector(stopButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [stopButton.layer addAnimation:enterTransition forKey:nil];
        [self.view addSubview:stopButton];
    }
}

#pragma mark - Action Methods

/***************************************************************
 * Update current selected time and update time display
 ***************************************************************/
- (void)plusTimeButtonPressed:(UIButton *)button {
    [startButton setEnabled:YES];
    [resetButton setEnabled:YES];
    
    selectedTime += [button tag];
    
    if (selectedTime >= 5400) {
        [plusTenMinutesButton  setEnabled:NO];
    }
    
    if (selectedTime >= 5940) {
        [plusOneMinuteButton setEnabled:NO];
    }
    
    if (selectedTime >= 5990) {
        [plusTenSecondsButton setEnabled:NO];
    }
    
    [minutesLabel setText:[NSString stringWithFormat:@"%02d", selectedTime / 60]];
    [secondsLabel setText:[NSString stringWithFormat:@"%02d", selectedTime % 60]];
}

/***************************************************************
 * Update current selected time and update time display
 ***************************************************************/
- (void)resetButtonPressed:(UIButton *)button {
    selectedTime = 0;
    
    [startButton setEnabled:NO];
    [resetButton setEnabled:NO];
    
    [plusTenMinutesButton  setEnabled:YES];
    [plusOneMinuteButton setEnabled:YES];
    [plusTenSecondsButton setEnabled:YES];
    
    [minutesLabel setText:@"00"];
    [secondsLabel setText:@"00"];
}

/***************************************************************
 * Start timer and display time
 ***************************************************************/
- (void)startButtonPressed:(UIButton *)button {
    [self startTimer];
}

/***************************************************************
 * Stop timer and disable display changes
 ***************************************************************/
- (void)stopButtonPressed:(UIButton *)button {
    if (kitchenPlayer) {
        [kitchenPlayer release], kitchenPlayer = nil;
    }
    
    [self stopTimer];
    
    [self removeStopScreen];
}

/***************************************************************
 * Cancel button pressed
 ***************************************************************/
- (void)cancelButtonPressed:(UIButton *)button {
    if ([button tag] == 4000) {
        [self removeStopScreen];
    } else {
        [self removeBackground:YES];
    }
}

/***************************************************************
 * バックグラウンド非表示
 ***************************************************************/
- (void)removeBackground:(BOOL)animated {
    if (animated) {
        CATransition *exitTransition = [CATransition animation];
        [exitTransition setDelegate:self];
        [exitTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [exitTransition setType:kCATransitionPush];
        [exitTransition setSubtype:kCATransitionFromBottom];
        [exitTransition setValue:removeBackgroundValue forKey:animationTypeKey];
        [backgroundView.layer addAnimation:exitTransition forKey:nil];
    }
    
    [backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x,
                                        480.f,
                                        backgroundView.frame.size.width,
                                        backgroundView.frame.size.height)];
    
    isVisible = NO;
}

/***************************************************************
 * ストップ画面非表示
 ***************************************************************/
- (void)removeStopScreen {
    // Enter screen animation.
    CATransition *exitTransition = [CATransition animation];
    [exitTransition setDelegate:self];
    [exitTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
    [exitTransition setType:kCATransitionFade];
    [exitTransition setValue:removeStopScreenValue forKey:animationTypeKey];
    [self.view.layer addAnimation:exitTransition forKey:nil];
    [self.view setAlpha:0.f];
}

/***************************************************************
 * アニメーション終了時
 ***************************************************************/
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    NSString *value = [theAnimation valueForKey:animationTypeKey];
    
    if ([value isEqualToString:removeBackgroundValue]) {
        [backgroundView removeFromSuperview], backgroundView = nil;
        
        CATransition *exitTransition = [CATransition animation];
        [exitTransition setDelegate:self];
        [exitTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [exitTransition setType:kCATransitionFade];
        [exitTransition setValue:removeMainViewValue forKey:animationTypeKey];
        [self.view.layer addAnimation:exitTransition forKey:nil];
        
        [self.view setAlpha:0.f];
    } else if ([value isEqualToString:removeTimeViewValue]) {
        [timeView removeFromSuperview];
    } else if ([value isEqualToString:removeStopScreenValue]) {
        if ([delegate respondsToSelector:@selector(enableTimerButton)]) {
            [delegate enableTimerButton];
        }
        
        [stopButton removeFromSuperview], stopButton = nil;
        [self.view removeFromSuperview];
        [self.view setAlpha:1.f];
    } else if ([value isEqualToString:removeMainViewValue]) {
        if ([delegate respondsToSelector:@selector(enableTimerButton)]) {
            [delegate enableTimerButton];
        }
        
        [self.view removeFromSuperview];
        [self.view setAlpha:1.f];
    }
}


#pragma mark - Timer Methods

/***************************************************************
 * Start timer and display time
 ***************************************************************/
- (void)startTimer {
    isTiming = YES;

    remainingSeconds = selectedTime;
    selectedTime = 0;
    
    // Prepare music file.
    //get the audio file path
    NSString *newAudioFile = [[NSBundle mainBundle] pathForResource:@"Timer"  ofType:@"mp3"];
    kitchenPlayer =  [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:newAudioFile] error:NULL];
    [kitchenPlayer setDelegate:self];
    [kitchenPlayer prepareToPlay];
    
    // Set up timer.
    kitchenTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                    target:self
                                                  selector:@selector(updateTimer)
                                                  userInfo:nil
                                                   repeats:YES];
    timeView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 409.f, kDisplayWidth, 22.f)];
    [timeView setBackgroundColor:[UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.5f]];
    
    // Display Timer label from tab bar.
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.f, 0.f, 100.f, 22.f)];
    [timerLabel setBackgroundColor:[UIColor clearColor]];
    [timerLabel setFont:[UIFont systemFontOfSize:14.f]];
    [timerLabel setText:[NSString stringWithFormat:@"%d:%02d", remainingSeconds / 60, remainingSeconds % 60]];
    [timerLabel setTextAlignment:UITextAlignmentCenter];
    [timerLabel setTextColor:[UIColor whiteColor]];
    [timeView addSubview:timerLabel];
    [timerLabel release];
    
    CATransition *enterTransition = [CATransition animation];
    [enterTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
    [enterTransition setType:kCATransitionPush];
    [enterTransition setSubtype:kCATransitionFromTop];
    [timeView.layer addAnimation:enterTransition forKey:nil];
    
    [[[delegate tabBarController] view] insertSubview:timeView atIndex:1];
    [timeView release];
    
    [self removeBackground:YES];
}

/***************************************************************
 * Update timer display
 ***************************************************************/
- (void)updateTimer {
    PrintLog(@"Tick");
    // Decrement count
    remainingSeconds--;
    
    [timerLabel setText:[NSString stringWithFormat:@"%d:%02d", remainingSeconds / 60, remainingSeconds % 60]];
    
    // Stop timer when count reaches zero.
    if (remainingSeconds == 0) {
        [self stopTimer];
        
        if (stopButton) {
            // Enter screen animation.
            CATransition *exitTransition = [CATransition animation];
            [exitTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
            [exitTransition setType:kCATransitionReveal];
            [stopButton.layer addAnimation:exitTransition forKey:nil];
            [stopButton removeFromSuperview], stopButton = nil;
            [self addTimerSelectionView];
        }
        
        [kitchenPlayer play];
    }
}

/***************************************************************
 * Stop timer and disable display changes
 ***************************************************************/
- (void)stopTimer {
    isTiming = NO;
    
    [kitchenTimer invalidate];
    
    CATransition *exitTransition = [CATransition animation];
    [exitTransition setDelegate:self];
    [exitTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
    [exitTransition setType:kCATransitionPush];
    [exitTransition setSubtype:kCATransitionFromBottom];
    [exitTransition setValue:removeTimeViewValue forKey:animationTypeKey];
    [timeView.layer addAnimation:exitTransition forKey:nil];
    
    [timeView setFrame:CGRectMake(timeView.frame.origin.x,
                                  timeView.frame.origin.y + timeView.frame.size.height,
                                  timeView.frame.size.width,
                                  timeView.frame.size.height)];
}

#pragma mark - AVAudioPlayerDelegate

/***************************************************************
 * チャイム終了時
 ***************************************************************/
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (kitchenPlayer) {
        [kitchenPlayer release], kitchenPlayer = nil;
    }
}


@end
