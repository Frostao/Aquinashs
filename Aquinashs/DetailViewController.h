//
//  DetailViewController.h
//  Aquinashs
//
//  Created by Carl Chen on 8/14/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
