//
//  ActivityRegisterViewController.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-12.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"

@interface ActivityRegisterViewController : PJViewController
{
    void(^_success)();
}
- (id)initWithDatas:(id)datas success:(void(^)())success;
@end
