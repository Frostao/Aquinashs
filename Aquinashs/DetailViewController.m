//
//  DetailViewController.m
//  Aquinashs
//
//  Created by Carl Chen on 8/14/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import "DetailViewController.h"
#import "LoginViewController.h"


@interface DetailViewController (){
    NSMutableArray *classes;
    int classindex;
    int classquarter;
    NSString *date;
    NSString *studentid;
    BOOL shouldShowGrade;
    NSString *resetEmail;
    BOOL rotateGrade;
    BOOL ad;
    
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end



@implementation DetailViewController

@synthesize webview;



- (void)configureView
{
    // Update the user interface for the detail item.
    
    
}

- (void)viewDidLoad
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    GADbanner=[[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case 1:
            GADbanner.frame = CGRectMake(150,
                                         900,
                                         GADbanner.frame.size.width,
                                         GADbanner.frame.size.height);
            break;
        case 2:
            GADbanner.frame = CGRectMake(150,
                                         900,
                                         GADbanner.frame.size.width,
                                         GADbanner.frame.size.height);
            break;
        case 3:
            GADbanner.frame = CGRectMake(150,
                                         644,
                                         GADbanner.frame.size.width,
                                         GADbanner.frame.size.height);
            break;
        case 4:
            GADbanner.frame = CGRectMake(150,
                                         644,
                                         GADbanner.frame.size.width,
                                         GADbanner.frame.size.height);
            break;
        default:
            break;
    }
    }else{
        GADbanner=[[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        GADbanner.frame = CGRectMake(0, 518, GADbanner.frame.size.width, GADbanner.frame.size.height);
    }
    GADbanner.adUnitID=@"ca-app-pub-3839520621729354/9885156027";
    GADbanner.rootViewController = self;
    GADbanner.delegate=self;
    [self.view addSubview:GADbanner];
    GADRequest *request=[GADRequest request];
    
    [GADbanner loadRequest:request];
    
    GADbanner.hidden=YES;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ad=[defaults boolForKey:@"ad"];
    if (ad) {
        adBanner.hidden=NO;
        
    }else{
        adBanner.hidden=YES;
        
    }
    webview.hidden=YES;
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    studentid = tmp.studentid;
    
    NSString *year = [[[NSDate date] description] substringToIndex:4];
    NSString *month = [[[NSDate date] description] substringWithRange:NSMakeRange(5, 2)];
    NSString *day= [[[NSDate date] description] substringWithRange:NSMakeRange(8, 2)];
    date = [NSString stringWithFormat:@"%@/%@/%@",month,day,year];
    
    spinner.hidesWhenStopped=YES;
    [spinner startAnimating];
    loadingLabel.hidden=NO;
    self.navigationController.navigationBar.translucent=NO;
    
    if (self.login) {
       
    }else{
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self showLoginViewForIpad];
        }
        
        
    }
    
    
    
    
    [self setupNotification];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    if(self.login){
        [self loadWebsite];
    }else{
        tmp.userType=@"PARENT";
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if (self.login) {
            
        }else{
            [self showLoginViewForIphone];
        }
    }
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    
    if([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"ParentsWeb ~ Login"]){
        
        NSString *error;
        error = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('loginbox').getElementsByTagName('form')[0].getElementsByTagName('fieldset')[0].getElementsByTagName('h3')[0].innerHTML"];
        
        if (error.length == 0 ) {
            if (tmp.username != NULL) {
                [self logintoRenweb];
            }
        }else if([error isEqualToString:@"Error: Invalid Credentials."]){
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your username or password is incorrect. Please check." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else if([error isEqualToString:@"Error: Invalid Credentials"]){
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your username or password is incorrect. Please check." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else if ([error isEqualToString:@"Error: User is not correctly configured for accessing ParentsWeb as a Parent. Have school verify that parent's family is web enabled and that parent is correctly linked to a student."]){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"User is not correctly configured for accessing ParentsWeb as a Parent. Please check if you selected the correct user type." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else if ([error isEqualToString:@"Error: User is not correctly configured for accessing ParentsWeb as a Student."]){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"User is not correctly configured for accessing ParentsWeb as a Student. Please check if you selected the correct user type." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }else if ([error isEqualToString:@"Error: Invalid Credentials. Account locked due to invalid login attempts - use forgot password link to reset password."]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"Account locked due to invalid login attempts, please enter your student email below to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle= UIAlertViewStylePlainTextInput;
            [alert show];
        }else if ([error isEqualToString:@"Error: Account locked due to invalid login attempts - use forgot password link to reset password."]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"Account locked due to invalid login attempts, please enter your student email below to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle= UIAlertViewStylePlainTextInput;
            [alert show];
        }else if ([error isEqualToString:[NSString stringWithFormat:@"An email has been sent to %@ with instructions for how to reset your password.",resetEmail]]){
            [[[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"An email has been sent to %@ with instructions for how to reset your password.",resetEmail] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }
    
    
    
    
    
    
    if([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"ParentsWeb ~ Reset Password"]){
        NSString *error;
        error = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('frm').getElementsByTagName('fieldset')[0].getElementsByTagName('h3')[0].innerHTML"];
        if ([error isEqualToString:@"Email Not Found."]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Found." message:@"Email Not Found. Please re-enter your email address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle= UIAlertViewStylePlainTextInput;
            [alert show];
        }else{
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.getElementById('email').value = '%@'",resetEmail]];
        [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('submit').click();"];
        }
    }
    
    
    
    
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"Aquinas High School - School Information"]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"login"];
        [defaults setObject:tmp.username forKey:@"username"];
        [defaults setObject:tmp.password forKey:@"password"];
        [defaults setObject:tmp.userType forKey:@"userType"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedin" object:nil];
        NSString *studentName = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('div')[3].getElementsByTagName('section')[1].getElementsByTagName('h3')[0].innerHTML;"];
        NSRange lastName = [studentName rangeOfString:@" " options:NSBackwardsSearch];
        NSRange firstName = [studentName rangeOfString:@" " options:NSLiteralSearch];
        
        studentName =[NSString stringWithFormat:@"%@%@",[studentName substringToIndex:firstName.location], [studentName substringFromIndex:lastName.location+1]];
        
        
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:studentName forKey:@"channels"];
        [currentInstallation saveInBackground];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://aq-ca.client.renweb.com/pw/student/grades.cfm" ]]];
        
        
    }
    
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"Aquinas High School - Grades"]){
        [self getStudentId];
        [self getclasslists];
        if (shouldShowGrade) {
            [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('gradebook_%@_%d_%d').submit();",tmp.studentid,classindex,classquarter]];
        }
        [spinner stopAnimating];
        loadingLabel.hidden=YES;
        
        
    }
    
    
    
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('table')[0].getElementsByTagName('tr')[0].getElementsByTagName('font')[0].innerHTML"] isEqualToString:@"Grade Book Student Progress Report"]) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
        webview.scalesPageToFit=NO;
        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
                case 1:
                    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.25;"];
                    break;
                case 2:
                    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.25;"];
                    break;
                case 3:
                    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.15;"];
                    break;
                case 4:
                    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.15;"];
                    break;
                default:
                    break;
            }
            
        
        [spinner stopAnimating];
        loadingLabel.hidden=YES;
        webview.hidden=NO;
        }
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            webview.scalesPageToFit=NO;
            webview.hidden=NO;
            [spinner stopAnimating];
            loadingLabel.hidden=YES;
            
            
        }
        adBanner.hidden=YES;
        GADbanner.hidden=YES;
        ad=NO;
        rotateGrade=YES;
    }
    
    
    
        if([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"Aquinas High School - Homework"]){
            rotateGrade=NO;
            [spinner stopAnimating];
            webview.hidden=NO;
            loadingLabel.hidden=YES;
        
    }
    if([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"Aquinas High School - Lesson Plans"]){
        rotateGrade=NO;
        [spinner stopAnimating];
        webview.hidden=NO;
        loadingLabel.hidden=YES;
        
    }
    if([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"Aquinas High School - Attendance"]){
        rotateGrade=NO;
        [spinner stopAnimating];
        webview.hidden=NO;
        loadingLabel.hidden=YES;
    }
    if([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"Aquinas High School - Behavior"]){
        rotateGrade=NO;
        [spinner stopAnimating];
        webview.hidden=NO;
        loadingLabel.hidden=YES;
    }
    if([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@"Aquinas High School - Calendar"]){
        rotateGrade=NO;
        [spinner stopAnimating];
        webview.hidden=NO;
        loadingLabel.hidden=YES;
        [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.3;"];
    }
    
    
        
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        GADbanner.frame = CGRectMake(150,
                                     900,
                                     GADbanner.frame.size.width,
                                     GADbanner.frame.size.height);
        if (rotateGrade) {
            [webview reload];
           
        }
        
        
    }
    else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        GADbanner.frame = CGRectMake(150,
                                     644,
                                     GADbanner.frame.size.width,
                                     GADbanner.frame.size.height);
        if (rotateGrade) {
            [webview reload];
        }
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
       if (alertView.alertViewStyle== UIAlertViewStylePlainTextInput) {
        resetEmail = [alertView textFieldAtIndex:0].text;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://aq-ca.client.renweb.com/pw/forgot-login.cfm"]]];
    } 
    }
    
    
}






