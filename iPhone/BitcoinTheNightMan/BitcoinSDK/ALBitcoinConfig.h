//
//  ALBitcoinConfig.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#ifndef BitcoinTheNightMan_ALBitcoinConfig_h
#define BitcoinTheNightMan_ALBitcoinConfig_h

#import <AVOSCloud/AVOSCloud.h>
#import "Coin.h"
#import "User.h"
#import "UserFavicon.h"
#import "TradeHistory.h"
#import "MarketHistory.h"
#import "DepthHistory.h"
#import "MarketData.h"
#import "Forum.h"
#import "Thread.h"

#define ALERROR(_domain,_code,_error) !_error ? ([NSError errorWithDomain:_domain code:_code userInfo:@{@"code":[NSNumber numberWithInteger:_code],@"error":[NSNull null]}]) : ([NSError errorWithDomain:_domain code:_code userInfo:@{@"code":[NSNumber numberWithInteger:_code],@"error":_error}])

#define TID_TIME_OUT 60*1
#define REQUEST_DEFAULE_TIME_OUT 25

#define ERROR_CODE_KEY          @"alparse"                       //ERROR的domain
#define ERROR_CODE_OF_ALREADY_SUPPORT                           120001 //该用户已经赞过该帖
#define ERROR_CODE_OF_ALREADY_FAVICON                           120002 //该用户已经收藏该帖
#define ERROR_CODE_OF_CREDITS_IS_NOT_ENOUGH                     120003 //积分不足
#define ERROR_CODE_OF_YOU_ARE_NOT_THE_THEAD_POSTUSER            120004 //你不是该帖子的作者
#define ERROR_CODE_OF_YOU_ARE_NOT_THE_POST_POSTUSER             120005 //你不是该回复的作者
#define ERROR_CODE_OF_YOU_ARE_NOT_THE_COMMENT_POSTUSER          120006 //你不是该评论的作者
#define ERROR_CODE_OF_THE_POST_IS_NOT_IN_THE_THREAD             120007 //这个post不数据这个thread
#define ERROR_CODE_OF_THE_POST_IS_NOT_SUPPORT_YOUSELF_POST      120008 //您不能赞您自己发的回复
#define ERROR_CODE_OF_THE_THREAD_IS_NOT_EXIST    120009 //此主题已不存在
#define ERROR_CODE_OF_THE_POST_IS_NOT_EXIST      120010 //此回复已不存在
#define ERROR_CODE_OF_THE_POST_IS_NOT_COMMENT      120011 //此评论已不存在
#define ERROR_CODE_OF_TOKEN_IS_EXIST                           120021 //token已经被使用

#endif
