//
//  LoginViewController.h
//  Aquinashs
//
//  Created by Carl Chen on 8/16/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}


-(IBAction)login:(id)sender;


@property (strong, nonatomic) DetailViewController *detailViewController;

@end
