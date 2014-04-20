//
//  GameViewController.h
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <UIKit/UIKit.h>

// the main view of the game.

enum PieceState{
    StateNone,
    StateA,    // white
    StateB,    // red
    StateC,    // blue
    StateD,    // green
    StateE,    // black
    StateF,
    StateG,
    StateH,
    StateI,
    StateJ,
    StateK
};

@interface GameViewController : UIViewController

@end
