//
//  OptionViewController.m
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "OptionViewController.h"

@interface OptionViewController ()

- (IBAction)resumeGame:(id)sender;
- (IBAction)anotherGame:(id)sender;
- (IBAction)rate:(id)sender;

@end

@implementation OptionViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resumeGame:(id)sender
{
}

- (IBAction)anotherGame:(id)sender
{
}

- (IBAction)rate:(id)sender
{
    //TODO: change AppID
    int appId = 830277724;
    if (!IS_OS_7_OR_LATER) {
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:[NSNumber numberWithInteger: appId]};
        [storeViewController loadProductWithParameters:parameters completionBlock:nil];
        storeViewController.delegate = self;
        [self presentViewController:storeViewController animated:YES completion:nil];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/app/id%d",appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark  --SKStoreProductViewControllerDelegate Method--
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    //
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