-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You need Internet to use this app. Please check your Internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


-(void)logintoRenweb{
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value = '%@'",tmp.username]];
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value = '%@'",tmp.password]];
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.getElementById('UserType').value = 'PARENTSWEB-%@'",tmp.userType]];
    [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('submit').click();"];
}

-(void)getStudentId{
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    studentid= [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('tab-me-student-list').getElementsByTagName('li')[0].getElementsByTagName('a')[0].href"];
    tmp.studentid= [studentid substringFromIndex: [studentid length] - 7];
    studentid=tmp.studentid;
    
}

-(void)getclasslists{
    MySingletonCenter *tmp=[MySingletonCenter sharedSingleton];
    classes=[NSMutableArray arrayWithObjects:@"void", nil];
    
    for (int i=0; i<7; i++) {
        NSString *class;
        class = [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('gradebook_%@').getElementsByTagName('form')[0].getElementsByTagName('select')[0].getElementsByTagName('option')[%d].innerHTML",tmp.studentid,i]];
        
        NSString *classPeriod =[class substringFromIndex:[class length]-2 ] ;
        classPeriod=[classPeriod substringToIndex:1];
        NSRange range= [class rangeOfString:@"(" options:NSBackwardsSearch];
        class = [class substringToIndex:range.location-1];
        [classes addObject:classPeriod];
        [classes addObject:class];
        
    }
    tmp.classes=classes;
}




-(BOOL)login{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"login"];
}




-(void)showLoginViewForIpad{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    UIViewController *login= [storyboard instantiateViewControllerWithIdentifier:@"login"];
    login.modalPresentationStyle=UIModalPresentationPageSheet;
    login.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:login  animated:YES completion:nil];
}

-(void)showLoginViewForIphone{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:nil];
    UIViewController *login= [storyboard instantiateViewControllerWithIdentifier:@"login"];
    
    [self presentViewController:login  animated:YES completion:nil];
}


