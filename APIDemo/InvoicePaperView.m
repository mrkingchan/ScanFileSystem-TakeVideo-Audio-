//
//  InvoicePaperView.m
//  APIDemo
//
//  Created by Macx on 2018/7/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "InvoicePaperView.h"

#import "Cell.h"
#import "SeperateLine.h"


@interface InvoicePaperView () <UITableViewDelegate,UITableViewDataSource> {
    NSDictionary *_json;
    UITableView*_tableView;
    UIView *_headerView;
    UIView *_footerView;
    
}
@end
@implementation InvoicePaperView


- (instancetype)initWithFrame:(CGRect)frame JsonData:(NSDictionary *)json {
    if (self = [super initWithFrame:frame]) {
        _json = json;
        [self setUI];
    }
    return self;
}

// MARK: - setUI
-(void)setUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,[UIScreen mainScreen].bounds.size.height) style:0];
    
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate =  self;
    _tableView.showsVerticalScrollIndicator =  NO;
    [self addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Cell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([Cell class])];
    
    //header
    UIView *headerView = [UIView new];
    headerView.layer.borderWidth = 0;
    headerView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 -  50, 0, 80, 60)];
    
    imageView.image = [UIImage imageNamed:@"AppIcon"];
    [headerView addSubview:imageView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y +  60 +10, self.frame.size.width, 40)];
    name.textAlignment = 1;
    name.font = [UIFont boldSystemFontOfSize:18];
    name.text = _json[@"resturantName"];
    [headerView addSubview:name];

    UILabel *payTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, name.frame.origin.y +  40 + 10, self.frame.size.width - 30, 30)];
    payTitle.backgroundColor = [UIColor blackColor];
    payTitle.textAlignment = 1;
    payTitle.textColor = [UIColor whiteColor];
    payTitle.font = [UIFont boldSystemFontOfSize:18];
    payTitle.text = @"结账单";
    [headerView addSubview:payTitle];
    
    UILabel *orderTime = [[UILabel alloc] initWithFrame:CGRectMake(0, payTitle.frame.origin.y + 30 + 5, self.frame.size.width, 30)];
    orderTime.layer.borderWidth = 0.0;
    orderTime.font = [UIFont systemFontOfSize:13];
    orderTime.textAlignment = 1;
    orderTime.text = _json[@"orderTime"];
    [headerView addSubview:orderTime];
    
    for (int i = 0 ; i < 2; i ++) {
        SeperateLine *line = [[SeperateLine alloc] initWithY:i == 0 ? orderTime.frame.origin.y + 2  :orderTime.frame.origin.y +  30 +  5];
        [headerView addSubview:line];
    }
    
    headerView.frame = CGRectMake(0, 0, self.frame.size.width, orderTime.frame.origin.y + 35);
    
    //footer
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    footerView.layer.borderWidth = 0;
    
    UILabel * totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width - 20, 30)];
    totalPrice.layer.borderWidth = 0.0;
    totalPrice.font = [UIFont systemFontOfSize:13];
    totalPrice.textAlignment = 0;
    totalPrice.text = _json[@"totalPrice"];
    [footerView addSubview:totalPrice];
    
    for (int i = 0 ; i < 2; i ++) {
        SeperateLine *line = [[SeperateLine alloc] initWithY:i == 0 ? 2 :totalPrice.frame.origin.y +  30 +  5];
        [footerView addSubview:line];
    }
    
    UILabel *flowerView = [[UILabel alloc] initWithFrame:CGRectMake(10, totalPrice.frame.origin.y + 30 + 25, self.frame.size.width - 20, 8)];
    NSMutableString *content = [NSMutableString new];
    for (int i = 0 ; i < 200; i ++) {
        [content appendString:@"*"];
    }
    flowerView.text = content;
    flowerView.textAlignment = 1;
    [footerView addSubview:flowerView];
    
    
    UILabel *welcome = [[UILabel alloc] initWithFrame:CGRectMake(50, totalPrice.frame.origin.y +  35 +  50, self.frame.size.width -  100, 30)];
    welcome.textAlignment = 1;
    welcome.font = [UIFont systemFontOfSize:20];
    welcome.text = @"欢迎下次光临!";
    [footerView addSubview:welcome];
    
    //address
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(0, welcome.frame.origin.y + 10 + 25, self.frame.size.width, 50)];
    address.textAlignment = 1;
    address.numberOfLines = 0;
    address.font = [UIFont systemFontOfSize:15];
    address.text = _json[@"resturantAddress"];
    
    [footerView addSubview:address];

    footerView.frame = CGRectMake(0, 0, self.frame.size.width,address.frame.origin.y +  60 + 5);
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = footerView;
    
}
// MARK: - UITableViewDataSource &Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_json[@"food"]count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Cell class])];
    if (!cell) {
        cell = [[Cell alloc] initWithStyle:0 reuseIdentifier:NSStringFromClass([Cell class])];
    }
    [cell setCellWithData:_json[@"food"][indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

// MARK: - memory management
-(void)dealloc {
    if (_tableView) {
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        _tableView = nil;
    }
}
@end
