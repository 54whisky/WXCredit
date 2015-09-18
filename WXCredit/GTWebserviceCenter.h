//
//  GTWebserviceCenter.h
//  GTiOSKit
//
//  Created by Liyuan on 15/5/27.
//  Copyright (c) 2015年 golden-tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

@interface GTWebserviceCenter : NSObject

+(id)sharedInstance;

- (void)sendPostRequest:(NSString *)path
             parameters:(NSDictionary *)parameters
                success:(void (^)(MKNetworkOperation *operation))success
                failure:(void (^)(MKNetworkOperation *operation, NSError *error))failure;

- (void)sendDownloadRequest:(NSString*)path
                 parameters:(NSDictionary *)parameters
               downloadPath:(NSString*)downloadPath
                    success:(void (^)(MKNetworkOperation *operation))success
                    failure:(void (^)(MKNetworkOperation *operation, NSError *error))failure;

- (void)sendUploadRequest:(NSString*)path
               parameters:(NSDictionary *)parameters
                 filePath:(NSString *)filePath
                  success:(void (^)(MKNetworkOperation *operation))success
                  failure:(void (^)(MKNetworkOperation *operation, NSError *error))failure;

@end
