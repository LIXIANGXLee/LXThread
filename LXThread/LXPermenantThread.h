//
//  LXPermenantThread.h
//  LXThread
//
//  Created by 恒悦科技 on 2018/10/18.
//  Copyright © 2018年 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LXPermenantThreadTask)(void);

@interface LXPermenantThread : NSObject

/**
 开启线程  默认开启
 */
- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(LXPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end
