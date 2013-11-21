//
//  LoginViewController.h
//  Aquinashs
//
//  Created by Carl Chen on 8/16/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySingletonCenter.h"


@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIActivityIndicatorView *spinner;

}
-(IBAction)login:(id)sender;
-(IBAction)teacher:(id)sender;
-(IBAction)userTypeSwitch:(id)sender;
-(IBAction)gradeSwitch:(id)sender;

@end
