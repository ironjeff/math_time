//
//  ViewController.m
//  math
//
//  Created by Jeff Huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "SummaryControllerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *quitButton;

@end

@implementation GameViewController
@synthesize solutionResult;
@synthesize solutionResultSubText;
@synthesize labelLeft;
@synthesize labelOperand;
@synthesize labelRight;
@synthesize guess1;
@synthesize guess2;
@synthesize guess3;
@synthesize guess4;
@synthesize timer;

@synthesize left;
@synthesize right;
@synthesize solution;
@synthesize solutionIndex;

@synthesize timerValue;
@synthesize questionStartTime;
@synthesize sessionStartTime;

@synthesize totalCorrect;
@synthesize totalWrong;
@synthesize longestStreak;

@synthesize gameID;

@synthesize currentCorrect;

@synthesize userID;
@synthesize userName;

- (void)viewDidLoad
{
    NSLog(@"ViewController: user id, name: %@, %@", self.userID, self.userName);
    
    [self initAllButtonStyles];
    [self initializeValues];
    [self initTimer];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // No need to log start, just end
    //[self logNewGameToParse];
}

- (void) initAllButtonStyles
{
    [self initButtonStyle:self.quitButton];
    [self initButtonStyle:self.guess1];
    [self initButtonStyle:self.guess2];
    [self initButtonStyle:self.guess3];
    [self initButtonStyle:self.guess4];
}

- (void) initButtonStyle:(UIButton*)button
{
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setCornerRadius:10.0f];
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
}

- (void) logEndGameToParse
{
    PFObject *gameEnd = [PFObject objectWithClassName:@"GameEnd"];
    gameEnd[@"longestStreak"] = @(self.longestStreak);
    gameEnd[@"totalCorrect"] = @(self.totalCorrect);
    gameEnd[@"totalWrong"] = @(self.totalWrong);
    gameEnd[@"name"] = self.userName;
    gameEnd[@"uid"] = self.userID;
    gameEnd[@"sessionLength"] = @([self getSessionTimeInSeconds]);
    [gameEnd saveInBackground];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"== ViewController::prepareForSegue %@", segue.identifier);
    if([segue.identifier isEqualToString:@"toSummary"]){
        SummaryControllerViewController* controller = (SummaryControllerViewController*)segue.destinationViewController;
        controller.streak = self.longestStreak;
        controller.correct = self.totalCorrect;
        controller.wrong = self.totalWrong;
        controller.length = [self getSessionTime];
    }
}

- (void)initializeValues
{
    int maxGuessValue = 10;
    int maxSolutionValue = maxGuessValue + maxGuessValue;
    self.left = arc4random() % maxGuessValue;
    self.right = arc4random() % maxGuessValue;
    
    NSLog(@"left - %i, right - %i", self.left, self.right);
    
    self.solution = self.left + self.right;
    int solIndex = arc4random() % 4;
    self.solutionIndex = solIndex;
    self.labelLeft.text = [[NSString alloc] initWithFormat:@"%i", self.left];
    self.labelOperand.text = @"+";
    self.labelRight.text = [[NSString alloc] initWithFormat:@"%i", self.right];
    
    NSInteger guesses[4];
    for (NSInteger i = 0; i < 4; i++ ) {
        if (i == solIndex) {
            guesses[i] = self.solution;
        } else {
            guesses[i] = [self getGuessValue:self.solution :maxSolutionValue];
        }
    }
    NSLog(@"solIndex %i, sol %i, g1 %i, %i, %i, %i", self.solutionIndex, self.solution, guesses[0], guesses[1], guesses[2], guesses[3]);
    [self.guess1 setTitle:[[NSString alloc] initWithFormat:@"%i", guesses[0]] forState:UIControlStateNormal];
    [self.guess2 setTitle:[[NSString alloc] initWithFormat:@"%i", guesses[1]] forState:UIControlStateNormal];
    [self.guess3 setTitle:[[NSString alloc] initWithFormat:@"%i", guesses[2]] forState:UIControlStateNormal];
    [self.guess4 setTitle:[[NSString alloc] initWithFormat:@"%i", guesses[3]] forState:UIControlStateNormal];
    
}

