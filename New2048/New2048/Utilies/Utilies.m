//
//  Utilies.m
//  New2048
//
//  Created by Chen Xiangwen on 21/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "Utilies.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation Utilies

+ (void)playSound:(NSString *)soundName
{
    SystemSoundID soundID;
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:soundName withExtension:@"wav"];
    OSStatus error = AudioServicesCreateSystemSoundID( (__bridge CFURLRef)(fileUrl), &soundID);
    NSLog(@"%d", error);
    if (error == kAudioServicesNoError) {
        AudioServicesPlaySystemSound(soundID);
    }
    
}

@end
