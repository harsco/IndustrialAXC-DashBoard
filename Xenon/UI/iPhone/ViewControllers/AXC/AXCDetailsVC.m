//
//  AXCDetailsVC.m
//  Xenon
//
//  Created by SadikAli on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AXCDetailsVC.h"

@implementation AXCDetailsVC
@synthesize entityItem;

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
        self.entityItem = selectedEntity;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [super dealloc];
    RELEASE_TO_NIL(dataSource);
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
    self.title =self.entityItem;
    [self.refreshButton setHidden:YES];
    
     dataSource = [[DataSource alloc] init];
    dataSourceArray = [[dataSource getEntityListItemsWithEntity:self.entityItem Type:AXC] retain];
    
    int i = 50* [dataSourceArray count];
    
    if(i<300)
        [self setTableFrame:CGRectMake(0, 16, 320, i)];
    else
        [self setTableFrame:CGRectMake(0, 16, 320, 300)];
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

#pragma mark touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    gestureStartPoint = [touch locationInView:self.view];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];    
    
    CGFloat deltaX = fabsf(gestureStartPoint.x - currentPosition.x);
    CGFloat deltaY = fabsf(gestureStartPoint.y - currentPosition.y);
    
    
    if(deltaX >= kMinimumGestureLength && deltaY <=     kMaximumVariance){
        NSLog(@"Horizontal Swipe Detected");
        //[self performSelector:@selector(eraseText)
        // withObject:nil afterDelay:10];
        //self.imageView1.frame = CGRectMake(0, 20, 206, 204);
        
        //comment this line if Swipe action is not needed
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else if(deltaY >= kMinimumGestureLength && deltaX <=   kMaximumVariance){
        NSLog(@"Vertical Swipe Detected");
        //[self performSelector:@selector(eraseText) withObject:nil
        // afterDelay:10];
    }
}

#pragma mark Home Button
-(void)onHomeClicked
{
    [[App_GeneralUtilities getInstance] setIsHomeClicked:YES];
    self.tabBarController.selectedIndex = 0;
    
}



#pragma mark Table method overrides


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSourceArray count];
} 

- (void)configureCell:(DefaultCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_item_bg.png"]] autorelease];
    
    cell.cellText.text = [[dataSourceArray objectAtIndex:indexPath.row] name];
    cell.cellSubText.text = [(entityItem*)[dataSourceArray objectAtIndex:indexPath.row] value];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[dataSource getEntityListSubItemsForItem:[(entityItem*)[dataSourceArray objectAtIndex:indexPath.row] value]] count])
    {
        AXCDetailsSubVC* detailsVC = [[AXCDetailsSubVC alloc] initWithEntityItem:[(entityItem*)[dataSourceArray objectAtIndex:indexPath.row] value]];
        [self.navigationController pushViewController:detailsVC animated:YES];
        [detailsVC release];
    }
}



@end
