//
//  SplashViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/1/11.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplashScreenDelegate;

@interface SplashViewController : UIViewController {
    id<SplashScreenDelegate> delegate;
}

@property (nonatomic, assign) id<SplashScreenDelegate> delegate;

- (void)hide;

@end

@protocol SplashScreenDelegate <NSObject>

@optional
- (void)splashScreenDidAppear:(SplashViewController *)splashViewController;
- (void)splashScreenWillDisappear:(SplashViewController *)splashViewController;
- (void)splashScreenDidDisappear:(SplashViewController *)splashViewController;

@end