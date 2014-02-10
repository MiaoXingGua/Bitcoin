//
//  ALBitcoinSDK.m
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "ALBitcoinSDK.h"

@implementation ALBitcoinSDK

+ (void)registerLKSDK
{
    [User registerSubclass];
    [UserFavicon registerSubclass];
    [Coin registerSubclass];
    [TradeHistory registerSubclass];
    [MarketHistory registerSubclass];
    [DepthHistory registerSubclass];
    [Forum registerSubclass];
    [Thread registerSubclass];
}

@end
