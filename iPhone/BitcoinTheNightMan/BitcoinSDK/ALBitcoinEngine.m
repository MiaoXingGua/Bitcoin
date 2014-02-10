//
//  ALBitcoinEngine.m
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "ALBitcoinEngine.h"
#import "AVRelation+AddUniqueObject.h"
//#import "TradeHistoryDB.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"
#import "SSKeychain.h"

#define PHONE_CODE_SERVICE @"com.bitcon.phoneCodeService"
#define PHONE_CODE_ACCOUNT @"com.bitcon.phoneCodeAccount"

static ALBitcoinEngine *defauleEngine = nil;

@interface ALBitcoinEngine()
@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) NSMutableDictionary *lastTids;
@end



@implementation ALBitcoinEngine

#pragma mark - 基本
- (void)dealloc
{
    [_queue release];
    [_lastTids release];
    [_coins release];
    
    [super dealloc];
}

+ (instancetype)defauleEngine
{
    if (!defauleEngine)
    {
        defauleEngine = [[ALBitcoinEngine alloc] init];
        defauleEngine.coins = [NSMutableArray array];
        defauleEngine.queue = [[[ASINetworkQueue alloc] init] autorelease];
        [defauleEngine.queue go];
        defauleEngine.lastTids = [NSMutableDictionary dictionary];

    }
    return defauleEngine;
}


- (void)setCoins:(NSMutableArray *)coins
{
    [_coins release];
    _coins = [coins retain];
}

#pragma mark - 版本控制
- (BOOL)version:(NSString *)VerNo
{
    return [[AVCloud callFunction:@"version" withParameters:@{@"verNo":VerNo} error:nil] boolValue];
}

- (BOOL)checkBan
{
    AVInstallation *install = [AVInstallation currentInstallation];
    [install refresh];
    return [[install objectForKey:@"isBan"] boolValue];
}

- (void)cancelAllRquest
{
    [self.queue cancelAllOperations];
}

#pragma mark - 用户
- (User *)user
{
    return [User currentUser];
}

//登陆
- (void)logInWithBlock:(PFBooleanResultBlock)resultBlock
{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneCode"];
//    NSString *phoneCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneCode"];
    
    __block typeof(self) bself = self;
    
    NSString *phoneCode =  [SSKeychain passwordForService:PHONE_CODE_SERVICE account:PHONE_CODE_ACCOUNT];
    
    if (phoneCode)
    {
        [AVUser logInWithUsernameInBackground:phoneCode password:phoneCode block:^(AVUser *user, NSError *error) {
            if (user && !error)
            {
                if (resultBlock)
                {
                    resultBlock(YES,nil);
                    //[resultBlock release];
                }
                
                AVInstallation *currentInstallation = [AVInstallation currentInstallation];
                [currentInstallation setObject:[AVUser currentUser] forKey:@"user"];
                [currentInstallation saveEventually];
            }
            else
            {
                [bself logInWithBlock:resultBlock];
                //[resultBlock release];
            }
        }];
    }
    else
    {
        [AVCloud callFunctionInBackground:@"register" withParameters:nil block:^(id object, NSError *error) {
            
            if (object && !error)
            {
                NSString *phoneCode = [object valueForKey:@"guid"];
//                [[NSUserDefaults standardUserDefaults] setObject:phoneCode forKey:@"phoneCode"];
                BOOL keyChain = [SSKeychain setPassword:phoneCode forService:PHONE_CODE_SERVICE account:PHONE_CODE_ACCOUNT];
                
                if (keyChain)
                {
                    
                    [AVUser logInWithUsernameInBackground:phoneCode password:phoneCode block:^(AVUser *user, NSError *error) {
                        
                        if (user && !error)
                        {
                            if (resultBlock)
                            {
                                resultBlock(YES,nil);
                                //[resultBlock release];
                            }
                            
                            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
                            [currentInstallation setObject:[AVUser currentUser] forKey:@"user"];
                            [currentInstallation saveEventually];
                        }
                        else
                        {
                            [bself logInWithBlock:resultBlock];
                            //[resultBlock release];
                        }
                    }];
                }
                else
                {
                    [bself logInWithBlock:resultBlock];
                    //[resultBlock release];
                }
            }
            else
            {
                [bself logInWithBlock:resultBlock];
                //[resultBlock release];
            }
        }];
    }
}


