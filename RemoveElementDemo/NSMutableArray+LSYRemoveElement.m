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
    int retain = 0;
    int remove = 0;
    while (retain < self.count) {
        while (remove < self.count) {
            if (judgmentBlock(self[remove])){
                //找到了不符合的元素
                break;
            }
            remove++;
        }
        if (retain == 0) {
            retain = remove + 1;
        }else{
            retain ++;
        }
        while (retain < self.count) {
            if (!judgmentBlock(self[retain])){
                //找到了符合的元素
                [self exchangeObjectAtIndex:remove withObjectAtIndex:retain];
                remove++;
                break;
            }
            retain++;
        }
    };
    if (remove < self.count){
        //移除不符合的元素并结束
        for (int i = self.count - 1; i >= remove; i--) {
            [self removeLastObject];
        }
    }
}

- (void)lsy_fastRemoveInconformityElementWithJudgmentBlock:(BOOL (^)(id obj))judgmentBlock{
    int left = 0;
    int right = self.count - 1;
    do {
        if (left != 0){
            //left不为零,说明已经交换过,说明当前的right是交换过后的不符合的元素,不需要重复判断
            right--;
        }
        do {
            if (judgmentBlock(self[left])){
                //找到了不符合的元素
                break;
            }
            if (left == self.count - 1){
                //找到了最后一个元素都没找到,直接结束
                return;
            }
            left++;
        } while (left < right);
        while (left < right) {
            if (!judgmentBlock(self[right])){
                //找到了符合的元素
                [self exchangeObjectAtIndex:left withObjectAtIndex:right];
                left++;
                break;
            }
            right--;
        }
    } while (left < right);
    if (left < self.count){
        //移除不符合的元素并结束
        for (int i = self.count - 1; i >= left; i--) {
            [self removeLastObject];
        }
    }
}

@end
