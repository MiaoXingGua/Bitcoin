//
//  MarketHistory.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-12-5.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class Coin;
@interface MarketHistory : AVObject <AVSubclassing>

//@property (nonatomic ,retain) NSString *coin1;
//@property (nonatomic ,retain) NSString *coin2;
@property (nonatomic ,retain) Coin *coin;
@property (nonatomic ,assign) double last;
@property (nonatomic ,assign) double vol1;
@property (nonatomic ,assign) double vol2;
@property (nonatomic ,assign) double low;
@property (nonatomic ,assign) double high;
@property (nonatomic ,assign) double avg;
@property (nonatomic ,assign) double buy;
@property (nonatomic ,assign) double sell;

@end
