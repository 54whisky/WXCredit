//
//  User.m
//  WXCredit
//
//  Created by xiegf on 15/9/2.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "User.h"

@implementation User

static User* _instance = nil;

+(id)shareInstance {
    if (_instance == nil) {
        _instance = [[User alloc] init];
    }
    return _instance;
}

@end
