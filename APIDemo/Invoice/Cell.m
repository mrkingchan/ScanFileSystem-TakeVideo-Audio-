//
//  Cell.m
//  APIDemo
//
//  Created by Chan on 2018/7/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithData:(NSDictionary *)json {
    _name.text = [NSString stringWithFormat:@"    %@",json[@"name"]];
    _number.text = [NSString stringWithFormat:@"X%zd",[json[@"number"]integerValue]];
    _price.text = json[@"price"];
}


@end
