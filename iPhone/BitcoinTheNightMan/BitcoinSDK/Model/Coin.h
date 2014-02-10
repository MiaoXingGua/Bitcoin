//
//  Coin.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Coin : AVObject <AVSubclassing>
@property (nonatomic ,retain) NSString *name;
@property (nonatomic, retain) AVFile *icon;
@property (nonatomic ,retain) NSString *coin1;
@property (nonatomic ,retain) NSString *coin2;

@property (nonatomic, retain) NSString *type;//cryptsy bter
@property (nonatomic, assign) NSInteger marketid;
@end
