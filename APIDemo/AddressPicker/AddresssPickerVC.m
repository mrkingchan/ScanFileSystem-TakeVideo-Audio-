//
//  AddresssPickerVC.m
//  APIDemo
//
//  Created by Macx on 2018/8/2.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AddresssPickerVC.h"

@interface AddresssPickerVC () <UIPickerViewDataSource,UIPickerViewDelegate> {
    NSDictionary *_jsonData;
    UIPickerView *_pickerView;
    NSString *_selectedProvinceStr;
    NSString *_selectedDistrictStr;
    NSInteger _selectedDistrictRow;
}

@end

@implementation AddresssPickerVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //默认选择每列的第一行
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    [_pickerView selectRow:0 inComponent:1 animated:YES];
    [_pickerView selectRow:0 inComponent:2 animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"地址选择器";
    //预定好json数据格式
    _jsonData = @{
                  @"江西省":@[
                             @{@"宜春市":
                                @[@"樟树市",@"丰城市",@"铜鼓县"]
                             },
                             @{@"xxx111":
                                   @[@"xxx1",@"xxx2",@"xxx3"]
                               },
                           ],
                  @"湖南省111":@[
                          @{@"xxx111":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx222":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx333":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx444":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          ],
                  @"湖南省222":@[
                          @{@"xxx111":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx222":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx333":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx444":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          ],
                  @"湖南省333":@[
                          @{@"xxx111":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx222":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx333":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx444":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          ],
                  @"湖南省444":@[
                          @{@"xxx111":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx222":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx333":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx444":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          ],
                  @"湖南省555":@[
                          @{@"xxx111":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx222":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx333":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx444":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          ],
                  @"湖南省666":@[
                          @{@"xxx111":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx222":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx333":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx444":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          ],
                  @"湖南省777":@[
                          @{@"xxx111":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx222":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx333":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          @{@"xxx444":
                                @[@"xxx1",@"xxx2",@"xxx3"]
                            },
                          ],
                  };
    _selectedDistrictRow = 0;
    _selectedProvinceStr = @"江西省";
    _selectedDistrictStr = @"宜春";
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kAppHeight -  400, kAppWidth, 400)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self.view addSubview:_pickerView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ok" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    //输出pickerView的所有属性
    unsigned int count = 0;
    /*objc_property_t *properties = class_copyPropertyList([UIPickerView class], &count);
    for (int i = 0 ; i < count; i ++) {
        NSString *keyValue = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSLog(@"property = %@",keyValue);
    }*/
    
    /*Ivar *var = class_copyIvarList([UIPickerView class], &count);
    for (int i = 0; i < count; i ++) {
        NSString *varValue = [NSString stringWithUTF8String:ivar_getName(var[i])];
        NSLog(@"varValue = %@",varValue);
    }*/
}

- (void)buttonAction:(id)sender {
    NSInteger row1 = [_pickerView  selectedRowInComponent:0];
    NSInteger row2 = [_pickerView  selectedRowInComponent:1];
    NSInteger row3 = [_pickerView  selectedRowInComponent:2];
    
    NSString *selectedprovinceStr = [_jsonData allKeys][row1];
    NSString*selectedDistrictStr = [_jsonData[selectedprovinceStr][row2] allKeys][0];
    NSString *selectedSubStr = _jsonData[selectedprovinceStr][row2][selectedDistrictStr][row3];
    NSString *selectedStr = [NSString stringWithFormat:@"%@%@%@",selectedprovinceStr,selectedDistrictStr,selectedSubStr];
    iToastText(selectedStr);
}

// MARK: - UIPickerViewDatasource&Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView  {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[_jsonData allKeys] count];
    }else if (component == 1) {
        return [_jsonData[_selectedProvinceStr]count];
    } else {
        NSDictionary *jsonDic =  _jsonData[_selectedProvinceStr][_selectedDistrictRow];
        return [ jsonDic[_selectedDistrictStr] count];
    }
}

/*-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_jsonData allKeys][row];
    } else if (component == 1) {
       NSDictionary *jsonDic = _jsonData[_selectedProvinceStr][row];
                                return [jsonDic allKeys][0];
    } else if (component == 2) {
        NSDictionary *json = _jsonData[_selectedProvinceStr][_selectedDistrictRow];
        return json[_selectedDistrictStr][row];
    } else {
        return  @"";
    }
}*/

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component  {
    NSString *contentStr = @"";
    
    if (component == 0) {
        contentStr=  [_jsonData allKeys][row];
    } else if (component == 1) {
        NSDictionary *jsonDic = _jsonData[_selectedProvinceStr][row];
        contentStr  =  [jsonDic allKeys][0];
    } else if (component == 2) {
        NSDictionary *json = _jsonData[_selectedProvinceStr][_selectedDistrictRow];
        contentStr =json[_selectedDistrictStr][row];
    } else {
    }
    NSAttributedString *valueStr = [[NSAttributedString alloc] initWithString:contentStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
    return valueStr ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 ) {
        _selectedProvinceStr = [_jsonData allKeys][row];
        _selectedDistrictRow = 0;
        NSArray *items = _jsonData[_selectedProvinceStr];
        _selectedDistrictStr = [items[0] allKeys][0];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    } else if (component == 1) {
        _selectedDistrictRow = row;
        NSArray *items = _jsonData[_selectedProvinceStr];
        _selectedDistrictStr = [items[row] allKeys][0];
        [pickerView reloadComponent:2];
    } else if (component == 2 ) {
        NSDictionary *json = _jsonData[_selectedProvinceStr][_selectedDistrictRow];
        NSString *selectedStr = [NSString stringWithFormat:@"%@%@%@",_selectedProvinceStr,_selectedDistrictStr,json[_selectedDistrictStr][row]];
        iToastText(selectedStr);
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kAppWidth / 3.0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 33;
}

// MARK: - memory management
- (void)dealloc {
    if (_pickerView) {
        _pickerView = nil;
    }
    if (_jsonData) {
        _jsonData = nil;
    }
}

@end
