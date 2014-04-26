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
#import "Global.h"

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

+ (UIImage *)addTextInImage:(UIImage *)image withText:(NSString *)text
{
    UIColor * textColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    UIFont * font = [UIFont fontWithName:@"Verdana-Bold" size:38];
    CGSize size = CGSizeMake(200, MAXFLOAT);
    CGSize  actualsize;
    if (IS_OS_7_OR_LATER) {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        actualsize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    }
    else
    {
        actualsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    CGRect rect = CGRectMake((320 - actualsize.width) / 2, 77 - actualsize.height / 2, actualsize.width, actualsize.height);
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * dictionary = @{NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: textStyle,
                                  NSForegroundColorAttributeName: textColor};
    [text drawInRect:rect withAttributes:dictionary];
    UIImage * myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

@end
