//
//  Macro.h
//  SBSMP
//
//  Created by tians on 15/6/12.
//  Copyright (c) 2015年 tians. All rights reserved.
//

#ifndef SBSMP_Macro_h
#define SBSMP_Macro_h

// APP相关情
#define HOST_NAME       @"58.211.191.118:9001"
#define BASE_URL        @"http://www.shenghongweidai.com:9000/"

#define ACCOUNT_URL     @"http://www.shenghongweidai.com:9000/ws/v1/Account.asmx"
#define CUSTOMER_URL    @"http://www.shenghongweidai.com:9000/ws/v1/Customer.asmx"
#define MESSAGE_URL     @"http://www.shenghongweidai.com:9000/ws/v1/Message.asmx"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define IOS6_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )

#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#define iPhone5 (320*568 <= [[UIScreen mainScreen] bounds].size.height * [[UIScreen mainScreen] bounds].size.width)

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#define MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ScreenW self.frame.size.width
#define ScreenH self.frame.size.height
#define DETAILSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width-24
#define SCALE_Width (MAINSCREEN_WIDTH/320.0)
#define SCALE_Height (MAINSCREEN_HEIGHT/568.0)
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
