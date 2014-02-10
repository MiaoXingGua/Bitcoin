//
//  Thread.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-12-12.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@class User;
@class Forum;
@interface Thread : AVObject <AVSubclassing>
@property User *user;
@property NSString *message;
@property Forum *forum;
@end
