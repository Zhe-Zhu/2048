//
//  GameState.h
//  New2048
//
//  Created by Chen Xiangwen on 19/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GameState : NSManagedObject

@property (nonatomic, retain) id gameState;
@property (nonatomic, retain) NSNumber * bestScore;
@property (nonatomic, retain) NSNumber * indicator;

@end
