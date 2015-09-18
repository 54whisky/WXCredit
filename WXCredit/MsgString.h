//
//  MsgString.h
//  WXCredit
//
//  Created by xiegf on 15/8/27.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgString : NSObject

+(NSString*)getXMLStringFrom:(NSDictionary*)dic with:(NSString*)method;

+(NSDictionary*)getDictionaryFrom:(NSString*)str;

@end
