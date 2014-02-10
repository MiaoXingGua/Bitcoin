//
//  DemoViewController.m
//  BitcoinTheNightMan
//
//  Created by Albert on 13-11-28.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "DemoViewController.h"
#import "JSONKit.h"
#import "XMLReader.h"
#import "XMLWriter.h"
#import "XMLParser.h"
#import <CommonCrypto/CommonDigest.h>
#import "ALBitcoinSDK.h"
#import "ASIHTTPRequest.h"

@interface DemoViewController ()
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UIButton *getKey;
@property (nonatomic,retain) IBOutlet UIWebView *web;

@property (nonatomic, retain) Coin *coin;
@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)testBtn:(id)sender {
    
//    [AVCloud callFunctionInBackground:@"test" withParameters:nil block:^(id object, NSError *error) {
//       
//        NSLog(@"error=%@",error);
//        
//    }];
    
//    [[ALBitcoinEngine defauleEngine] refreashAllTrade];
//    NSArray *array = [[ALBitcoinEngine defauleEngine] getTradeHistoryWithCoin1:@"btc" coin2:@"cny" skip:0 limit:120];
//    NSLog(@"%d",array.count);
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://cn.bter.com/api/1/trade/btc_cny"]];
//    
//    [request setStartedBlock:^{
//        
//        NSLog(@"开始");
//        
//    }];
//    
//    [request setCompletionBlock:^{
//        
//        NSLog(@"成功");
//        
//    }];
//    
//    [request setFailedBlock:^{
//        
//        NSLog(@"失败");
//        
//    }];
//    
//    [request start];
//
//    [self getCoinTradeWithCoin];
    
    BOOL success = [[AVCloud callFunction:@"version" withParameters:@{@"verNo":@"1.0.1"} error:nil] boolValue];
    
    NSLog(@"success=%d",success);
}


- (void)getCoinTradeWithCoin
{
    Coin *coin = [Coin object];
    coin.coin1 = @"btc";
    coin.coin2 = @"cny";
    coin.type = @"bter";
    
    [[ALBitcoinEngine defauleEngine] getCoinTradeWithCoin:coin block:^(NSArray *tradeList, NSError *error) {
       
        if (!error && tradeList.count>0)
        {
//            TradeHistory * trade = tradeList[0];
//            NSLog(@"trade.date=%@",trade.date);
        }
        
        [self getCoinTradeWithCoin];
    }];
}

- (IBAction)loginBtn:(id)sender {

    [[ALBitcoinEngine defauleEngine] logInWithBlock:^(BOOL succeeded, NSError *error) {
       
        NSLog(@"error=%@",error);
        
    }];
}

- (IBAction)faviconBtn:(id)sender {
    
    AVQuery *query = [Coin query];
    [query whereKey:@"coin1" equalTo:@"btc"];
    [query whereKey:@"coin2" equalTo:@"cny"];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        [[ALBitcoinEngine defauleEngine] faviconCoin:object block:^(BOOL succeeded, NSError *error) {
            
            NSLog(@"error=%@",error);
            
        }];
        
    }];

    
}

- (IBAction)unfaviconBtn:(id)sender {
    AVQuery *query = [Coin query];
    [query whereKey:@"coin1" equalTo:@"btc"];
    [query whereKey:@"coin2" equalTo:@"cny"];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        [[ALBitcoinEngine defauleEngine] unfaviconCoin:object block:^(BOOL succeeded, NSError *error) {
            
            NSLog(@"error=%@",error);
            
        }];
        
    }];
}

- (IBAction)getCoinListBtn:(id)sender {
    
    __block typeof (self) bself = self;
    [[ALBitcoinEngine defauleEngine] getCoinListWithBlock:^(NSArray *objects, NSError *error) {
       
        bself.coin = objects[0];
        NSLog(@"coins=%@",[objects[0] objectForKey:@"name"]);
        
    }];
}

- (IBAction)goAPIBtn:(id)sender {
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cn.bter.com/myaccount/apikeys"]]];
}

