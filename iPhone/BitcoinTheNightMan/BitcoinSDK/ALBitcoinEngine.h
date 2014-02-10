//
//  ALBitcoinEngine.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALBitcoinConfig.h"

#define KEY @"F7CCEDAF-3003-46CC-9303-2DFFD509551C"
#define SECRET @"d9e1468ad367cec246c0bfe5b5f43ccf80aef4c67f943f17a70ca6fb129aa528"

@class Coin;

@interface ALBitcoinEngine : NSObject

+ (instancetype)defauleEngine;

@property (nonatomic, readonly) NSMutableArray *coins;


#pragma mark - 用户
@property (nonatomic, readonly) User *user;

- (BOOL)version:(NSString *)VerNo;

- (BOOL)checkBan;

- (void)cancelAllRquest;

//登录
- (void)logInWithBlock:(PFBooleanResultBlock)resultBlock;

//注册
- (void)signUpWithUserName:(NSString *)theUserName
               andPassword:(NSString *)thePassword
                  nickname:(NSString *)nickname
                     block:(PFBooleanResultBlock)resultBlock;

//登陆
- (void)logInWithUserName:(NSString *)theUserName
              andPassword:(NSString *)thePassword
                    block:(PFBooleanResultBlock)resultBlock;

//登出
- (void)logOut;

//是否登录
- (BOOL)isLoggedIn;

#pragma mark - 预警
//关注货币
- (void)faviconCoin:(Coin *)theCoin block:(PFBooleanResultBlock)resultBlock;

//取消关注货币
- (void)unfaviconCoin:(Coin *)theCoin block:(PFBooleanResultBlock)resultBlock;

//获取我关注的货币
- (void)getMyFaviconCoinWithBlock:(PFArrayResultBlock)resultBlock;

//设置货币提醒
- (void)setPushRangeWithCoin:(Coin *)theCoin fromValue:(double)minValue toValue:(double)maxValue isPush:(BOOL)isPush block:(PFBooleanResultBlock)resultBlock;

#pragma mark - 货币
//获取货币列表
- (void)getCoinListWithBlock:(PFArrayResultBlock)resultBlock;

//获取 所有币 行情 (未完成)
- (void)getAllCoinMarketWithBlock:(PFArrayResultBlock)resultBlock;

//获取 某币 行情
- (void)getCoinMarketWithCoin:(Coin *)theCoin block:(void(^)(MarketHistory *market,NSError *error))resultBlock;

//获取 某币 深度
- (void)getCoinDepthWithCoin:(Coin *)theCoin block:(void(^)(DepthHistory *depth,NSError *error))resultBlock;

//获取 某币 交易
- (void)getCoinTradeWithCoin:(Coin *)theCoin isFirstRequest:(BOOL)firstRequest block:(void(^)(NSArray *tradeList,NSError *error))resultBlock;

//外网币 (未完成)
- (void)getCoinMarket2WithCoin:(Coin *)theCoin block:(void(^)(MarketData *market,NSError *error))resultBlock;

//btc-e
- (void)btcUsdWithBlock:(AVDictionaryResultBlock)resultBlock;

//motgox
- (void)motgoxWithBlock:(AVDictionaryResultBlock)resultBlock;

//btc38
/**
 *货币行情
 */
- (void)getCoinsTrickFromBtc38:(AVDictionaryResultBlock)block;

#pragma mark - 聊天
//获取 板块列表
- (void)getForumsWithBlock:(void(^)(NSArray *forumList,NSError *error))resultBlock;

//获取 某板块内的评论
- (void)getThreadsWithForum:(Forum *)theForum lastThread:(Thread *)theThread block:(void(^)(NSArray *threadList,NSError *error))resultBlock;

//发送 消息
- (void)postMessageToForum:(Forum *)theForum message:(NSString *)theMess block:(PFBooleanResultBlock)resultBlock;



@end
