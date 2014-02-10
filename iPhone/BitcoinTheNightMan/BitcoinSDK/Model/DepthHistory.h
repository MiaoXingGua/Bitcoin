//
//  DepthHistory.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-12-5.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@class Coin;
@interface DepthHistory : AVObject <AVSubclassing>
//@property (nonatomic, retain) NSString *coin1;
//@property (nonatomic, retain) NSString *coin2;

@property (nonatomic ,retain) Coin *coin;
@property (nonatomic, retain) NSArray *askCommission;
@property (nonatomic, retain) NSArray *askPrice;
@property (nonatomic, retain) NSArray *bidCommission;
@property (nonatomic, retain) NSArray *bidPrice;
@end
