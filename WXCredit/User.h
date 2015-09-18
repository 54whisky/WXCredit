//
//  User.h
//  WXCredit
//
//  Created by xiegf on 15/9/2.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *CU_GUID;
@property (nonatomic, copy) NSString *CU_NAME;
@property (nonatomic, copy) NSString *CU_PHONE;
@property (nonatomic, copy) NSString *ID_NUMBER;
@property (nonatomic, copy) NSString *CU_QQ;
@property (nonatomic, copy) NSString *ANNUAL_INCOME;
@property (nonatomic, copy) NSString *HOURSE_STATE;
@property (nonatomic, copy) NSString *HOURSE_CARD;
@property (nonatomic, copy) NSString *MARITAL_STATE;
@property (nonatomic, copy) NSString *HIGHTEST_EDU;
@property (nonatomic, copy) NSString *DOMICILE;
@property (nonatomic, copy) NSString *CC_NAME1;
@property (nonatomic, copy) NSString *CC_NAME2;
@property (nonatomic, copy) NSString *CC_PHONE1;
@property (nonatomic, copy) NSString *CC_PHONE2;
@property (nonatomic, copy) NSString *CC_RELATION1;
@property (nonatomic, copy) NSString *CC_RELATION2;
@property (nonatomic, copy) NSString *LOAN_USE;
@property (nonatomic, copy) NSString *LOAN_VALUE;
@property (nonatomic, copy) NSString *LOAN_LIMIT;
@property (nonatomic, copy) NSString *LOAN_PER;

+(id)shareInstance;

@end
