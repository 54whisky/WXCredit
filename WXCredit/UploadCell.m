//
//  UploadCell.m
//  WXCredit
//
//  Created by xiegf on 15/9/10.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "UploadCell.h"
#import "UIImageView+WebCache.h"

@interface UploadCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UploadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillData:(NSDictionary *)cellInfo {
    _titleLabel.text = [cellInfo objectForKey:@"name"];
    NSString *imgUrl = [cellInfo objectForKey:@"url"];
    if ([[cellInfo objectForKey:@"isEdit"] isEqualToString:@"0"]) {
        if ([imgUrl isEqualToString:@""]) {
            [_imgView setImage:[UIImage imageNamed:@"addIcon.png"]];
        } else {
            [_imgView setContentMode:UIViewContentModeScaleAspectFit];
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"addIcon.png"]];
        }
    } else {
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        _imgView.image = [UIImage imageWithContentsOfFile:[cellInfo objectForKey:@"filePath"]];
    }
}

@end
