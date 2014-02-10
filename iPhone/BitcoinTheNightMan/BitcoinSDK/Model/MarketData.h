//
//  MarketData.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-12-9.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@class Coin;
@interface MarketData : AVObject <AVSubclassing>
@property (nonatomic,retain) Coin *coin;

@property (nonatomic,retain) NSString *marketid;
@property (nonatomic,retain) NSDate *lastTradeTime;
@property (nonatomic,assign) double lastTradePrice;
@property (nonatomic,assign) double volume;

/*
 买单:
 
 {
    price = "0.00017756";       //价格
    quantity = "100.00000000";  //数量
    total = "0.01775600";       //总计
 },
 
 */
@property (nonatomic,retain) NSArray *buyOrders;

/*
 卖单:
 
 {
    id = 6133448;                   //订单号
    price = "0.00018275";           //价格
    quantity = "100.00000000";      //数量
    time = "2013-12-08 23:22:18";   //时间
    total = "0.01827500";           //总计
 },
 
 */
@property (nonatomic,retain) NSArray *sellOrders;


/*
 最近交易:
 
 {
    id = 6133448;                  //订单号
    price = "0.00018275";          //价格
    quantity = "100.00000000";     //数量
    time = "2013-12-08 23:22:18";  //时间
    total = "0.01827500";          //总计
 },
 
 */
@property (nonatomic,retain) NSArray *recentTrades;

@end