//注册
- (void)signUpWithUserName:(NSString *)theUserName
               andPassword:(NSString *)thePassword
                  nickname:(NSString *)nickname
                     block:(PFBooleanResultBlock)resultBlock
{

    User *user = (User *)[User user];
    
    user.username = [theUserName lowercaseString];
    user.password = thePassword;
    user.nickname = nickname;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded && !error)
        {
            if (resultBlock)
            {
                resultBlock(YES,nil);
                //[resultBlock release];
            }
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation setObject:[AVUser currentUser] forKey:@"user"];
            [currentInstallation saveEventually];
        }
        else
        {
            if (resultBlock)
            {
                resultBlock(succeeded,error);
                //[resultBlock release];
            }
        }
    }];
}

//登录
- (void)logInWithUserName:(NSString *)theUserName
              andPassword:(NSString *)thePassword
                    block:(PFBooleanResultBlock)resultBlock
{
    [AVUser logInWithUsernameInBackground:theUserName password:thePassword block:^(AVUser *user, NSError *error) {
        
        if (user && !error)
        {
            if (resultBlock)
            {
                resultBlock(YES,nil);
                //[resultBlock release];
            }
            
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            [currentInstallation setObject:[AVUser currentUser] forKey:@"user"];
            [currentInstallation saveEventually];
        }
        else
        {
            if (resultBlock)
            {
                resultBlock(NO,error);
                //[resultBlock release];
            }
        }
    }];
}

//登出
- (void)logOut
{
    [AVUser logOut];
}

//是否已登录
- (BOOL)isLoggedIn
{
    return [AVUser currentUser].isAuthenticated && self.user;
}

#pragma mark - 预警
- (void)faviconCoin:(Coin *)theCoin block:(PFBooleanResultBlock)resultBlock
{
    if (!self.user || !theCoin)
    {
        if (resultBlock)
        {
            resultBlock(NO,ALERROR(@"", -1, @"请先先登录"));
        }
    }
    
    AVQuery *uFQ = [UserFavicon query];
    [uFQ whereKey:@"user" equalTo:self.user];
    [uFQ whereKey:@"coin" equalTo:theCoin];
    [uFQ getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        if (!error && object)
        {
            if (resultBlock)
            {
                resultBlock(NO,error);
                //[resultBlock release];
            }
        }
        else
        {
            UserFavicon *uF = [UserFavicon object];
            uF.user = self.user;
            uF.coin = theCoin;
            uF.isPush = NO;
            [uF saveInBackgroundWithBlock:resultBlock];
            //[resultBlock release];
        }
    }];
}


- (void)unfaviconCoin:(Coin *)theCoin block:(PFBooleanResultBlock)resultBlock
{
    if (!self.user || !theCoin) return;
    
    AVQuery *uFQ = [UserFavicon query];
    [uFQ whereKey:@"user" equalTo:self.user];
    [uFQ whereKey:@"coin" equalTo:theCoin];
    [uFQ getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error && object)
        {
            [object deleteInBackgroundWithBlock:resultBlock];
            //[resultBlock release];
        }
        else
        {
            if (resultBlock)
            {
                resultBlock(NO,error);
                //[resultBlock release];
            }
        }
    }];
}

- (void)getMyFaviconCoinWithBlock:(PFArrayResultBlock)resultBlock
{
    if (!self.user) return;
    
    AVQuery *uFQ = [UserFavicon query];
    [uFQ whereKey:@"user" equalTo:self.user];
    [uFQ includeKey:@"coin"];
    [uFQ findObjectsInBackgroundWithBlock:resultBlock];
}

- (void)setPushRangeWithCoin:(Coin *)theCoin fromValue:(double)minValue toValue:(double)maxValue isPush:(BOOL)isPush block:(PFBooleanResultBlock)resultBlock
{
    if (!self.user || !theCoin) return;
    
    AVQuery *uFQ = [UserFavicon query];
    [uFQ whereKey:@"user" equalTo:self.user];
    [uFQ whereKey:@"coin" equalTo:theCoin];
    [uFQ includeKey:@"coin"];
    [uFQ getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error && object)
        {
            UserFavicon *uF = (UserFavicon *)object;
            uF.minValue = minValue;
            uF.maxValue = maxValue;
            uF.isPush = isPush;
            [uF saveEventually:resultBlock];
            //[resultBlock release];
        }
        else
        {
            if (resultBlock)
            {
                resultBlock(NO,error);
                //[resultBlock release];
            }
        }
    }];
}

#pragma mark - 货币
- (void)getCoinListWithBlock:(PFArrayResultBlock)resultBlock
{
    AVQuery *coinQ = [Coin query];
    coinQ.limit = 1000;
    [coinQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.coins addObjectsFromArray:objects];
        if (resultBlock)
        {
            resultBlock(objects,error);
            //[resultBlock release];
        }
    }];
}


