//
//  DatabaseAccessor.h
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import "Global.h"

@interface DatabaseAccessor : NSObject


+ (id)sharedInstance;
//used to save the game. This function is called each time the user trigger the
//updating of the game state.

- (void)saveGame:(enum PieceState[gameDimension][gameDimension])state score:(int)score indicator:(BOOL)indicator;

// return yes means there is aviable game state in the data base.
// return no means there is no aviable game state in the data base.
- (BOOL)restoreGameState:(enum PieceState[gameDimension][gameDimension])state score:(int *)bestScore currentScore:(int *)currentScore;


@end
