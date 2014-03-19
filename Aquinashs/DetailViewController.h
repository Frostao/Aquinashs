//
//  DetailViewController.h
//  Aquinashs
//
//  Created by Carl Chen on 8/14/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Parse/Parse.h>
#import "MySingletonCenter.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate,ADBannerViewDelegate,GADBannerViewDelegate>{
    UIWebView *webview;
    GADBannerView *GADbanner;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UILabel *loadingLabel;
    IBOutlet ADBannerView *adBanner;
}




@property (nonatomic,retain) IBOutlet UIWebView *webview;


-(void)setupNotification;
- (void)configureView;
-(void)loadWebsite;
-(void)showLoginViewForIpad;
-(void)showLoginViewForIphone;
-(BOOL)login;

-(void)getclasslists;

-(void)logout;

-(void)showGrades;


-(void)logintoRenweb;
-(void)getStudentId;

@end
