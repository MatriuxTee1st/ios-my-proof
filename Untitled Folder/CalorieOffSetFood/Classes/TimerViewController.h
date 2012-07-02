//
//  TimerViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/21.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Utility.h"


@interface TimerViewController : UIViewController <AVAudioPlayerDelegate> {
    id delegate;
    
    UIButton *invisibleCancelButton;

    NSInteger selectedTime;
    
    UIButton *plusTenMinutesButton;
    UIButton *plusOneMinuteButton;
    UIButton *plusTenSecondsButton;
    
    UILabel *minutesLabel;
    UILabel *secondsLabel;
    
    UIView *backgroundView;
    UIButton *startButton;
    UIButton *stopButton;
    UIButton *resetButton;

    BOOL isTiming;
    BOOL isVisible;
    
    NSTimer *kitchenTimer;
    NSInteger remainingSeconds;
    UILabel *timerLabel;
    UIView *timeView;
    AVAudioPlayer* kitchenPlayer;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL isVisible;

+ (TimerViewController *)sharedTimerViewController;
- (void)addTimerSelectionView;
- (void)removeFromSuperviewInBackground;

@end

@protocol TimerViewControllerDelegate

- (void)enableTimerButton;

@end
