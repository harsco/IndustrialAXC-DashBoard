//
//  App_GeneralUtilities.h
//  Xenon
//
//  Created by Mahendra on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App_GeneralUtilities : NSObject
{
    BOOL isHomeClicked;
    
}


@property(nonatomic)BOOL isHomeClicked;

+ (App_GeneralUtilities *)getInstance;
+(void)showAlertOKWithTitle:(NSString*)title withMessage:(NSString*)message;


@end
