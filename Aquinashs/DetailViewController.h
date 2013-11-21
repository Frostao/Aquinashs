//
//  DetailViewController.h
//  Aquinashs
//
//  Created by Carl Chen on 8/14/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MySingletonCenter.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>{
    UIWebView *webview;
    IBOutlet UIActivityIndicatorView *spinner;
}




@property (nonatomic,retain) IBOutlet UIWebView *webview;


-(void)setupNotification;
- (void)configureView;
-(void)loadWebsite;
-(void)showLoginView;
-(BOOL)login;

-(void)getclasslists;

-(void)logout;

-(void)showGrades;


-(void)logintoRenweb;
-(void)getStudentId;

@end
