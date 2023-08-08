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
    
    int count = 100000;
    NSMutableArray *persons = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        Person *person = [Person new];
        person.age = arc4random() % 41;
        [persons addObject:person];
    }
    NSLog(@"已生成%d个Person实例，容器占用空间%zdKB",count,count * sizeof(Person *) / 1024);
    
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    
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
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    for (int i = 0; i < element.count; i++) {
        Person *person = element[i];
        if (judgmentBlock(person)){
            [element removeObjectAtIndex:i];
            i--;
        }
    }
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"O(n²)算法结束,用时%lf秒",end-start);
}

- (void)moveElementToNewArray:(NSMutableArray *)element judgmentBlock:(BOOL (^)(id obj))judgmentBlock{
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:element.count];
    for (int i = 0; i < element.count ; i++) {
        Person *person = element[i];
        if (!judgmentBlock(person)){
            [newArray addObject:person];
        }
    }
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"空间换O(n)算法结束,用时%lf秒",end-start);
}

- (void)fastRemoveElement:(NSMutableArray *)element{
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    [element exchangeObjectAtIndex:1 withObjectAtIndex:2];
    [element lsy_fastRemoveInconformityElementWithJudgmentBlock:^BOOL(id  _Nonnull obj) {
        return ((Person *)obj).age < 18;
    }];
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"不稳定O(n)算法结束,用时%lf秒",end-start);
}

- (void)stabilizeRemoveElement:(NSMutableArray *)element{
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    [element exchangeObjectAtIndex:1 withObjectAtIndex:2];
    [element lsy_stabilizeRemoveInconformityElementWithJudgmentBlock:^BOOL(id  _Nonnull obj) {
        return ((Person *)obj).age < 18;
    }];
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"稳定O(n)算法结束,用时%lf秒",end-start);
}


@end
