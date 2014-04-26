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
#import "Utilies.h"

@interface GameOverViewController ()
{
    __weak id<BeginNewGameDelegate> _delegate;
    __weak UIButton * _share;
    __weak UIButton * _restart;
    __weak UIImageView * _gameOverTitle;
    UIImage * _levelImage;
    enum PieceState _level;
    NSString * _titleStr;
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
@synthesize titleStr = _titleStr;
@synthesize level = _level;
@synthesize levelImage = _levelImage;

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

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    [_levelLabel setText:_titleStr];
}

- (void)setLevelImage:(UIImage *)levelImage
{
    _levelImage = levelImage;
    _imageView.image = _levelImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.94 blue:0.81 alpha:1];
    [_scoreLabel setText:[NSString stringWithFormat:@"%d",_score]];
    [_levelLabel setText:_titleStr];
    _imageView.image = _levelImage;
    
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
    // TODO:
    NSString * sharedName;
    switch (_level) {
        case StateNone:
        {
            sharedName = shareLevelA;
            break;
        }
        case StateA:
        {
            sharedName = shareLevelA;
            break;
        }
        case StateB:
        {
            sharedName = shareLevelB;
            break;
        }
        case StateC:
        {
            sharedName = shareLevelC;
            break;
        }
        case StateD:
        {
            sharedName = shareLevelD;
            break;
        }
        case StateE:
        {
            sharedName = shareLevelE;
            break;
        }
        case StateF:
        {
            sharedName = shareLevelF;
            break;
        }
        case StateG:
        {
            sharedName = shareLevelG;
            break;
        }
        case StateH:
        {
            sharedName = shareLevelH;
            break;
        }
        case StateI:
        {
            sharedName = shareLevelI;
            break;
        }
        case StateJ:
        {
            sharedName = shareLevelJ;
            break;
        }
        case StateK:
        {
            sharedName = shareLevelK;
            break;
        }
        case StateL:
        {
            sharedName = shareLevelL;
            break;
        }
        default:
        {
            sharedName = shareLevelL;
            break;
        }
    }
    UIImage * sharedImage = [Utilies addTextInImage:[UIImage imageNamed:sharedName] withText:[NSString stringWithFormat:@"%d", _score]];
    [self shareThingsToSocialMedia:((UIViewController *)_delegate) text:nil Image:sharedImage delegate:nil];
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
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina,UMShareToQQ, nil]
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
