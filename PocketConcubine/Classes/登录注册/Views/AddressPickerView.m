//
//  AdressPickerView.m
//  PocketConcubine
//
//  Created by 周文松 on 15-5-25.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "AddressPickerView.h"
#import "AddressLocation.h"
#define kToolViewHeight 44

@interface AddressPickerView ()
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    id _target;
    void(^_address)(NSString *address);
    NSArray *_provinces;
    NSArray	*_cities;
}
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) AddressLocation *locate;
@end
@implementation AddressPickerView

- (id)initWithAddress:(void(^)(NSString *address))address target:(id)target;
{
    if ((self = [super init])) {
        
        _target = target;
        _address = address;
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
        //加载数据
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
        _cities = [[_provinces objectAtIndex:0] objectForKey:@"Cities"];
        
        //初始化默认数据
        self.locate = [[AddressLocation alloc] init];
        self.locate.state = [[_provinces objectAtIndex:0] objectForKey:@"State"];
        self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
        self.locate.latitude = [[[_cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
        self.locate.longitude = [[[_cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[_provinces objectAtIndex:row] objectForKey:@"State"];
            break;
        case 1:
            return [[_cities objectAtIndex:row] objectForKey:@"city"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            _cities = [[_provinces objectAtIndex:row] objectForKey:@"Cities"];
            [_picker selectRow:0 inComponent:1 animated:NO];
            [_picker reloadComponent:1];
            
            self.locate.state = [[_provinces objectAtIndex:row] objectForKey:@"State"];
            self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
            self.locate.latitude = [[[_cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[_cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
            break;
        case 1:
            self.locate.city = [[_cities objectAtIndex:row] objectForKey:@"city"];
            self.locate.latitude = [[[_cities objectAtIndex:row] objectForKey:@"lat"] doubleValue];
            self.locate.longitude = [[[_cities objectAtIndex:row] objectForKey:@"lon"] doubleValue];
            break;
        default:
            break;
    }
}


- (void)remove
{
    [_target endEditing:YES];
}

- (void)doneClick
{
    [_target endEditing:YES];
    _address([[self.locate.state stringByAppendingString:@"-"] stringByAppendingString:self.locate.city]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
