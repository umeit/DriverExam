//
//  ExercisesViewController.m
//  DriverExam
//
//  Created by Liu Feng on 15/1/16.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import "ExercisesViewController.h"
#import "QuestionBase.h"
#import "ReinforceQuestionStore.h"
#import "MobClick.h"

@interface ExercisesViewController ()

@property (nonatomic) BOOL isShowAnswer;

@end


@implementation ExercisesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"试题练习";
    
    UIBarButtonItem *showAnswerItem = [[UIBarButtonItem alloc] initWithTitle:@"显示答案"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(showAnswerButtonPress:)];
    self.navigationItem.rightBarButtonItem = showAnswerItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ExercisesView"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ExercisesView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[QuestionStore answerCacheStore] clearCache];
}

#pragma mark - Action

/** 显示答案 */
- (IBAction)showAnswerButtonPress:(id)sender
{
    if (self.isShowAnswer) {
        [self.navigationItem.rightBarButtonItem setTitle:@"显示答案"];
        
        self.isShowAnswer = NO;
        
        [self updateQuestionDisplay];
    }
    else {
        [self.navigationItem.rightBarButtonItem setTitle:@"隐藏答案"];
        
        self.isShowAnswer = YES;
        
        [self updateQuestionDisplay];
    }
}


#pragma mark - Override

- (void)procNextQuestionButtonPress
{
    // 如当前题没做，记入强化练习
    if (!self.question.result && !self.isShowAnswer) {
        [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    }
    
    [self showNextQuestion];
}

- (void)procPrevQuestionButtonPress
{
    [self showPrevQuestion];
}

- (void)showCurrentQuestion
{
    self.question = [[QuestionStore exercisesStore] currentQuestion];
    [self updateQuestionDisplay];
}

- (void)showNextQuestion
{
    // 获取下一个练习题
    QuestionBase *question = [[QuestionStore exercisesStore] nextQuestion];
    if (question) {
        self.question = question;
        // 更新题目显示
        [self updateQuestionDisplay];
    }
}

- (void)showPrevQuestion
{
    self.question = [[QuestionStore exercisesStore] prevQustion];
    [self updateQuestionDisplay];
    if (self.question.qustoinID == 0) {
        self.prevButton.hidden = YES;
    }
}

- (void)updateQuestionDisplay
{
    [super updateQuestionDisplay];
    
    // 上一题按钮
    if (self.question.qustoinID == 1) {
        self.prevButton.hidden = YES;
    } else {
        self.prevButton.hidden = NO;
    }
    
    // 下一题按钮
    if ([[QuestionStore exercisesStore] hasNextQuestion]) {
        self.nextButton.hidden = NO;
    } else {
        self.nextButton.hidden = YES;
    }
    
    [self updatePageNumber];
    
    // 显示答案模式
    if (self.isShowAnswer) {
        // 显示答案模式下不可答题
        [self operationButtonEnabled:NO];
        
        [self showCorrectAnswer];
        
    }
    // 非显示答案模式
    else {
        // 显示最近做过的结果
        QuestionBase *question = [[QuestionStore answerCacheStore] questionWithIDOnCache:self.question.qustoinID];
        if (question) {
            self.question = question;
            if (self.question.result == self.question.correctIndex) {
                [self showCorrectAnswer];
            }
            else {
                NSInteger correctButtonTag = self.question.result;
                self.selectedButton = (UIButton *)[self.view viewWithTag:correctButtonTag];
                [self updateSelectedButtonFaultStatus];
                [self showCorrectAnswer];
            }
            
            // 最近做过的题不可答题
            [self operationButtonEnabled:NO];
        }
    }
}

/** 答对后的处理 */
- (void)answerDidCorrect
{
    // 禁用按钮
    [self operationButtonEnabled:NO];
    
    // 记录本题的结果
    [[QuestionStore answerCacheStore] addCacheQuestion:self.question];
    
    // 显示正确选项
    [self showCorrectAnswer];
    
    // 两秒后显示下一题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showNextQuestion];
    });
}

/** 答错后的处理 */
- (void)answerDidFault
{
    // 禁用按钮
    [self operationButtonEnabled:NO];
    
    // 记录本题的结果
    [[QuestionStore answerCacheStore] addCacheQuestion:self.question];
    
    // 将错题加入加强练习题库
    [[ReinforceQuestionStore reinforceStore] addNeedReinforceQuestion:self.question];
    
    // 显示错误/正确结果
    [self updateSelectedButtonFaultStatus];
    [self showCorrectAnswer];
}


#pragma mark - Private

- (void)updatePageNumber
{
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.question.qustoinID, [[QuestionStore exercisesStore] questionCuont]];
}

@end
