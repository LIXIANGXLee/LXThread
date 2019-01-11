//
//  ViewController.m
//  LXThread
//
//  Created by 恒悦科技 on 2018/10/18.
//  Copyright © 2018年 李响. All rights reserved.
//

#import "ViewController.h"
#import "LXPermenantThread.h"

@interface ViewController ()
@property (strong, nonatomic) LXPermenantThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.thread = [[LXPermenantThread alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.thread run];
    
    
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];

}

@end
