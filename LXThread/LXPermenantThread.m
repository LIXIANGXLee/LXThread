//
//  LXPermenantThread.m
//  LXThread
//
//  Created by 恒悦科技 on 2018/10/18.
//  Copyright © 2018年 李响. All rights reserved.
//

#import "LXPermenantThread.h"
#import "LXProxy.h"

/** LXThread **/
@interface LXThread : NSThread
@end
@implementation LXThread
- (void)dealloc{
    NSLog(@"%s", __func__);
}
@end

@interface LXPermenantThread()
@property (strong, nonatomic) LXThread *innerThread;
@end

@implementation LXPermenantThread
#pragma mark - public methods
- (instancetype)init{
    if (self = [super init]) {
        if (@available(iOS 10.0, *)) {
            __weak typeof(self)weakSelf = self;
            self.innerThread = [[LXThread alloc] initWithBlock:^{
                [weakSelf __saveThread];
            }];
            
        } else {
            self.innerThread = [[LXThread alloc]initWithTarget:[LXProxy proxyWithTarget:self] selector:@selector(__saveThread) object:nil];
        }
        
        [self.innerThread start];
    }
    return self;
}

- (void)run{
    if (!self.innerThread) return;
    
    if (!self.innerThread.isExecuting) {
         [self.innerThread start];
    }
}

- (void)executeTask:(LXPermenantThreadTask)task{
    if (!self.innerThread || !task) return;
    
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop{
    if (!self.innerThread) return;
    
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [self stop];
}

#pragma mark - private methods

-(void)__saveThread{

    CFRunLoopSourceContext context = {0};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
}

- (void)__stop{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(LXPermenantThreadTask)task{
    task();
}

@end
