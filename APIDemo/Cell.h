//
//  Cell.h
//  APIDemo
//
//  Created by Macx on 2018/7/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *price;

- (void)setCellWithData:(NSDictionary *)json;

@end
