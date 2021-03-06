//
//  IndustrialDetailsVC.h
//  Xenon
//
//  Created by Mahendra on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "App_GeneralUtilities.h"

@interface IndustrialDetailsVC : App_TableViewController
{
    NSString* entityItem;
    
    CGPoint gestureStartPoint;
}

@property(nonatomic,retain)NSString* entityItem;


-(id)initWithEntityItem:(NSString*)selectedEntity;
- (void)configureCell:(DefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath;

-(void)onHomeClicked;

@end
