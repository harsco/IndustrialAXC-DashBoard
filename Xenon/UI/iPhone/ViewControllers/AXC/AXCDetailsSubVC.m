//
//  AXCDetailsSubVC.m
//  Xenon
//
//  Created by SadikAli on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXCDetailsSubVC.h"

@interface AXCDetailsSubVC ()

@end

@implementation AXCDetailsSubVC
@synthesize entitySubItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"App_TableViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithEntityItem:(NSString*)selectedEntity
{
    self = [super init];
    
    if(self)
    {
        //self.entityItem = [[NSString alloc] initWithString:selectedEntity];
        self.entitySubItem = selectedEntity;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =self.entitySubItem;
    [self.refreshButton setHidden:YES];
    
    DataSource* dataSource = [[DataSource alloc] init];
    dataSourceArray = [[dataSource getEntityListSubItemsForItem:self.entitySubItem] retain];
    RELEASE_TO_NIL(dataSource);
    int i = 50* [dataSourceArray count];
    
    if(i<300)
    [self setTableFrame:CGRectMake(0, 16, 320, i)];
    else
    [self setTableFrame:CGRectMake(0, 16, 320, 300)];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//	[label setFont:[UIFont boldSystemFontOfSize:16.0]];
//	[label setBackgroundColor:[UIColor clearColor]];
//	[label setTextColor:[UIColor whiteColor]];
//	[label setText:self.title];
//    [label sizeToFit];
//	[self.navigationController.navigationBar.topItem setTitleView:label];
//	[label release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark Table method overrides


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count is %d",[dataSourceArray count]);
    return [dataSourceArray count];
} 

- (void)configureCell:(DefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item_bg.png"]] autorelease];
    
    cell.cellText.text = [[dataSourceArray objectAtIndex:indexPath.row] name];
    cell.cellSubText.text = [[dataSourceArray objectAtIndex:indexPath.row] value];
}

@end
