//
//  GameViewController.m
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
{
    __weak UILabel * _score;
    __weak UIButton * _option;
    __weak UIImageView * _gameBackgroundImageView;
}

@property(nonatomic, weak) IBOutlet UILabel * score;
@property(nonatomic, weak) IBOutlet UIButton* option;
@property(nonatomic, weak) IBOutlet UIImageView* gameBackgroundImageView;


@end

@implementation GameViewController

@synthesize score = _score;
@synthesize option = _option;
@synthesize gameBackgroundImageView = _gameBackgroundImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // for debug
    //TODO: improve this code
    
    _gameBackgroundImageView.backgroundColor = [UIColor redColor];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
