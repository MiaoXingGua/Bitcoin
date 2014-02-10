//
//  Forum.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-12-12.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Forum : AVObject <AVSubclassing>
@property  NSInteger numberOfMember;
@property  NSString *name;
@end
