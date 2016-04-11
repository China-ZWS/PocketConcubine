//
//  BaseModel.m
//  BabyStory
//
//  Created by 周文松 on 14-11-18.
//  Copyright (c) 2014年 com.talkweb.BabyStory. All rights reserved.
//

#import "BaseModel.h"
@implementation BaseModel

+ (void )createData:(NSString *)responseString success:(void (^)(id data))success failure:(void (^)(NSString *msg, NSString *state))failure;
{
//    NSLog(@"%@",responseString);
    
    NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *resultCode = dict[@"resultCode"];
    
    NSString *msg = dict[@"msg"];
    
    if ([resultCode isEqualToString:@"000000"] )
    {
        success(dict);
    }
    else
    {
        failure(msg,resultCode);
    }
}

@end
