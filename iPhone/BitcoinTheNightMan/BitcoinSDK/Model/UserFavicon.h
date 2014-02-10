//
//  UserFavicon.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@class User;
@class Coin;
@interface UserFavicon : AVObject <AVSubclassing>
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Coin *coin;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;
@property (nonatomic, assign) BOOL isPush;
@end