-(void)setupNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissLoginViewController:) name:@"loginViewControllerDismissed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout:) name:@"loggedout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectClass:) name:@"classSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectClassAndQuarter:) name:@"classAndQuarterSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectHomework:) name:@"homeworkSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAttendance:) name:@"attendanceSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBehavior:) name:@"behaviorSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectLessonPlan:) name:@"lessonPlanSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCalendar:) name:@"calendarSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectAnnouncement:) name:@"announcementSelected" object:nil];
    
}

-(void)didSelectAnnouncement:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"announcementSelected"]) {
    }
}

-(void)didSelectCalendar:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"calendarSelected"]) {
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        NSString *year = [[[NSDate date] description] substringToIndex:4];
        NSString *month = [[[NSDate date] description] substringWithRange:NSMakeRange(5, 2)];
        NSString *day= [[[NSDate date] description] substringWithRange:NSMakeRange(8, 2)];
        [spinner startAnimating];
        loadingLabel.hidden=NO;
        webview.hidden=YES;
        webview.scalesPageToFit=YES;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aq-ca.client.renweb.com/pw/school/calendar-print.cfm?filter=ALL&studentid=&view=calendar&month=%@&year=%@&day=%@&range=month",month,year,day ]]]];
    }
}



-(void)didSelectHomework:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"homeworkSelected"]) {
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        [spinner startAnimating];
        loadingLabel.hidden=NO;
        webview.hidden=YES;
        webview.scalesPageToFit=YES;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://aq-ca.client.renweb.com/pw/student/homework-print.cfm?studentid=%@&weekof=%@&events=0",studentid,date ]]]];
        
        
    }
}

