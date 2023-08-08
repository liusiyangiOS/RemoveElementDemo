//
//  NSMutableArray+LSYRemoveElement.h
//  RemoveElementDemo
//
//  Created by 58 on 2023/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (LSYRemoveElement)

/* 稳定移除元素 */
- (void)lsy_stabilizeRemoveInconformityElementWithJudgmentBlock:(BOOL (^)(id obj))judgmentBlock;

/* 快速移除元素(不稳定) */
- (void)lsy_fastRemoveInconformityElementWithJudgmentBlock:(BOOL (^)(id obj))judgmentBlock;

@end

NS_ASSUME_NONNULL_END
