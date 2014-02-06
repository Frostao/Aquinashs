//
//  SettingsViewController.h
//  Aquinashs
//
//  Created by Carl Chen on 8/23/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySingletonCenter.h"
#import <messageui/MFMailComposeViewController.h>
@interface SettingsViewController : UITableViewController<MFMailComposeViewControllerDelegate>{
    IBOutlet UITableView *tableview;
}




@end
