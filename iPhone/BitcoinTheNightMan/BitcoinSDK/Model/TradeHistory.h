//
//  TradeHistory.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-30.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@class Coin;
@interface TradeHistory : AVObject <AVSubclassing>
@property (nonatomic, retain) NSString *date;//时间戳
//@property (nonatomic, retain) NSString *coin1;
//@property (nonatomic, retain) NSString *coin2;
@property (nonatomic ,retain) Coin *coin;
@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, assign) double amount;
@property (nonatomic, assign) double price;
@end
