//
//  PKHomeVC.h
//  Xenon
//
//  Created by SadikAli on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "PKDetailsVC.h"
#import "IndustrialHomeVC.h"
#import "App_GeneralUtilities.h"


@interface PKHomeVC : App_TableViewController<dataSourceDelegate,UIAlertViewDelegate>
{
    
}

- (void)configureCell:(DefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
