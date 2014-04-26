//
//  GameOverViewController.h
//  New2048
//
//  Created by LG on 4/19/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionViewController.h"
#import "GameViewController.h"

@interface GameOverViewController : UIViewController

@property(nonatomic, weak) id<BeginNewGameDelegate> delegate;
@property(nonatomic, assign) int score;
@property(nonatomic, strong) NSString * titleStr;
@property(nonatomic, assign) enum PieceState level;
@property(nonatomic, strong) UIImage * levelImage;

@end
