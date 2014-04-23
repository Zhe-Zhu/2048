//
//  GameOverViewController.m
//  New2048
//
//  Created by LG on 4/19/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "GameOverViewController.h"
#import "UMSocial.h"
#import "Global.h"

@interface GameOverViewController ()
{
    __weak id<BeginNewGameDelegate> _delegate;
    __weak UIButton * _share;
    __weak UIButton * _restart;
    __weak UIImageView * _gameOverTitle;
    int _score;
}

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton * share;
@property (weak, nonatomic) IBOutlet UIButton * restart;

- (IBAction)share:(id)sender;
- (IBAction)restartGame:(id)sender;
@end

@implementation GameOverViewController

@synthesize delegate = _delegate;
@synthesize score = _score;
@synthesize share = _share;
@synthesize restart = _restart;
@synthesize imageViewTitle = _imageViewTitle;

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
    
    [_imageViewTitle setImage:[UIImage imageNamed:NSLocalizedString(@"GameOverTitle", nil)]];
    [_share setImage:[UIImage imageNamed:NSLocalizedString(@"Share", nil)] forState:UIControlStateNormal];
    [_restart setImage:[UIImage imageNamed:NSLocalizedString(@"NewGame", nil)] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    
    // adjust the share and restart position.
    if (IS_IPHONE5) {
        _restart.center = CGPointMake(160, IPhone5Height - 92);
        _share.center = CGPointMake(160, IPhone5Height - 165);
    }
    else
    {
        _restart.center = CGPointMake(160, IPhone4Height - 92 + 20);
        _share.center = CGPointMake(160, IPhone4Height - 165 + 20);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {
    
    // share
    [self shareThingsToSocialMedia:self text:@"hello" Image:nil delegate:nil];
}

- (IBAction)restartGame:(id)sender {
    
    [_delegate beginNewGame];
    self.view.alpha = 0.0;
    [self.view removeFromSuperview];
}

- (void)shareThingsToSocialMedia:(UIViewController *)inController text:(NSString *)text Image:(UIImage *)image delegate:(id<UMSocialUIDelegate>)delegate
{
    [UMSocialSnsService presentSnsIconSheetView:inController
                                         appKey:UMAppKey
                                      shareText:text
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToSms,UMShareToEmail,nil]
                                       delegate:delegate];
}

// 吸收发生在该view上的touch事件以防止下传到superview。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
