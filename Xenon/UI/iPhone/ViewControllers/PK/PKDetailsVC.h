//
//  PKDetailsVC.h
//  Xenon
//
//  Created by SadikAli on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "App_GeneralUtilities.h"


@interface PKDetailsVC : App_TableViewController
{
    NSString* entityItem;
    
    CGPoint gestureStartPoint;
}

@property(nonatomic,retain)NSString* entityItem;

-(id)initWithEntityItem:(NSString*)selectedEntity;
- (void)configureCell:(DefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
