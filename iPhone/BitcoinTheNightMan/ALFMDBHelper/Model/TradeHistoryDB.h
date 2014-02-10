//
//  TradeHistoryDB.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-12-2.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "ALDBObject.h"

@interface TradeHistoryDB : ALDBObject
@property (nonatomic, retain) NSString *date;//时间戳
@property (nonatomic, retain) NSString *coin1;
@property (nonatomic, retain) NSString *coin2;
@property (nonatomic, assign) int tid;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *price;
@end
