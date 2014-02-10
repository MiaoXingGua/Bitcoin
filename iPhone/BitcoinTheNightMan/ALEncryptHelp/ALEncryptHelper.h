//
//  ALEncryptHelper.h
//  BitcoinTheNightMan
//
//  Created by Albert on 13-12-8.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALEncryptHelper : NSObject

@end


@interface NSString (ALEncryptHelper)

//16位MD5加密方式
- (NSString *)md5_16Bit_String;
//32位MD5加密方式
- (NSString *)md5_32Bit_String;

//sha1加密方式
- (NSString *)sha1String;

//sha256加密方式
- (NSString *)sha256String;

//sha384加密方式
- (NSString *)sha384String;

//sha512加密方式
- (NSString*)sha512String;

//sha512加密方式
- (NSString*)sha512StringWithSecret:(NSString *)secret;

@end