- (int) getGuessValue: (int) sol :(int) maxValue
{
    int guess = arc4random() % maxValue;
    while (guess == sol) {
        guess = arc4random() % maxValue;
    }
    return guess;
}

- (void) initTimer 
{
    self.questionStartTime = [NSDate date];
    self.sessionStartTime = self.questionStartTime;
    
    // Create the stop watch timer that fires every 10 ms
    self.timerValue = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                      target:self
                                                    selector:@selector(updateTimerString)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void) updateTimerString
{
    NSString* timeString = [self getSessionTime];
    timer.text = timeString;
}

- (NSString*) getSessionTime
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:sessionStartTime];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    return timeString;
}

// For logging
- (NSTimeInterval) getSessionTimeInSeconds
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:sessionStartTime];
    return timeInterval;
}

- (void)viewDidUnload
{
    [self setLabelLeft:nil];
    [self setLabelOperand:nil];
    [self setLabelRight:nil];
    [self setGuess1:nil];
    [self setGuess2:nil];
    [self setGuess3:nil];
    [self setGuess4:nil];
    [self setSolutionResult:nil];
    [self setTimer:nil];
    [self setSolutionResultSubText:nil];
    [super viewDidUnload];
}

- (void) checkSolution:(int) current
{
    if (current == self.solutionIndex) {
        self.solutionResultSubText.text = nil;
        self.solutionResult.text = @"Good Job!";
        self.totalCorrect += 1;
        self.currentCorrect += 1;
        if (self.currentCorrect > self.longestStreak) {
            self.longestStreak = self.currentCorrect;
        }
    } else {
        self.solutionResult.text = @"Oops try again!";
        self.solutionResultSubText.text = [NSString stringWithFormat:@"%i + %i = %i", self.left, self.right, self.solution];
        self.totalWrong += 1;
        self.currentCorrect = 0;
    }
    
    // No need to log each question
    //[self logQuestionToParse:correctness];
    //[self resetTimer];

}

- (IBAction)guess1:(id)sender {
    [self checkSolution:0];
    [self initializeValues];
}

- (IBAction)guess2:(id)sender {
    [self checkSolution:1];
    [self initializeValues];

}

- (IBAction)guess3:(id)sender {
    [self checkSolution:2];
    [self initializeValues];

}

- (IBAction)guess4:(id)sender {
    [self checkSolution:3];
    [self initializeValues];

}

- (IBAction)quitButton:(id)sender {
    NSLog(@"quit button");
   
    [self logEndGameToParse];
    
    [self.navigationController popToRootViewControllerAnimated:TRUE];
    
    // Why did I do this?
    //[self dismissViewControllerAnimated:YES completion:nil];
}


// Don't need this
//- (void) logNewGameToParse
//{
//    PFObject *game = [PFObject objectWithClassName:@"GameStart"];
//    game[@"name"] = self.userName;
//    game[@"uid"] = self.userID;
//    [game save]; // Need to make this synchronous because I need the gameID for logging
//    self.gameID = [game objectId];
//    NSLog(@"GAME ID %@", self.gameID);
//}

// Don't need this
//- (void) logQuestionToParse:(NSInteger)correctness
//{
//    PFObject *question = [PFObject objectWithClassName:@"Question"];
//    question[@"gameID"] = self.gameID;
//    question[@"userID"] = self.userID;
//    question[@"userName"] = self.userName;
//    question[@"correct"] = @(correctness);
//    question[@"timeTakenInSeconds"] = @([self getCurrentTimerTimeInSeconds]);
//    [question saveInBackground];
//}



//- (NSString*) getCurrentTimerTime
//{
//    NSDate *currentDate = [NSDate date];
//    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:questionStartTime];
//    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
//    NSString *timeString=[dateFormatter stringFromDate:timerDate];
//    return timeString;
//}

//- (void) resetTimer
//{
//    NSTimeInterval session = [self getCurrentTimerTimeInSeconds];
//    
//    self.questionStartTime = [NSDate date];
//}




@end
