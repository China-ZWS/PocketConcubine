//
//  ReguserViewController.h
//  PocketConcubine
//
//  Created by 周文松 on 15-5-24.
//  Copyright (c) 2015年 TalkWeb. All rights reserved.
//

#import "PJViewController.h"

@interface ReguserViewController : PJViewController
{
    void(^_success)(id datas);
}
- (id)initWithSuccess:(void(^)(id datas))success;
@end
