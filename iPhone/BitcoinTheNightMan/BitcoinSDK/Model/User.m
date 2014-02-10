//
//  User.m
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic userFavicon,nickname,canBeSpeak,speakInterval;

+ (NSString *)parseClassName
{
    return @"_User";
}

@end
