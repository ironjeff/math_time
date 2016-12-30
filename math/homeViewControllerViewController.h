//
//  homeViewControllerViewController.h
//  math
//
//  Created by Jeff Huang on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface homeViewControllerViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

+ (UIImage *)adaptiveImageNamed:(NSString *)name;

@end