//获取 所有币 行情
- (void)getAllCoinMarketWithBlock:(PFArrayResultBlock)resultBlock
{
     
}


//获取 某币 行情
- (void)getCoinMarketWithCoin:(Coin *)theCoin block:(void(^)(MarketHistory *market,NSError *error))resultBlock
{
    if (![theCoin.type isEqualToString:@"bter"])
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
            //[resultBlock release];
        }
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://cn.bter.com/api/1/ticker/%@_%@",theCoin.coin1,theCoin.coin2];
    [self _requestWithUrl:urlStr timeOut:0 block:^(NSDictionary *dict, NSError *error) {
        if (resultBlock)
        {
            if (dict && !error)
            {
                if (dict[@"result"])
                {
                    MarketHistory *market = [MarketHistory object];
                    market.last = [[dict valueForKey:@"last"] doubleValue];
                    market.high = [[dict valueForKey:@"high"] doubleValue];
                    market.low = [[dict valueForKey:@"low"] doubleValue];
                    market.avg = [[dict valueForKey:@"avg"] doubleValue];
                    market.sell = [[dict valueForKey:@"sell"] doubleValue];
                    market.buy = [[dict valueForKey:@"buy"] doubleValue];
                    market.coin = theCoin;
                    market.vol1 = [[dict valueForKey:[NSString stringWithFormat:@"vol_%@",theCoin.coin1]] doubleValue];
                    market.vol2 = [[dict valueForKey:[NSString stringWithFormat:@"vol_%@",theCoin.coin2]] doubleValue];
                    
                    resultBlock(market,nil);
                    //[resultBlock release];
                    
                }
                else
                {
                    resultBlock(nil,nil);
                    //[resultBlock release];
                }
                
            }
            else
            {
                resultBlock(nil,error);
                //[resultBlock release];
            }
        }
    }];
}

//获取 某币 深度
- (void)getCoinDepthWithCoin:(Coin *)theCoin block:(void(^)(DepthHistory *depth,NSError *error))resultBlock
{
    
    if (![theCoin.type isEqualToString:@"bter"])
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://cn.bter.com/api/1/depth/%@_%@",theCoin.coin1,theCoin.coin2];
    [self _requestWithUrl:urlStr timeOut:6 block:^(NSDictionary *dict, NSError *error) {
        if (resultBlock)
        {
            if (dict && !error)
            {
                if (dict[@"result"])
                {
                    DepthHistory *depth = [DepthHistory object];
                    depth.coin = theCoin;
                    
                    NSMutableArray *askCommission = [NSMutableArray array];
                    NSMutableArray *askPrice = [NSMutableArray array];
                    for (NSArray *ask in dict[@"asks"])
                    {
                        [askCommission addObject:ask[0]];
                        [askPrice addObject:ask[1]];
                    }
                    
                    
                    NSMutableArray *bidCommission = [NSMutableArray array];
                    NSMutableArray *bidPrice = [NSMutableArray array];
                    for (NSArray *bid in dict[@"bids"])
                    {
                        [bidCommission addObject:bid[0]];
                        [bidPrice addObject:bid[1]];
                    }
                    
                    depth.askCommission = askCommission;
                    depth.askPrice = askPrice;
                    depth.bidCommission = bidCommission;
                    depth.bidPrice = bidPrice;
                    
                    resultBlock(depth,nil);
                    //[resultBlock release];
                    
                }
                else
                {
                    resultBlock(nil,nil);
                    //[resultBlock release];
                }
                
            }
            else
            {
                resultBlock(nil,error);
                //[resultBlock release];
            }
        }
    }];
}

