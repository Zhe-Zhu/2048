//
//  OptionViewController.m
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "OptionViewController.h"

@interface OptionViewController ()
{
    __weak id<BeginNewGameDelegate> _delegate;
    
    __weak UIButton * _restartGame;
    __weak UIButton * _rate;
    __weak UIButton * _continueGame;
    __weak UIImageView * _settingTitle;
}

@property(nonatomic, weak) IBOutlet UIButton * restartGame;
@property(nonatomic, weak) IBOutlet UIButton * rate;
@property(nonatomic, weak) IBOutlet UIButton * continueGame;;
@property(nonatomic, weak) IBOutlet UIImageView * settingTitle;

- (IBAction)resumeGame:(id)sender;
- (IBAction)anotherGame:(id)sender;
- (IBAction)rate:(id)sender;

@end

@implementation OptionViewController

@synthesize delegate = _delegate;
@synthesize restartGame = _restartGame;
@synthesize rate = _rate;
@synthesize settingTitle = _settingTitle;
@synthesize continueGame = _continueGame;

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
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.94 blue:0.81 alpha:1];
    
    [_settingTitle setImage:[UIImage imageNamed:NSLocalizedString(@"SettingTitle", nil)]];
    [_continueGame setImage:[UIImage imageNamed:NSLocalizedString(@"ContinueGame", nil)] forState:UIControlStateNormal];
    [_rate setImage:[UIImage imageNamed:NSLocalizedString(@"Rate", nil)] forState:UIControlStateNormal];
    [_restartGame setImage:[UIImage imageNamed:NSLocalizedString(@"RestartGame", nil)] forState:UIControlStateNormal];
    
    if (IS_IPHONE5) {
        _restartGame.center = CGPointMake(160, IPhone5Height - 165);
        _rate.center = CGPointMake(160, IPhone5Height - 92);
    }
    else
    {
        _restartGame.center = CGPointMake(160, IPhone4Height - 165);
        _rate.center = CGPointMake(160, IPhone4Height - 92);
    }

    //self.view.userInteractionEnabled = NO;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resumeGame:(id)sender
{
    self.view.alpha = 0.0;
    [self.view removeFromSuperview];
}

- (IBAction)anotherGame:(id)sender
{
    [_delegate beginNewGame];
    self.view.alpha = 0.0;
    [self.view removeFromSuperview];
}

- (IBAction)rate:(id)sender
{
    int appId = 866715231;
    if (!IS_OS_7_OR_LATER && IS_OS_6_OR_LATER) {
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:[NSNumber numberWithInteger: appId]};
        [storeViewController loadProductWithParameters:parameters completionBlock:nil];
        storeViewController.delegate = self;
        [self presentViewController:storeViewController animated:YES completion:nil];
    }
    else
    {
        NSString *str = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%d",appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark  --SKStoreProductViewControllerDelegate Method--
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    //
    [viewController dismissViewControllerAnimated:YES completion:nil];
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