-(void)didSelectAttendance:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"attendanceSelected"]) {
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        [spinner startAnimating];
        loadingLabel.hidden=NO;
        webview.hidden=YES;
        webview.scalesPageToFit=YES;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://aq-ca.client.renweb.com/pw/student/attendance.cfm"]]];
        
    }
}

-(void)didSelectBehavior:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"behaviorSelected"]) {
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        [spinner startAnimating];
        loadingLabel.hidden=NO;
        webview.hidden=YES;
        webview.scalesPageToFit=YES;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://aq-ca.client.renweb.com/pw/student/behavior.cfm"]]];
        
        
    }
}

-(void)didSelectLessonPlan:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"lessonPlanSelected"]) {
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        [spinner startAnimating];
        loadingLabel.hidden=NO;
        webview.hidden=YES;
        webview.scalesPageToFit=YES;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://aq-ca.client.renweb.com/pw/student/lesson-plans-print.cfm?studentid=%@&weekof=%@",studentid,date ]]]];
        
    }
}



-(void)didDismissLoginViewController:(NSNotification *) notification{
    
    
    if ([notification.name isEqualToString:@"loginViewControllerDismissed"]) {
        
        [self loadWebsite];
        
    }
    
}

-(void)didSelectClassAndQuarter:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"classAndQuarterSelected"]) {
         classquarter = [[[notification userInfo] valueForKey:@"classQuarter"] intValue];
        [self showGrades];
        [spinner startAnimating];
        loadingLabel.hidden=NO;
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
        webview.hidden=YES;
        shouldShowGrade = YES;
    }
}

-(void)didSelectClass:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"classSelected"]) {
        classindex = [[[notification userInfo] valueForKey:@"classIndex"] intValue];
    }
}



-(void)showGrades{
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://aq-ca.client.renweb.com/pw/student/grades.cfm" ]]];
    
}




-(void)didLogout:(NSNotification *) notification{
    if ([notification.name isEqualToString:@"loggedout"]) {
    [self logout];
    }
}

-(void)logout{
    webview.hidden=YES;
    shouldShowGrade=NO;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://aq-ca.client.renweb.com/pw/?LogOut=1" ]]];
}


-(void)loadWebsite{
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://aq-ca.client.renweb.com/pw/" ]]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"didFailToReceiveAdWithError %@", error);
    adBanner.hidden=YES;
    
    
    if (ad) {
        
        GADbanner.hidden=NO;
    }
    
    
}
- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error;{
    GADbanner.hidden=YES;
}


@end