//获取 某币 交易
- (void)getCoinTradeWithCoin:(Coin *)theCoin isFirstRequest:(BOOL)firstRequest block:(void(^)(NSArray *tradeList,NSError *error))resultBlock
{
    
    if (!theCoin)
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    if (![theCoin.type isEqualToString:@"bter"])
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    if (firstRequest)
    {
//        NSString *tid = [self.lastTids valueForKey:theCoin.coin1];
        [self.lastTids setValue:nil forKey:theCoin.coin1];
    }
    
    NSDictionary *coinInfo = [self.lastTids valueForKey:theCoin.coin1];
    NSString * lastTid = @"";
    if (coinInfo)
    {
        //tid 不超时
        if ([[NSDate date] timeIntervalSinceDate:coinInfo[@"date"]] <= TID_TIME_OUT)
        {
            lastTid = coinInfo[@"tid"];
        }
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://cn.bter.com/api/1/trade/%@_%@/%@",theCoin.coin1,theCoin.coin2,lastTid];
    
//    NSLog(@"load:tid=%@----urlStr=%@",lastTid,urlStr);
    
    __block typeof (self) bself = self;
    
    [self _requestWithUrl:urlStr timeOut:0 block:^(NSDictionary *dict, NSError *error) {
        
        NSString *tid = nil;
        if (dict && !error)
        {
            NSArray *dataList = [dict valueForKey:@"data"];

            if (dict[@"result"])
            {
                NSMutableArray *tradeList = [NSMutableArray array];
                if (dataList.count > 0)
                {
                    for (int i=dataList.count-1;i>=0;--i)
                    {
                        NSDictionary *data = dataList[i];
                        TradeHistory *trade = [TradeHistory object];
                        trade.coin = theCoin;
                        trade.date = [data valueForKey:@"date"];
                        trade.tid = [data valueForKey:@"tid"];
                        trade.type = [data valueForKey:@"type"];
                        
                        trade.amount = [[data valueForKey:@"amount"] doubleValue];
                        trade.price = [[data valueForKey:@"price"] doubleValue];
                        
                        [tradeList addObject:trade];
                    }
                    
                    if (tradeList.count > 80)
                    {
                        [tradeList removeObjectsInRange:NSMakeRange(80, tradeList.count-80)];
                    }
                    
                    NSLog(@"load:tid=%@----urlStr=%@",lastTid,urlStr);
                    
                    tid = [[dataList lastObject] valueForKey:@"tid"];
                    [bself.lastTids setValue:@{@"tid":tid,@"date":[NSDate date]} forKey:theCoin.coin1];
                    
                    if (resultBlock)
                    {
                        resultBlock(tradeList,nil);
                        //[resultBlock release];
                    }
                }
                else
                {
                    tid = [bself.lastTids valueForKeyPath:[NSString stringWithFormat:@"%@.tid",theCoin.coin1]];
                    [bself.lastTids setValue:@{@"tid":tid,@"date":[NSDate date]} forKey:theCoin.coin1];
                    
                    if (resultBlock)
                    {
                        resultBlock(tradeList,nil);
                        //[resultBlock release];
                    }
                }
            }
            else
            {
                tid = [bself.lastTids valueForKeyPath:[NSString stringWithFormat:@"%@.tid",theCoin.coin1]];
                [bself.lastTids setValue:@{@"tid":tid,@"date":[NSDate date]} forKey:theCoin.coin1];
                
                if (resultBlock)
                {
                    resultBlock(nil,nil);
                    //[resultBlock release];
                }
            }
        }
        else
        {
            tid = [bself.lastTids valueForKeyPath:[NSString stringWithFormat:@"%@.tid",theCoin.coin1]];
            [bself.lastTids setValue:@{@"tid":tid,@"date":[NSDate date]} forKey:theCoin.coin1];
           
            if (resultBlock)
            {
                resultBlock(nil,error);
                //[resultBlock release];
            }
        }

    }];
}


//外网币 (未完成)
- (void)getCoinMarket2WithCoin:(Coin *)theCoin block:(void(^)(MarketData *market,NSError *error))resultBlock
{
    if (![theCoin.type isEqualToString:@"cryptsy"])
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=%d",theCoin.marketid];
    [self _requestWithUrl:urlStr timeOut:0 block:^(NSDictionary *dict, NSError *error) {
        if (resultBlock)
        {
            if (dict && !error)
            {
                if (dict[@"success"])
                {
                    NSDictionary *markets = [dict valueForKeyPath:[NSString stringWithFormat:@"return.markets.%@",[theCoin.coin1 uppercaseString]]];
                    
                    MarketData * market = [MarketData object];
                    market.coin = theCoin;
                    market.marketid = [markets valueForKey:@"marketid"];
                    
                    
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                    
                    //设定时间格式,这里可以设置成自己需要的格式
                    //dateCreated=2013-12-08 23:22:18
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    NSDate *lasttradetime = [dateFormatter dateFromString:[markets valueForKey:@"lasttradetime"]];
                    
                    market.lastTradeTime = lasttradetime;
                    market.lastTradePrice = [[markets valueForKey:@"lasttradeprice"] doubleValue];
                    market.volume = [[markets valueForKey:@"volume"] doubleValue];
                    
                    market.buyOrders = [market valueForKey:@"buyorders"];
                    
                    market.sellOrders = [market valueForKey:@"sellorders"];
                    
                    market.recentTrades = [market valueForKey:@"recenttrades"];
                    
                    resultBlock(market,nil);
                    //[resultBlock release];
                }
                else
                {
                    resultBlock(nil,nil);
                    //[resultBlock release];
                }
                
            }
            else
            {
                resultBlock(nil,error);
                //[resultBlock release];
            }
        }
    }];
}


//btc-e
- (void)btcUsdWithBlock:(AVDictionaryResultBlock)resultBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"https://btc-e.com/api/2/btc_usd/ticker"];
    [self _requestWithUrl:urlStr timeOut:REQUEST_DEFAULE_TIME_OUT block:resultBlock];
}

