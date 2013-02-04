//
//  AXCDetailsSubVC.h
//  Xenon
//
//  Created by SadikAli on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface AXCDetailsSubVC : App_TableViewController
{
    NSString* entitySubItem;
}

@property(nonatomic,retain)NSString* entitySubItem;

-(id)initWithEntityItem:(NSString*)selectedEntity;

@end
