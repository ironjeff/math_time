//
//  ViewController.h
//  math
//
//  Created by Jeff Huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *solutionResult;
@property (weak, nonatomic) IBOutlet UILabel *solutionResultSubText;

@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelOperand;
@property (weak, nonatomic) IBOutlet UILabel *labelRight;
@property (weak, nonatomic) IBOutlet UIButton *guess1;
@property (weak, nonatomic) IBOutlet UIButton *guess2;
@property (weak, nonatomic) IBOutlet UIButton *guess3;
@property (weak, nonatomic) IBOutlet UIButton *guess4;
@property (weak, nonatomic) IBOutlet UILabel *timer;

- (IBAction)quitButton:(id)sender;


- (IBAction)guess1:(id)sender;
- (IBAction)guess2:(id)sender;
- (IBAction)guess3:(id)sender;
- (IBAction)guess4:(id)sender;

@property NSInteger left;
@property NSInteger right;
@property NSInteger solution;
@property NSInteger solutionIndex;

@property NSInteger totalCorrect;
@property NSInteger totalWrong;
@property NSInteger longestStreak;
@property NSInteger currentCorrect;

@property NSTimer *timerValue;
@property NSDate *questionStartTime;
@property NSDate *sessionStartTime;

@property NSString* gameID;

@property NSString* userID;
@property NSString* userName;

@end
