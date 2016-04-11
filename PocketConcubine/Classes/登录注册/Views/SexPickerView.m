//
//  SexPickerView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "SexPickerView.h"
#define kToolViewHeight 44

@interface SexPickerView ()
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    id _target;
    void(^_sex)(NSString *sex);
    NSArray *_datas;
    NSString *_sexStr;
}
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation SexPickerView

- (id)initWithSex:(void(^)(NSString *sex))sex target:(id)target;
{
    if ((self = [super init])) {
        
        _target = target;
        _sex = sex;
        [self layoutViews];
    }
    return self;
}

- (UIPickerView *)picker
{
    if (!_picker) {
        _picker = [UIPickerView new];
        _picker.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY(_picker.frame) + kToolViewHeight);
        _picker.backgroundColor = [UIColor clearColor];
        _picker.delegate=self;
        _picker.dataSource=self;
        _datas = @[@"男",@"女"];
        _sexStr = @"男";
    }
    return _picker;
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DeviceW, kToolViewHeight)];
        UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
        
        UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
        _toolBar.items=@[lefttem,centerSpace,right];
    }
    return _toolBar;
    
}


- (void)setFrameWithSelf
{
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(_picker.frame) - CGRectGetHeight(_toolBar.frame);
    rect.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
    rect.size.height = CGRectGetHeight(_picker.frame) + CGRectGetHeight(_toolBar.frame);
    self.frame = rect;
}


- (void)layoutViews
{
    [self addSubview:self.picker];
    [self addSubview:self.toolBar];
    [self setFrameWithSelf];
}


#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_datas count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _datas[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _sexStr = _datas[row];
}


- (void)remove
{
    [_target endEditing:YES];
}

- (void)doneClick
{
    [_target endEditing:YES];
    _sex(_sexStr);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
