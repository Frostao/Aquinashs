//
//  SettingsViewController.m
//  Aquinashs
//
//  Created by Carl Chen on 8/23/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewDidAppear:(BOOL)animated{
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    
    UITableViewCell *cell= [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] ];
    
    
    cell.detailTextLabel.text=tmp.studentid;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (indexPath.section == 0) {
        
        if (indexPath.row==1) {
            MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString *currentGrade;
            currentGrade=[defaults objectForKey:@"currentGrade"];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation removeObject:currentGrade forKey:@"channels"];
            [currentInstallation saveInBackground];
            [defaults setObject:NULL forKey:@"username"];
            [defaults setObject:NULL forKey:@"password"];
            [defaults setObject:NULL forKey:@"login"];
            tmp.username=NULL;
            tmp.password=NULL;
            tmp.classes=NULL;
            tmp.studentid=NULL;
            tmp.userType=@"PARENT";
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
            UIViewController *login= [storyboard instantiateViewControllerWithIdentifier:@"login"];
            login.modalPresentationStyle=UIModalPresentationPageSheet;
            login.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            [self presentViewController:login  animated:YES completion:nil];
            }
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:nil];
                UIViewController *login= [storyboard instantiateViewControllerWithIdentifier:@"login"];
                [self presentViewController:login  animated:YES completion:nil];
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedout" object:nil];
            
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row==0) {
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    [self displayComposerSheet];
                }
                else
                {
                    [self launchMailAppOnDevice];
                }
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
	picker.mailComposeDelegate= self;
	[picker setSubject:@"Something about Aquinas"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"chawk9621@gmail.com"];
    
	[picker setToRecipients:toRecipients];
	[self presentViewController:picker  animated:YES completion:nil];
	
}
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:chawk9621@gmail.com";
	
	NSString *email = [NSString stringWithFormat:@"%@", recipients];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
