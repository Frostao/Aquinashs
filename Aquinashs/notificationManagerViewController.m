//
//  notificationManagerViewController.m
//  Aquinashs
//
//  Created by Carl Chen on 3/17/14.
//  Copyright (c) 2014 Zhen Chen. All rights reserved.
//

#import "notificationManagerViewController.h"

@interface notificationManagerViewController ()

@end

@implementation notificationManagerViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)quit:(id)sender{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"teacher"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
