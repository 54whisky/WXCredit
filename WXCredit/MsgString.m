//
//  MsgString.m
//  WXCredit
//
//  Created by xiegf on 15/8/27.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "MsgString.h"
#import "XMLDictionary.h"

#define XML_START   @"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n <soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"> <soap12:Body>"
#define XML_END     @"</soap12:Body> </soap12:Envelope>"
#define XML_BODYSTART @"<soap12:Body>"
#define XML_BODYEND   @"</soap12:Body>"
#define XMLNS   @"http://nearfull.com/"

@implementation MsgString

+(NSString *)getXMLStringFrom:(NSDictionary *)dic with:(NSString *)method {
    NSArray *keyArray = [dic allKeys];
    NSMutableString *keyStr = [[NSMutableString alloc] init];
    [keyStr appendString:[NSString stringWithFormat:@"<%@ xmlns=\"%@\">", method, XMLNS]];
    for (NSString* keyName in keyArray) {
        NSString *str = [NSString stringWithFormat:@"<%@>%@</%@>", keyName, [dic objectForKey:keyName], keyName];
        [keyStr appendString:str];
    }
    [keyStr appendString:[NSString stringWithFormat:@"</%@>", method]];
    return [NSString stringWithFormat:@"%@ %@ %@", XML_START, keyStr, XML_END];
}

+(NSDictionary *)getDictionaryFrom:(NSString *)str {
    NSDictionary *dic = [NSDictionary dictionaryWithXMLString:str];
    NSDictionary *body = [dic objectForKey:@"soap:Body"];
    NSDictionary *response = [body objectForKey:[body allKeys][0]];
    NSDictionary *resultDic = nil;
    for (NSString *keyName in [response allKeys]) {
        if (![keyName isEqualToString:@"_xmlns"]) {
            NSData* jsonData = [[response objectForKey:keyName] dataUsingEncoding:NSUTF8StringEncoding];
            resultDic = [jsonData objectFromJSONData];
        }
    }
    if (resultDic == nil) {
        NSLog(@"getDictionaryFromString result is nil");
    }
    return resultDic;
}

@end
