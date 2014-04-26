//
//  Utilies.h
//  New2048
//
//  Created by Chen Xiangwen on 21/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilies : NSObject

+ (void)playSound:(NSString *)soundName;
+ (BOOL)isChineseUser;
+ (UIImage *)addTextInImage:(UIImage *)image withText:(NSString *)text;
@end
