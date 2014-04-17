//
//  DatabaseAccessor.h
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseAccessor : NSObject

//used to save the game. This function is called each time the user trigger the
//updating of the game state.
+ (void)saveGame;

@end
