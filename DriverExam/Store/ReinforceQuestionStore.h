//
//  ReinforceQuestionStore.h
//  DriverExam
//
//  Created by 沈 湛 on 15/1/26.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "QuestionStore.h"

@interface ReinforceQuestionStore : QuestionStore

+ (ReinforceQuestionStore *)reinforceStore;

- (void)addNeedReinforceQuestion:(QuestionBase *)question;

- (void)questionDidReinforced:(QuestionBase *)question;

/** 答错总数 */
- (NSInteger)faultQuestionCount;

/** 未答总数 */
- (NSInteger)missQuestionCount;

/** 已强化总数 */
- (NSInteger)reinforcedQuestionCount;

- (QuestionBase *)nextQuestionWhenLastQuestionWsaCorrect;

/** 第一条已强化 */
- (QuestionBase *)currentReinforcedQuestion;

/** 下一条已强化 */
- (QuestionBase *)nextReinforcedQuestion;

/** 上一条已强化 */
- (QuestionBase *)prevReinforcedQustion;

/** 当前已强化索引 */
- (NSInteger)currenReinforcedQuestionIndex;

- (void)clearFault;

- (void)clearMiss;

- (void)clearReinforced;

@end
