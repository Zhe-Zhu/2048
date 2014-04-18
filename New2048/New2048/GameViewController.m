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
    __weak DMAdView * _dmAdView;
}

@property(nonatomic, weak) IBOutlet UILabel * score;
@property(nonatomic, weak) IBOutlet UIButton* option;
@property(nonatomic, weak) IBOutlet UIImageView* gameBackgroundImageView;
@property(nonatomic, weak) DMAdView *dmAdView;


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
    
    // add ad view
    [self initDmAdView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
    [_dmAdView removeFromSuperview];
}

- (void)initDmAdView
{
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // 创建广告视图，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    // Creat advertisement view please get your own ID from domob website  56OJyM1ouMGoULfJaL   16TLwebvAchkAY6iOMd734jz
    CGSize adSize = DOMOB_AD_SIZE_320x50;
    DMAdView *dmView = [[DMAdView alloc] initWithPublisherId:@"56OJwtc4uNFRVtBlad"
                                          placementId:@"16TLuhYlApN9ANUku_8hNMSi"
                                                 size:adSize];
    _dmAdView = dmView;
    
    // 设置广告视图的位置
    // Set the frame of advertisement view
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    _dmAdView.frame = CGRectMake(0, winSize.height - 50, 320, 50);
    _dmAdView.delegate = self;
    _dmAdView.rootViewController = self; // set RootViewController
    [self.view addSubview:_dmAdView];
    
    //TODO: bugs need to be fixed
    //[_dmAdView loadAd]; // start load advertisement
}

#pragma mark -
#pragma mark DMAdView delegate

// 成功加载广告后，回调该方法
// This method will be used after load successfully
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] success to load ad.");
}

// 加载广告失败后，回调该方法
// This method will be used after load failed
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"[Domob Sample] fail to load ad. %@", error);
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器
// When will be showing a Modal View, this method will be called. Such as open built-in browser
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will present modal view.");
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
// When presented Modal View is closed, this method will be called. Such as built-in browser is closed
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] did dismiss modal view.");
}

// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
// When the result of the user's actions (such as clicking download class advertising, you need to jump to the Store), need to leave the current application, this method will be called
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will enter background.");
}

@end
