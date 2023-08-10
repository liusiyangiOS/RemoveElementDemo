//
//  NSMutableArray+LSYRemoveElement.m
//  RemoveElementDemo
//
//  Created by 58 on 2023/7/21.
//

#import "NSMutableArray+LSYRemoveElement.h"

@implementation NSMutableArray (LSYRemoveElement)

- (void)lsy_stabilizeRemoveInconformityElementWithJudgmentBlock:(BOOL (^)(id obj))judgmentBlock{
    if (![self isKindOfClass:NSMutableArray.class] || !self.count){
        return;
    }
    //记录需要移除的元素
    int remove = 0;
    for (int i = 0; i < self.count; i++) {
        if (!judgmentBlock(self[i])){
            [self exchangeObjectAtIndex:remove withObjectAtIndex:i];
            remove++;
        }
    }
    //移除不符合的元素并结束
    [self removeObjectsInRange:NSMakeRange(remove, self.count - remove)];
}

- (void)lsy_fastRemoveInconformityElementWithJudgmentBlock:(BOOL (^)(id obj))judgmentBlock{
    int left = 0;
    int right = self.count - 1;
    do {
        while (left <= right) {
            if (judgmentBlock(self[left])){
                //找到了不符合的元素
                break;
            }
            left++;
        }
        while (left < right) {
            if (!judgmentBlock(self[right])){
                //找到了符合的元素
                [self exchangeObjectAtIndex:left withObjectAtIndex:right];
                left++;
                if (left != right - 1) {
                    right--;
                }
                break;
            }
            right--;
        }
    } while (left < right);
    [self removeObjectsInRange:NSMakeRange(left, self.count - left)];
}

@end
