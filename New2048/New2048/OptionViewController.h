//
//  OptionViewController.h
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import <StoreKit/StoreKit.h>

// the option view of the apps.

@protocol BeginNewGameDelegate;


@interface OptionViewController : UIViewController<SKStoreProductViewControllerDelegate>

@property(nonatomic, weak) id<BeginNewGameDelegate> delegate;

@end


@protocol BeginNewGameDelegate

- (void)beginNewGame;

@end