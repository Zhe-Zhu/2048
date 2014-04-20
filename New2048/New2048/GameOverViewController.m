//
//  GameOverViewController.m
//  New2048
//
//  Created by LG on 4/19/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()
{
    __weak id<BeginNewGameDelegate> _delegate;
    int _score;
}

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

- (IBAction)share:(id)sender;
- (IBAction)restartGame:(id)sender;
@end

@implementation GameOverViewController

@synthesize delegate = _delegate;
@synthesize score = _score;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setScore:(int)score
{
    _score = score;
    [_scoreLabel setText:[NSString stringWithFormat:@"%d",score]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.94 blue:0.81 alpha:1];
    [_scoreLabel setText:[NSString stringWithFormat:@"%d",_score]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {
    
    // share
}

- (IBAction)restartGame:(id)sender {
    
    [_delegate beginNewGame];
    self.view.alpha = 0.0;
    [self.view removeFromSuperview];
}
@end