//motgox
- (void)motgoxWithBlock:(AVDictionaryResultBlock)resultBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"https://data.mtgox.com/api/2/BTCUSD/money/ticker"];
    [self _requestWithUrl:urlStr timeOut:REQUEST_DEFAULE_TIME_OUT block:resultBlock];
}

/**
 *货币行情
 */
- (void)getCoinsTrickFromBtc38:(AVDictionaryResultBlock)block
{
    
}

//通用货币请求
- (void)_requestWithUrl:(NSString *)theUrlStr timeOut:(NSTimeInterval)timeout block:(AVDictionaryResultBlock)resultBlock
{
//    __block AVDictionaryResultBlock block = [resultBlock copy];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:theUrlStr]];
    if (timeout)
    {
        request.timeOutSeconds = timeout;
    }
    else
    {
        request.timeOutSeconds = REQUEST_DEFAULE_TIME_OUT;
    }
    request.numberOfTimesToRetryOnTimeout = 100;
    request.validatesSecureCertificate = NO;
    
    [request setCompletionBlock:^{
        
        NSDictionary *resultInfo = [request.responseString objectFromJSONString];
//        NSLog(@"request.response=%@",resultInfo);
        
        if (resultBlock)
        {
            resultBlock(resultInfo,nil);
            //[resultBlock release];
        }
    }];
    
    [request setFailedBlock:^{
//        NSLog(@"request.error=%@",request.error);
        if (resultBlock)
        {
            resultBlock(nil,request.error);
            //[resultBlock release];
        }
    }];
    
    //    [request startAsynchronous];
    [self.queue addOperation:request];
    
}

#pragma mark - 聊天
//获取 板块列表
- (void)getForumsWithBlock:(void(^)(NSArray *forumList,NSError *error))resultBlock
{
    AVQuery *fQ = [Forum query];
    [fQ findObjectsInBackgroundWithBlock:resultBlock];
}

//获取 某板块内的评论
- (void)getThreadsWithForum:(Forum *)theForum lastThread:(Thread *)theThread block:(void(^)(NSArray *threadList,NSError *error))resultBlock
{
//    void(^block)(NSArray *threadList,NSError *error) = [resultBlock copy];
    
    if (!theForum )
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    AVQuery *tQ = [Thread query];
    [tQ whereKey:@"forum" equalTo:theForum];
    
    if (theThread)
    {
        [tQ whereKey:@"createdAt" greaterThanOrEqualTo:theThread.createdAt];
        [tQ whereKey:@"objectId" notEqualTo:theThread.objectId];
        
    }
    
    [tQ orderByDescending:@"createdAt"];
    tQ.limit = 40;
    
    [tQ includeKey:@"user"];
    [tQ includeKey:@"forum"];
    [tQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableArray *forumList = [NSMutableArray array];
        if (objects && !error)
        {
            [forumList addObjectsFromArray:objects];
            
//            [forumList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                
//                if ([obj1 objectForKey:@"createdAt"] > [obj2 objectForKey:@"createdAt"])
//                {
//                    return 1;
//                }
//                else if ([obj1 objectForKey:@"createdAt"] < [obj2 objectForKey:@"createdAt"])
//                {
//                    return -1;
//                }
//                else
//                {
//                    return 0;
//                }
//                
//            }];
        }

        if (resultBlock)
        {
            resultBlock(forumList,error);
            //[resultBlock release];
        }
    }];
}

//发送 消息
- (void)postMessageToForum:(Forum *)theForum message:(NSString *)theMess block:(PFBooleanResultBlock)resultBlock
{
    if (![self isLoggedIn] || !theForum || !theMess)
    {
        if (resultBlock)
        {
            resultBlock(NO,Nil);
        }
        return;
    }
    Thread *thread = [Thread object];
    thread.forum = theForum;
    thread.message = theMess;
    thread.user = self.user;
    [thread saveInBackgroundWithBlock:resultBlock];
}

@end
