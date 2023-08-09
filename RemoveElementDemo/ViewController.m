//
//  ViewController.m
//  RemoveElementDemo
//
//  Created by 58 on 2023/7/21.
//

#import "ViewController.h"
#import "NSMutableArray+LSYRemoveElement.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        //延迟两秒在子线程执行,将其他因素的影响降到最低
        [self execute];
    });
}

- (void)execute{
    int count = 100000;
    NSMutableArray *persons = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        Person *person = [Person new];
        person.age = arc4random() % 41;
        [persons addObject:person];
    }
    NSLog(@"已生成%d个Person实例，容器占用空间%zdKB",count,count * sizeof(Person *) / 1024);
        
    [self removeElementNormal:[persons mutableCopy] judgmentBlock:^BOOL(id obj) {
        return ((Person *)obj).age < 18;
    }];
    [self moveElementToNewArray:[persons mutableCopy] judgmentBlock:^BOOL(id obj) {
        return ((Person *)obj).age < 18;
    }];
    
    [self fastRemoveElement:[persons mutableCopy]];
    
    [self stabilizeRemoveElement:[persons mutableCopy]];
}

- (void)removeElementNormal:(NSMutableArray *)element judgmentBlock:(BOOL (^)(id obj))judgmentBlock{
    NSDate *start = [NSDate date];
    for (int i = 0; i < element.count; i++) {
        Person *person = element[i];
        if (judgmentBlock(person)){
            [element removeObjectAtIndex:i];
            i--;
        }
    }
    NSDate *end = [NSDate date];
    NSLog(@"O(n²)算法结束,用时%lf秒",[end timeIntervalSinceDate:start]);
}

- (void)moveElementToNewArray:(NSMutableArray *)element judgmentBlock:(BOOL (^)(id obj))judgmentBlock{
    NSDate *start = [NSDate date];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:element.count];
    for (int i = 0; i < element.count ; i++) {
        Person *person = element[i];
        if (!judgmentBlock(person)){
            [newArray addObject:person];
        }
    }
    NSDate *end = [NSDate date];
    NSLog(@"空间换O(n)算法结束,用时%lf秒\n",[end timeIntervalSinceDate:start]);
}

- (void)fastRemoveElement:(NSMutableArray *)element{
    NSDate *start = [NSDate date];
    [element lsy_fastRemoveInconformityElementWithJudgmentBlock:^BOOL(id  _Nonnull obj) {
        return ((Person *)obj).age < 18;
    }];
    NSDate *end = [NSDate date];
    NSLog(@"不稳定O(n)算法结束,用时%lf秒",[end timeIntervalSinceDate:start]);
}

- (void)stabilizeRemoveElement:(NSMutableArray *)element{
    NSDate *start = [NSDate date];
    [element lsy_stabilizeRemoveInconformityElementWithJudgmentBlock:^BOOL(id  _Nonnull obj) {
        return ((Person *)obj).age < 18;
    }];
    NSDate *end = [NSDate date];
    NSLog(@"稳定O(n)算法结束,用时%lf秒",[end timeIntervalSinceDate:start]);
}

@end
