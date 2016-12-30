//
//  homeViewControllerViewController.m
//  math
//
//  Created by Jeff Huang on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "homeViewControllerViewController.h"
#import "GameViewController.h"

@interface homeViewControllerViewController ()

@end

@implementation homeViewControllerViewController {
    NSString *_userID;
    NSString *_userName;
    bool _isUserNameSet;
}

@synthesize startGameButton;
@synthesize historyButton;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"== homeviewController::prepareForSegue %@", segue.identifier);
    
    GameViewController *controller = (GameViewController*)segue.destinationViewController;
    controller.userID = _userID;
    controller.userName = _userName;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"View did appear");
    // Couldn't get the image asset 3x to work for 6 and 6plus
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[homeViewControllerViewController adaptiveImageNamed:@"background"]]];
    
    // Initialize Button Styles
    [[startGameButton layer] setBorderWidth:2.0f];
    [[startGameButton layer] setCornerRadius:10.0f];
    [[startGameButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [[historyButton layer] setBorderWidth:2.0f];
    [[historyButton layer] setCornerRadius:10.0f];
    [[historyButton layer] setBorderColor:[UIColor blackColor].CGColor];
    //[super viewDidAppear:animated];
    
    [self initUser];
}


// Stupid shit to handle the 6 and 6 plus
+ (NSString *)resolveAdaptiveImageName:(NSString *)nameStem {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height > 568.0f) {
        // Oversize @2x will be used for iPhone 6, @3x for iPhone 6+
        // iPads... we'll work that out later
        if (height > 667.0f) {
            return [nameStem stringByAppendingString:@"-oversize@3x"];
        } else {
            return [nameStem stringByAppendingString:@"-oversize"];
        }
    };
    return nameStem;
}

+ (UIImage *)adaptiveImageNamed:(NSString *)name {
    return [UIImage imageNamed:[self resolveAdaptiveImageName:name]];
}

- (void)initUser
{
    //[self saveUserName:@""];
    //return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"userID"];
    if (userID) {
        _userID = userID;
    } else {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        _userID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        [defaults setObject:_userID forKey:@"userID"];
    }
    NSLog(@"User id: %@", _userID);
    
    
    NSString *userName = [defaults objectForKey:@"userName"];
    NSLog(@"User name: %@", userName);
    if (userName.length > 0) {
        _userName = userName;
        _isUserNameSet = true;
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Hi, what's your name?" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:nil];
        alert.tag = 12;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"dismiss button index %d", buttonIndex);
    if (alertView.tag == 12) {
        if (buttonIndex == 0) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            NSLog(@"username entered: %@", textfield.text);
            if (textfield.text.length == 0) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops! Try again." message:@"What's your name?" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:nil];
                alert.tag = 12;
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
            } else {
                _userName = textfield.text;
                [self saveUserName:textfield.text];
                _isUserNameSet = true;
            }
        }
    }
}

-(void)saveUserName:(NSString *)name
{
    NSLog(@"Saving username %@", name);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  //load NSUserDefaults
    [defaults setObject:name forKey:@"userName"];
    
    PFObject *user = [PFObject objectWithClassName:@"User"];
    user[@"name"] = name;
    [user saveInBackground];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setStartGameButton:nil];
    [self setHistoryButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
