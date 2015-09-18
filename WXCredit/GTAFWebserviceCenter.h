//
//  GTAFWebserviceCenter.h
//  GTKit
//
//  Created by 高达 on 14-8-20.
//  Copyright (c) 2014年 wisesz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface GTAFWebserviceCenter : AFHTTPRequestOperationManager

+(id)sharedInstance;

-(void)setRequestBaseUrl:(NSURL*)url;

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
-(void)cleanup;
@end
