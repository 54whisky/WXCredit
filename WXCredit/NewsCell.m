//
//  NewsCell.m
//  WXCredit
//
//  Created by xiegf on 15/9/9.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "NewsCell.h"
#import "BGUtility.h"

@interface NewsCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *sepratorLabel;

@end

@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, MAINSCREEN_WIDTH-16, 21)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-8-200, 45, 200, 20)];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.textColor = RGBColor(203, 203, 203);
    [self.contentView addSubview:_dateLabel];
    
    _sepratorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, MAINSCREEN_WIDTH, 1)];
    _sepratorLabel.backgroundColor = RGBColor(226, 226, 226);
    [self.contentView addSubview:_sepratorLabel];
}

-(void)fillData:(NSDictionary *)newsInfo {
    _titleLabel.text = [newsInfo objectForKey:@"title"];
    _dateLabel.text = [BGUtility getDateStrFromDB:[newsInfo objectForKey:@"date"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
