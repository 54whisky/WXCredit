//
//  myPickerView.m
//  WXCredit
//
//  Created by xiegf on 15/9/7.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "myPickerView.h"

@interface myPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation myPickerView
-(instancetype)initWithFrame:(CGRect)frame with:(NSArray*)itemArray for:(id)view {
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSArray arrayWithArray:itemArray];
        _label = (UILabel*)view;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-60, 0, 60, 30)];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitleColor:RGBColor(61, 172, 219) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, frame.size.height-30)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
        self.backgroundColor = RGBColor(226, 226, 226);
    }
    return self;
}

-(void)btnClick {
    _label.text = [_dataArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
    [self removeFromSuperview];
}

#pragma mark- UIPickerViewDataSource,UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_dataArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_dataArray objectAtIndex:row];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
