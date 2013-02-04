//
//  DataSource.m
//  Xenon
//
//  Created by Mahendra on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
@synthesize delegate;


-(id)init
{
    if(self = [super init])
    {
        dataBase = [App_Storage getInstance];
        parser = [[ParserInterface alloc] init];
        
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
    RELEASE_TO_NIL(delegate);
}


-(void)refreshDataOfIndustry:(Industry)industry
{
    if(industry == IND)
    {
        if([[dataBase getEntityListFromTable:IND_ENTITY_LIST] count])
        {
            [dataBase deleteEntityListFromTable:IND_ENTITY_LIST];
            [dataBase deleteEntityListFromTable:IND_ENTITY_ITEMS];
            
            //NSLog(@"count of items is %d",[[dataBase getEntityListFromTable:IND_ENTITY_LIST] count]);
            [self fetchAndSendData:IND];
        }
    }
    
    else if(industry == AXC)
    {
        if([[dataBase getEntityListFromTable:AXC_ENTITY_LIST] count])
        {
            [dataBase deleteEntityListFromTable:AXC_ENTITY_LIST];
             [dataBase deleteEntityListFromTable:AXC_ENTITY_ITEMS];
             [dataBase deleteEntityListFromTable:AXC_ENTITY_SUBITEMS];
           // NSLog(@"count of items is %d",[[dataBase getEntityListFromTable:AXC_ENTITY_LIST] count]);
            [self fetchAndSendData:AXC];
        }
    }
    else if(industry == IKG)
    {
        if([[dataBase getEntityListFromTable:IKG_ENTITY_LIST] count])
        {
            [dataBase deleteEntityListFromTable:IKG_ENTITY_LIST];
            [dataBase deleteEntityListFromTable:IKG_ENTITY_ITEMS];
           
            
            // NSLog(@"count of items is %d",[[dataBase getEntityListFromTable:AXC_ENTITY_LIST] count]);
            [self fetchAndSendData:IKG];
        }
    }
    else if(industry == PK)
    {
        if([[dataBase getEntityListFromTable:PK_ENTITY_LIST] count])
        {
            [dataBase deleteEntityListFromTable:PK_ENTITY_LIST];
             [dataBase deleteEntityListFromTable:PK_ENTITY_ITEMS];
            // NSLog(@"count of items is %d",[[dataBase getEntityListFromTable:AXC_ENTITY_LIST] count]);
            [self fetchAndSendData:PK];
        }
    }



}

    
-(void)getEntityListOfIndustry:(Industry)industry
{
    
    
    if(industry == IND)
    {
       //will be replaced by actual threading logic in future
      //  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                //  [NSNumber numberWithInt:IND], @"industry",
                                  /* ... */
                                //  nil];
        //[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(sendTestData:) userInfo:userInfo repeats:NO];
        
        [self fetchAndSendData:IND];
    }
    else if(industry == AXC)
    {
       // NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 // [NSNumber numberWithInt:AXC], @"industry",
                                  /* ... */
                                 // nil];
        //[self sendTestData:AXC];
       // [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(sendTestData:) userInfo:userInfo repeats:NO];
        
        [self fetchAndSendData:AXC];
    }
    else if(industry == PK)
    {
       // NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              //    [NSNumber numberWithInt:PK], @"industry",
                                  /* ... */
                                //  nil];
        //[self sendTestData:PK];
        //[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(sendTestData:) userInfo:userInfo repeats:NO];
        
        [self fetchAndSendData:PK];
    }
    else if(industry == IKG)
    {
       // NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 // [NSNumber numberWithInt:IKG], @"industry",
                                  /* ... */
                                 // nil];
        
       // [self sendTestData:IKG];
        
       // [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(sendTestData:) userInfo:userInfo repeats:NO];
        
        [self fetchAndSendData:IKG];
    }
        
    
    
}


//API has to be matured more as currently only for AXC include all industries for future use

-(NSMutableArray*)getEntityListSubItemsForItem:(NSString*)entityItem
{
    return [dataBase getEntityListSubItemsFromTable:AXC_ENTITY_SUBITEMS ForEntity:entityItem];
}



-(NSMutableArray*)getEntityListItemsWithEntity:(NSString*)entity Type:(Industry)Industry
{
    if(Industry == IND)
    {
        return [dataBase getEntityListItemsFromTable:IND_ENTITY_ITEMS ForEntity:entity];
    }
    else if(Industry == AXC)
    {
        return [dataBase getEntityListItemsFromTable:AXC_ENTITY_ITEMS ForEntity:entity];
    }
    else if(Industry == PK)
    {
        return [dataBase getEntityListItemsFromTable:PK_ENTITY_ITEMS ForEntity:entity];
    }
    else if(Industry == IKG)
    {
        return [dataBase getEntityListItemsFromTable:IKG_ENTITY_ITEMS ForEntity:entity];
    }
    
    return [dataBase getEntityListItemsFromTable:IND_ENTITY_ITEMS ForEntity:entity];
}

-(NSMutableArray*)getEntityListItemsOfIndustry:(Industry)industry ForEntity:(NSString*)entityValue
{
    //for now pulling from DB can be nw also
    
    return [dataBase getEntityListItemsFromTable:IND_ENTITY_ITEMS ForEntity:@"finance"];
}
                                     


-(void)fetchAndSendData:(Industry)industryType
{
    //NSDictionary *userInfo = [timer userInfo];
   // int industryType = [[userInfo objectForKey:@"industry"] intValue];
    
    if(delegate && [delegate respondsToSelector:@selector(dataSourceEntityListFetchDidFinish:)])
    {
        if(industryType== IND)
        {
            if([[dataBase getEntityListFromTable:IND_ENTITY_LIST] count])
            {
                [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IND_ENTITY_LIST]];
            }
            else
            {
                
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:IND_URL]];
                
                downloaderOp.delegate = self;
                
                downloaderOp.operationType = IND;
                
                [testQueue addOperation:downloaderOp];
                
                [downloaderOp release];
                
                // [parser parseDataofIndustry:IND];
                //[delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IND_ENTITY_LIST]];
            }
            
            
        }
        else if(industryType == AXC)
        {
            if([[dataBase getEntityListFromTable:AXC_ENTITY_LIST] count])
            {
                [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:AXC_ENTITY_LIST]];
            }
            else
            {
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                //Listen for Notifications from Parser Module
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchData) name:@"dataUpdateFinished" object:nil];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:AXC_URL]];
                
                downloaderOp.delegate = self;
                
                downloaderOp.operationType = AXC;
                
                
                [testQueue addOperation:downloaderOp];
                
                [downloaderOp release];
                
                
                // [parser parseDataofIndustry:AXC];
                //[delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:AXC_ENTITY_LIST]];
            }
            
            
        }
        else if(industryType == PK)
        {
            
            if([[dataBase getEntityListFromTable:PK_ENTITY_LIST] count])
            {
                [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:PK_ENTITY_LIST]];
            }
            else
            {
                
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                //Listen for Notifications from Parser Module
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchData) name:@"dataUpdateFinished" object:nil];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:PK_URL]];
                
                downloaderOp.delegate = self;
                downloaderOp.operationType = PK;
                
                
                [testQueue addOperation:downloaderOp];
                
                [downloaderOp release];
                
                
                //[parser parseDataofIndustry:PK];
                // [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:PK_ENTITY_LIST]];
            }
            
            
        }
        else if(industryType == IKG)
        {
            
            if([[dataBase getEntityListFromTable:IKG_ENTITY_LIST] count])
            {
                [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IKG_ENTITY_LIST]];
            }
            else
            {
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                //Listen for Notifications from Parser Module
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchData) name:@"dataUpdateFinished" object:nil];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:IKG_URL]];
                
                downloaderOp.delegate = self;
                
                [testQueue addOperation:downloaderOp];
                downloaderOp.operationType = IKG;
                
                
                [downloaderOp release];
                
                
                
                //[parser parseDataofIndustry:IKG];
                //[delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IKG_ENTITY_LIST]];
            }
        }
        
        
    }

}
                                     

