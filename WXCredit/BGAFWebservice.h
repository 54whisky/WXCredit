//
//  BGAFWebservice.h
//  WXCredit
//
//  Created by xiegf on 15/8/27.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BGAFWebservice : AFHTTPRequestOperationManager

+(id)sharedInstance;

- (void)sendGetRequest:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)sendPostRequest:(NSString *)path
             parameters:(NSDictionary *)parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)sendPostRequest:(NSString *)path
             parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)sendPostRequest:(NSString *)soapMessage
                   type:(int)type
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)cleanup;

@end
