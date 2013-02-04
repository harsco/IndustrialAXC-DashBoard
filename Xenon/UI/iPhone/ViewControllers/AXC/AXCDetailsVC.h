//
//  AXCDetailsVC.h
//  Xenon
//
//  Created by SadikAli on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "App_GeneralUtilities.h"
#import "AXCDetailsSubVC.h"


@interface AXCDetailsVC : App_TableViewController
{
     NSString* entityItem;
    
    CGPoint gestureStartPoint;
    DataSource* dataSource;
}
@property(nonatomic,retain)NSString* entityItem;

-(id)initWithEntityItem:(NSString*)selectedEntity;
- (void)configureCell:(DefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
