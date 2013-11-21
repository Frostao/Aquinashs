//
//  MySingletonCenter.h
//  Aquinas
//
//  Created by Zhen Chen on 4/28/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySingletonCenter : NSObject {
    
// Variables
    
    NSString *username;
    NSString *password;
    NSString *userType;
    NSString *studentid;
    NSMutableArray *classes;

}

// Property settings for variables

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userType;
@property (nonatomic, retain) NSString *studentid;
@property (nonatomic, retain) NSMutableArray *classes;

// The method to access this Singleton class
+ (MySingletonCenter *)sharedSingleton;

@end
