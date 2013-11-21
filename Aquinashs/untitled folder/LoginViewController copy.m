//
//  LoginViewController.m
//  Aquinashs
//
//  Created by Carl Chen on 8/16/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import "LoginViewController.h"

#import "DetailViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)login:(id)sender{
    self.detailViewController.userName= username;
    self.detailViewController.password = password.text;
    [username resignFirstResponder];
    [password resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginViewControllerDismissed" object:nil];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject]topViewController];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [username resignFirstResponder];
    [password resignFirstResponder];
}


@end
