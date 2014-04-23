//
//  Utilies.m
//  New2048
//
//  Created by Chen Xiangwen on 21/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "Utilies.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation Utilies

+ (void)playSound:(NSString *)soundName
{
    SystemSoundID soundID;
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:soundName withExtension:@"wav"];
    OSStatus error = AudioServicesCreateSystemSoundID( (__bridge CFURLRef)(fileUrl), &soundID);
    //NSLog(@"%d", error);
    if (error == kAudioServicesNoError) {
        AudioServicesPlaySystemSound(soundID);
    }
    
}

+ (BOOL)isChineseUser
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *iosCC = [carrier isoCountryCode];
    NSString *countryName = nil;
    if (iosCC != nil){
        countryName = [iosCC uppercaseString];
    }
    else{
        //NSLog(@"No country code!");
    }
    
    // ipad如果没有sim卡, 也是无法拿到countryName的
    if ([countryName isEqualToString:@"CN"]) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
