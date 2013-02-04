//
//  IndustrialHomeVC.m
//  Xenon
//
//  Created by Mahendra on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IndustrialHomeVC.h"

@implementation IndustrialHomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"App_TableViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Resizing the Table View depending on the data
    [self setTableFrame:CGRectMake(10, 16, 300, 300)];
    [self.refreshButton setHidden:YES];
    
    //self.title = @"Industrials";
    
    self.navigationItem.rightBarButtonItem = nil;    
    [self showHUD:@"Fetching Data"];
    DataSource* dataSource = [[DataSource alloc] init];
    
    dataSource.delegate = self;
    
    [self storeRefreshTime];
    
    [dataSource getEntityListOfIndustry:IND];
    
    [dataSource release];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://axcuscatwsweb01/inddash/AppData/IndustiralsMatrixAXC.txt"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
   // receivedData = [[NSMutableData alloc] initWithLength:0];
   // NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Data Source Callbacks

-(void)dataSourceEntityListFetchDidFinish:(NSMutableArray *)entityArray
{
    [self dismissHUD];
    dataSourceArray = [entityArray retain];
    [self.defaultTableView reloadData];
    [self.refreshButton setHidden:NO];
}

-(void)dataSourceEntityListFetchDidFail:(NSError *)error
{
    [self dismissHUD];
    [App_GeneralUtilities showAlertOKWithTitle:@"Error" withMessage:[error localizedDescription]];
}


#pragma mark Action Methods

-(void)storeRefreshTime
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
   // [defaults setObject:timestamp forKey:@"INDTimeStamp"];
    [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"INDTimeStamp"];
    [defaults synchronize];
}

-(NSString*)calculateRefreshTimeDiff
{
     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    double prevTimestamp = [defaults doubleForKey:@"INDTimeStamp"];
    
    double refreshTimeDiff = [[NSDate date] timeIntervalSince1970] - prevTimestamp;
    
    NSLog(@"timediff is %f",refreshTimeDiff);
     NSLog(@"timediff is %f", round(refreshTimeDiff));
    
    //round(refreshTimeDiff)
    
    NSInteger refreshTimeDiffInMinutes = refreshTimeDiff/60;
    
    if(refreshTimeDiffInMinutes < 1)
    {
        return @"Less than a minute";
    }
    else 
    {
         return [NSString stringWithFormat:@"%d%@",refreshTimeDiffInMinutes,@" minutes"];
    }
    
    return @"default";    
    
}


-(IBAction)refreshDataNow
{
    NSLog(@"yes refreshing");
    [self showRefreshAlert];
}

-(void)showRefreshAlert
{
   //Take user option and act accordingly
    
    //[self calculateRefreshTimeDiff];
    
    UIAlertView *refreshAlert = [[UIAlertView alloc] initWithTitle:@"Refresh Alert"
                                                           message:[NSString stringWithFormat:@"%@%@%@",@"Last Refresh Time was ", [self calculateRefreshTimeDiff],@" before. Do you want to Refresh Now?"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:@"Cancel", nil];
    refreshAlert.delegate = self;
    
    [refreshAlert show];
    [refreshAlert release];
}


-(void)refreshData
{
    
    [self showHUD:@"Refreshing Data"];
    
    DataSource* dataSource = [[DataSource alloc] init];
    
    dataSource.delegate = self;
    
    [dataSource refreshDataOfIndustry:IND];
    
    //[dataSource getEntityListOfIndustry:IND];
    
    [dataSource release];
}



#pragma mark Alert view methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //refresh
        NSLog(@"refresh");
        [self storeRefreshTime];
        [self refreshData];
    }
    else
    {
        NSLog(@"cancel");
    }
}


#pragma mark Table method overrides


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSLog(@"array count is %d",[dataSourceArray count]);
    return [dataSourceArray count];
} 



- (void)configureCell:(DefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item_bg.png"]] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.cellText.text = [dataSourceArray objectAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndustrialDetailsVC* detailsVC = [[IndustrialDetailsVC alloc] initWithEntityItem:[dataSourceArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailsVC animated:YES];
    [detailsVC release];
}


@end
