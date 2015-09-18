//
//  BGUtility.h
//  WXCredit
//
//  Created by xiegf on 15/9/1.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGUtility : NSObject

// 检查是否为手机号
+(BOOL) isValidateMobile:(NSString *)mobile;
// 验证身份证号
+(BOOL) chk18PaperId:(NSString *) sPaperId;

+(NSString*)turnDateToStringWithTime:(NSDate *)date;
+(NSString*)getDateStrFromDB:(NSString*)str;
+(NSString *)getUserRootPath;

@end
