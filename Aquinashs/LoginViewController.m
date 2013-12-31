//
//  LoginViewController.m
//  Aquinashs
//
//  Created by Carl Chen on 8/16/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>


@interface LoginViewController () {
    NSString *currentGrade;
}
@end



@implementation LoginViewController




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




-(IBAction)login:(id)sender{
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    
    tmp.password=passwordField.text;
    tmp.username=usernameField.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginViewControllerDismissed" object:nil];
    spinner.hidden=NO;
    [spinner startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:@"loggedin" object:nil];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

-(void)didLogin:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"loggedin"]) {
        
        [spinner stopAnimating];
        [self dismissViewControllerAnimated:YES completion:NULL];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:currentGrade forKey:@"channels"];
        [currentInstallation saveInBackground];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    spinner.hidesWhenStopped=YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"currentGrade"]==NULL){
    
        currentGrade=@"Freshman";
        [defaults setObject:currentGrade forKey:@"currentGrade"];
    }else{
        currentGrade=[defaults objectForKey:@"currentGrade"];
    }
	// Do any additional setup after loading the view, typically from a nib.
    
    
}


-(IBAction)userTypeSwitch:(id)sender{
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        tmp.userType=@"PARENT";
    }else if (selectedSegment == 1){
        tmp.userType =@"STUDENT";
    }
}

-(IBAction)gradeSwitch:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        currentGrade=@"Freshman";
    }else if (selectedSegment == 1){
        currentGrade=@"Sophomore";
    }else if (selectedSegment == 2){
        currentGrade=@"Junior";
    }else if (selectedSegment == 3){
        currentGrade=@"Senior";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentGrade forKey:@"currentGrade"];
}


-(IBAction)teacher:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login as a teacher" message:@"Please enter the account information as for teachers." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle= UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *username = [alertView textFieldAtIndex:0].text;
        NSString *password =[alertView textFieldAtIndex:1].text;
        if ([username isEqualToString:@"aquinas"]) {
            if ([password isEqualToString:@"aquinasteacher"]) {
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation addUniqueObject:@"teachers" forKey:@"channels"];
                [currentInstallation saveInBackground];
                [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Thank you for using this app. You are all set. You don't need to log in as either student or parent. More features for teachers are coming." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
