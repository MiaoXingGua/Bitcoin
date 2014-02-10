//
//  User.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class UserFavicon;

@interface User : AVUser <AVSubclassing>

@property (nonatomic, retain) AVRelation *userFavicon;

@property (nonatomic, retain) NSString *nickname;

@property (nonatomic, assign) NSTimeInterval speakInterval;

@property (nonatomic, assign) BOOL canBeSpeak;

@end
