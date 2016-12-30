//
//  HistoryViewController.m
//  math
//
//  Created by Jeff Huang on 9/28/14.
//
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playerSinceValue;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesPlayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimePlayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageSessionLabel;



@property (weak, nonatomic) IBOutlet UILabel *gamesPlayedValue;
@property (weak, nonatomic) IBOutlet UILabel *totalTimePlayedValue;
@property (weak, nonatomic) IBOutlet UILabel *totalAccuracyValue;
@property (weak, nonatomic) IBOutlet UILabel *averageSessionValue;

@end

@implementation HistoryViewController

@synthesize userID;
@synthesize userName;

@synthesize playerSinceValue;
@synthesize loadingLabel;
@synthesize gamesPlayedLabel;
@synthesize totalTimePlayedLabel;
@synthesize totalAccuracyLabel;
@synthesize averageSessionLabel;
@synthesize gamesPlayedValue;
@synthesize totalTimePlayedValue;
@synthesize totalAccuracyValue;
@synthesize averageSessionValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"User id and name: %@, %@", userID, userName);
    
    // Fetch data from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"GameEnd"];
    [query whereKey:@"uid" equalTo:userID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d games.", objects.count);
            
            [self setStatsVisible:true];
            
            int gamesPlayed = objects.count;
            gamesPlayedValue.text = [NSString stringWithFormat:@"%d", gamesPlayed];
            
            int totalTimePlayed = 0;
            int totalCorrect = 0;
            int totalWrong = 0;
            NSDate *earliest = [NSDate date];
            
            // Do something with the found objects
            for (PFObject *object in objects) {
                //int longestStreak = object[@"longestStreak"];
                int correct = [object[@"totalCorrect"] intValue];
                int wrong = [object[@"totalWrong"] intValue];
                int sessionLength = [object[@"sessionLength"] intValue];
                
                NSDate *createdAt = object.createdAt;

                totalTimePlayed += sessionLength;
                totalCorrect += correct;
                totalWrong += wrong;
                
                if (createdAt < earliest) {
                    earliest = createdAt;
                }
            }
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMM d, ''yy"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
            NSString *timeString=[dateFormatter stringFromDate:earliest];
            playerSinceValue.text = timeString;
            
            
            totalTimePlayedValue.text = [NSString stringWithFormat:@"%d seconds", totalTimePlayed];
            if (totalWrong + totalCorrect > 0) {
                float accuracy = totalCorrect / (float)(totalCorrect + totalWrong);
                totalAccuracyValue.text = [NSString stringWithFormat:@"%.2f%%", accuracy];
            } else {
                totalAccuracyValue.text = @"100%";
            }
            
            if (gamesPlayed > 0) {
                double average = totalTimePlayed / gamesPlayed;
                averageSessionValue.text = [NSString stringWithFormat:@"%.2f seconds", average];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
            [self setStatsVisible:false];
            [loadingLabel setText:@"Couldn't load data"];
        }
    }];
    
}

- (void)setStatsVisible:(BOOL)visible
{
    if (visible) {
        [loadingLabel setHidden:true];
    }
    [gamesPlayedLabel setHidden:!visible];
    [totalTimePlayedLabel setHidden:!visible];
    [totalAccuracyLabel setHidden:!visible];
    [averageSessionLabel setHidden:!visible];
    [gamesPlayedValue setHidden:!visible];
    [totalTimePlayedValue setHidden:!visible];
    [totalAccuracyValue setHidden:!visible];
    [averageSessionValue setHidden:!visible];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