- (IBAction)getKayBtn:(id)sender {
    
    
//    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cn.bter.com/myaccount/apikeys"]]];
//    [self.web goBack];
//    [self.web reload];
    //Key: </td><td><input name="key" id="key" size="80" value=" xxxxxx "></td>
    //Secret: </td><td><input name="secret" id="secret" size="80" value=" yyy "></td>
    
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    
    NSString *HTMLSource = [self.web stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    NSLog(@"%@",HTMLSource);
//    [self xml2json:HTMLSource];
    
    NSString *keyHead = [NSString stringWithFormat:@"Key: </td><td><input name=\"key\" id=\"key\" size=\"80\" value=\""];
//    "
    NSString *keyFoot = [NSString stringWithFormat:@"\"></td>"];
    
    NSString *secretHead = [NSString stringWithFormat:@"Secret: </td><td><input name=\"secret\" id=\"secret\" size=\"80\" value=\""];
    NSString *secretFoot = [NSString stringWithFormat:@"\"></td>"];

    NSLog(@"%d",HTMLSource.length);
    NSLog(@"%d",[HTMLSource rangeOfString:keyHead].location);
    NSLog(@"%d",[HTMLSource rangeOfString:keyHead].length);
    NSLog(@"%d",[HTMLSource rangeOfString:keyFoot].location);
    NSLog(@"%d",[HTMLSource rangeOfString:keyFoot].length);
    
    NSString *key = [HTMLSource substringWithRange:NSMakeRange([HTMLSource rangeOfString:keyHead].location+[HTMLSource rangeOfString:keyHead].length, @"F7CCEDAF-3003-46CC-9303-2DFFD509551C".length)];
    
    NSString *secret = [HTMLSource substringWithRange:NSMakeRange([HTMLSource rangeOfString:secretHead].location+[HTMLSource rangeOfString:secretHead].length, @"d9e1468ad367cec246c0bfe5b5f43ccf80aef4c67f943f17a70ca6fb129aa528".length)];
//
    NSLog(@"key=%@ \n secret=%@",key,secret);
    self.textLabel.text = [NSString stringWithFormat:@"key=%@ \n secret=%@",key,secret];
//    NSPredicate *keyQuery = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] '%@' AND SELF ENDSWITH[cd] '%@'",keyHead,keyFoot];//以 c 开始 以r 结束  包含 ?
    
//    NSString *keyRegexStr = [NSString stringWithFormat:@"^(%@).+(%@)$",keyHead,keyFoot];
//    
//    NSString *secretRegexStr = [NSString stringWithFormat:@"^(%@).+(%@)$",secretHead,secretFoot];
////    NSPredicate *keyPre= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", keyRegex];
////    NSPredicate *secretPre= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", secretRegex];
//    
//    NSRegularExpression *keyRegex = [NSRegularExpression regularExpressionWithPattern:keyRegexStr options:NSRegularExpressionCaseInsensitive error:nil];
//    
//    NSRegularExpression *secretRegex = [NSRegularExpression regularExpressionWithPattern:secretRegexStr options:NSRegularExpressionCaseInsensitive error:nil];
//    
//    NSLog(@"key = %@",[keyRegex matchesInString:keyRegexStr options:0 range:NSMakeRange(0, [keyRegexStr length])][0]);
//    
//    NSLog(@"secret = %@",[secretRegex matchesInString:secretRegexStr options:0 range:NSMakeRange(0, [secretRegexStr length])][0]);

    
//    NSPredicate *secretQuery = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] '%@' AND SELF ENDSWITH[cd] '%@'",secretHead,secretFoot];
//    NSRegularExpression;
//    NSLog(@"key = %@",[HTMLSource filteredArrayUsingPredicate:keyQuery][0]);
//    NSLog(@"secret = %@",[HTMLSource filteredArrayUsingPredicate:secretQuery][0]);
}

- (NSString*) getSha512String:(NSString*)srcString {
    
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    
    CC_SHA512(data.bytes, data.length, digest);
    
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
    
}

-(void)xml2json:(NSString *)xmlStr
{
    
    NSLog(@"xmlStr=/n%@",xmlStr);
    
    // XML Data
	NSData *xmlData = [xmlStr dataUsingEncoding:NSUTF8StringEncoding];

	
	XMLParser *xmlParser = [[[XMLParser alloc] init] autorelease];
	
	[xmlParser parseData:xmlData
				 success:^(id parsedData) {
					 NSLog(@"parsed data : %@", parsedData);

				 }
				 failure:^(NSError *error) {
					 NSLog(@"Error : %@", error);

				 }];
	
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDate *date = [NSDate date];
//    NSLog(@"1970=%lf",[date timeIntervalSince1970]);
//    
//    NSLog(@"1111=%lf",[date timeIntervalSince1970]-(int)[date timeIntervalSince1970]);
    
//    NSLog(@"%@",[NSDate dateWithTimeIntervalSince1970:1385713212]);
    
//    NSString *key = @"F7CCEDAF-3003-46CC-9303-2DFFD509551C";
//    NSString *secret = @"d9e1468ad367cec246c0bfe5b5f43ccf80aef4c67f943f17a70ca6fb129aa528";
//    
//    NSArray *mt = @[[NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]],[NSString stringWithFormat:@"%lf",[date timeIntervalSince1970]-(int)[date timeIntervalSince1970]]];
//    
//    NSString *mt1 = mt[1];
//    NSString *mt2 = [mt[0] substringWithRange:NSMakeRange(2, 6)];
//    
//    NSString *prefix = @"', '&";
//    
//    NSString *postData = [NSString stringWithFormat:@"%@nonce=%@%@",prefix,mt1,mt2];
//    
//    NSString *key = @"F7CCEDAF-3003-46CC-9303-2DFFD509551C";
//    NSString *secret = @"d9e1468ad367cec246c0bfe5b5f43ccf80aef4c67f943f17a70ca6fb129aa528";
//
//    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cn.bter.com/myaccount/apikeys"]]];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(yyyy) userInfo:nil repeats:YES];
    
    
    

}


- (void)yyyy
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    [request setStartedBlock:^{
        
        NSLog(@"开始");
        
    }];
    
    [request setCompletionBlock:^{
        
        NSLog(@"成功");
        
    }];
    
    [request setFailedBlock:^{
        
        NSLog(@"失败");
        
    }];
    
    [request start];
    
//    [request performSelectorInBackground:@selector(start) withObject:nil];
//    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_getKey release];
    [_textLabel release];
    [super dealloc];
}
@end
