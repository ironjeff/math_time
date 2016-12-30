//
//  SummaryControllerViewController.m
//  math
//
//  Created by Jeff Huang on 12/2/12.
//
//

#import "SummaryControllerViewController.h"
#import "homeViewControllerViewController.h"

@interface SummaryControllerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *correctdLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;

@end

@implementation SummaryControllerViewController

@synthesize correct;
@synthesize wrong;
@synthesize streak;
@synthesize length;

- (void)viewDidLoad
{
    NSLog(@"Summary controller viewDidLoad %d, %d, %d", correct, wrong, streak);
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[homeViewControllerViewController adaptiveImageNamed:@"summary"]]];

    self.correctdLabel.text = [[NSString alloc] initWithFormat:@"%i", correct];
    self.wrongLabel.text = [[NSString alloc] initWithFormat:@"%i", wrong];
    self.streakLabel.text = [[NSString alloc] initWithFormat:@"%i", streak];
    
    [[self.mainMenuButton layer] setCornerRadius:10.0f];
    [[self.mainMenuButton layer] setBorderWidth:1.0f];
    [[self.mainMenuButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    self.timeLabel.text = length;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
