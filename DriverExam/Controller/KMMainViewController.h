//
//  KMMainViewController.h
//  DriverExam
//
//  Created by Liu Feng on 15/2/3.
//  Copyright (c) 2015年 Baisika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface KMMainViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UILabel *questionCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UIButton *rebuyButton;

@end
