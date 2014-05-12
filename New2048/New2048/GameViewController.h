//
//  GameViewController.h
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAdView.h"
#import "DMTools.h"
#import "OptionViewController.h"
#import "GameOverViewController.h"
#import "GADBannerViewDelegate.h"

// the main view of the game.

enum PieceState{
    StateNone,
    StateA,
    StateB,
    StateC,
    StateD,
    StateE,    
    StateF,
    StateG,
    StateH,
    StateI,
    StateJ,
    StateK,
    StateL,
    StateM,
    StateN,
    StateO,
    StateP,
    StateQ,
    
};

@interface GameViewController : UIViewController<DMAdViewDelegate, BeginNewGameDelegate, GADBannerViewDelegate>

@end