-(void)sendTestData:(NSTimer*)timer
{
    NSDictionary *userInfo = [timer userInfo];
    int industryType = [[userInfo objectForKey:@"industry"] intValue];
    
    if(delegate && [delegate respondsToSelector:@selector(dataSourceEntityListFetchDidFinish:)])
    {
        if(industryType== IND)
        {
            if([[dataBase getEntityListFromTable:IND_ENTITY_LIST] count])
            {
                 [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IND_ENTITY_LIST]];
            }
            else
            {
                
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:IND_URL]];
                
                downloaderOp.delegate = self;
                
                downloaderOp.operationType = IND;
                
                [testQueue addOperation:downloaderOp];
                
                [downloaderOp release];
                
               // [parser parseDataofIndustry:IND];
                //[delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IND_ENTITY_LIST]];
            }
           
           
        }
        else if(industryType == AXC)
        {
            if([[dataBase getEntityListFromTable:AXC_ENTITY_LIST] count])
            {
                [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:AXC_ENTITY_LIST]];
            }
            else
            {
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                //Listen for Notifications from Parser Module
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchData) name:@"dataUpdateFinished" object:nil];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:AXC_URL]];
                
                downloaderOp.delegate = self;
                
                downloaderOp.operationType = AXC;

                
                [testQueue addOperation:downloaderOp];
                
                [downloaderOp release];
                
                
               // [parser parseDataofIndustry:AXC];
                //[delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:AXC_ENTITY_LIST]];
            }
            
            
        }
        else if(industryType == PK)
        {
            
            if([[dataBase getEntityListFromTable:PK_ENTITY_LIST] count])
            {
                [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:PK_ENTITY_LIST]];
            }
            else
            {
                
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                //Listen for Notifications from Parser Module
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchData) name:@"dataUpdateFinished" object:nil];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:PK_URL]];
                
                downloaderOp.delegate = self;
                downloaderOp.operationType = PK;

                
                [testQueue addOperation:downloaderOp];
                
                [downloaderOp release];
                
                
                //[parser parseDataofIndustry:PK];
               // [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:PK_ENTITY_LIST]];
            }

            
        }
        else if(industryType == IKG)
        {
            
            if([[dataBase getEntityListFromTable:IKG_ENTITY_LIST] count])
            {
                [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IKG_ENTITY_LIST]];
            }
            else
            {
                NSOperationQueue* testQueue = [[NSOperationQueue alloc] init];
                [testQueue setMaxConcurrentOperationCount:1];
                
                //Listen for Notifications from Parser Module
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchData) name:@"dataUpdateFinished" object:nil];
                
                
                DataDownloadOperation* downloaderOp = [[DataDownloadOperation alloc] initWithURL:[NSURL URLWithString:IKG_URL]];
                
                downloaderOp.delegate = self;
                
                [testQueue addOperation:downloaderOp];
                downloaderOp.operationType = IKG;

                
                [downloaderOp release];
                
                
                
                //[parser parseDataofIndustry:IKG];
                //[delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IKG_ENTITY_LIST]];
            }
        }
       
       
    }
}

-(void)sendTestError
{
    
    if(delegate && [delegate respondsToSelector:@selector(dataSourceEntityListFetchDidFail:)])
    {
         NSError* error = [[NSError alloc] initWithDomain:@"Data" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Unable to Fetch Data" forKey:NSLocalizedDescriptionKey]];
        [delegate dataSourceEntityListFetchDidFail:error];
        [error release];
    }
   
}




#pragma mark datadownload delegate methods

-(void)dataDownloadDidFinishForType:(NSInteger)industryType
{
    NSLog(@"finished");
    
    if(industryType == IND)
    {
        [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IND_ENTITY_LIST]];
    }
    else if(industryType == AXC)
    {
        [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:AXC_ENTITY_LIST]];
    }
    else if(industryType == PK)
    {
        [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:PK_ENTITY_LIST]];
    }
    else if(industryType == IKG)
    {
        [delegate dataSourceEntityListFetchDidFinish:[dataBase getEntityListFromTable:IKG_ENTITY_LIST]];
    }
}
-(void)dataDownloadDidFail
{
    //propagate error
}

@end
