//
//  MySingletonCenter.m
//  Aquinas
//
//  Created by Zhen Chen on 4/28/13.
//  Copyright (c) 2013 Zhen Chen. All rights reserved.
//

#import "MySingletonCenter.h"


@implementation MySingletonCenter

static MySingletonCenter *shared = NULL;

@synthesize username,password,studentid,classes,userType;




+ (MySingletonCenter *)sharedSingleton
{
    @synchronized(shared)
    {
        if ( !shared || shared == NULL )
        {
            // allocate the shared instance, because it hasn't been done yet
            shared = [[MySingletonCenter alloc] init];
        }
        
        return shared;
    }
}





@end

