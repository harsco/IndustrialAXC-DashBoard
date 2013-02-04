//
//  DataSource.h
//  Xenon
//
//  Created by Mahendra on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App_Storage.h"
#import "SBJson.h"
#import "ParserInterface.h"
#import "DataDownloadOperation.h"


//Network URLs

#define IND_URL @"http://bradmcalister.com/inddash/json/IndustrialsDashboardTotals.txt"
#define AXC_URL @"http://bradmcalister.com/inddash/json/IndustrialsDashboardAXC.txt"
#define PK_URL  @"http://bradmcalister.com/inddash/json/IndustrialsDashboardPK.txt"
#define IKG_URL @"http://bradmcalister.com/inddash/json/IndustrialsDashboardIKG.txt"

@protocol dataSourceDelegate;


@interface DataSource : NSObject<parserDelegate,dataDownloadOperationDelegate>
{
    App_Storage* dataBase;
    ParserInterface* parser;
    
    id <dataSourceDelegate> delegate;
}

@property(nonatomic,retain)id<dataSourceDelegate>delegate;

-(void)getEntityListOfIndustry:(Industry)industry;
-(NSMutableArray*)getEntityListItemsWithEntity:(NSString*)entity Type:(Industry)Industry;
-(NSMutableArray*)getEntityListSubItemsForItem:(NSString*)entityItem;
-(void)refreshDataOfIndustry:(Industry)industry;


@end


@protocol dataSourceDelegate <NSObject>

-(void)dataSourceEntityListFetchDidFinish:(NSMutableArray*)entityArray;
-(void)dataSourceEntityListFetchDidFail:(NSError*)error;

@end
