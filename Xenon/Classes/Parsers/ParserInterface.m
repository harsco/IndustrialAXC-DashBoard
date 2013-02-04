//
//  ParserInterface.m
//  Xenon
//
//  Created by SadikAli on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParserInterface.h"

@implementation ParserInterface

@synthesize delegate;

-(id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}


-(void)dealloc
{
    [super dealloc];
    
    RELEASE_TO_NIL(delegate);
}

-(void)parseDataofIndustry:(Industry)industry withData:(NSData*)receivedData
{
    
    //NSError* error;
    NSString *jsonString;
    if(industry == IND)
    {
        //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"INDMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        jsonString = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
        
        NSLog(@"jsonstring is %@",jsonString);
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
            // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
            
            NSArray *array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
            NSEnumerator *enumerator = [array1 objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) 
            {
                NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                
                entityItem* temporaryItem = [[entityItem alloc] init];
                temporaryItem.name = [item objectForKey:@"Title"];
                temporaryItem.value = [item objectForKey:@"Value"];
                [arrayToHoldItems addObject:temporaryItem];
                RELEASE_TO_NIL(temporaryItem);
                
            }
            
            [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
            NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
            RELEASE_TO_NIL(arrayToHoldItems);
            
            
        }
        
        [[App_Storage getInstance] storeEntityListIntoTable:IND_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:IND_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"dataUpdateFinished" object:self];
       
        [delegate parsingDidFinish:industry];

    }
    
    else if(industry == AXC)
    {
        //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"INDMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        jsonString = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
        
        NSLog(@"jsonstring is %@",jsonString);
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* entityListSubItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
            // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
           
            NSArray *array1;
            
            if([[[items objectAtIndex:i] objectForKey:@"Items"] isKindOfClass:[NSArray class]])
            {
               
                NSLog(@"Iffff");
                array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
                
                NSEnumerator *enumerator = [array1 objectEnumerator];
                NSDictionary* item;
                while (item = (NSDictionary*)[enumerator nextObject]) 
                {
                    NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                    NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                    
                    entityItem* temporaryItem = [[entityItem alloc] init];
                    temporaryItem.name = [item objectForKey:@"Title"];
                    temporaryItem.value = [item objectForKey:@"Value"];
                    [arrayToHoldItems addObject:temporaryItem];
                    RELEASE_TO_NIL(temporaryItem);
                    
                }
                
               
                [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
                NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
                RELEASE_TO_NIL(arrayToHoldItems);

            }
            else 
            {
                
                NSLog(@"elseeeeee");
                
                
                array1 = [[items objectAtIndex:i] objectForKey:@"SubCategories"];
                NSLog(@"count of subcategories is %d",[array1 count]);
                
                
                //[App_GeneralUtilities showAlertOKWithTitle:@"Error!!" withMessage:@"Data Structure invalid format"];
                
                NSLog(@"count is %d",[array1 count]);
                NSEnumerator *enumerator = [array1 objectEnumerator];
                
                
                NSDictionary* item;
                while (item = (NSDictionary*)[enumerator nextObject]) 
                {
                    NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                    NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                    
                    NSMutableArray* temp = [[NSMutableArray alloc] init];
                    temp = [item objectForKey:@"Items"];
        
                    NSMutableArray* arrayToHoldSubItems = [[NSMutableArray alloc] init];
                    NSEnumerator* subenumerator = [temp objectEnumerator];
                    NSDictionary* subItem;
                    while(subItem = (NSDictionary*)[subenumerator nextObject])
                    {
                        NSLog(@"title is %@",[subItem objectForKey:@"Title"]);
                        NSLog(@"Value is %@",[subItem objectForKey:@"Value"]);
                        
                        entityItem* temporarySubItem = [[entityItem alloc] init];
                        temporarySubItem.name = [subItem objectForKey:@"Title"];
                        temporarySubItem.value = [subItem objectForKey:@"Value"];
                        NSLog(@"temporarySubItem.name is %@",temporarySubItem.name);
                        NSLog(@"temporarySubItem.value is %@",temporarySubItem.value);
                        [arrayToHoldSubItems addObject:temporarySubItem];
                        RELEASE_TO_NIL(temporarySubItem);
                        
                        //NSLog(@"count of arrayToHoldSubItems is %d",[arrayToHoldSubItems count]);
                        
                    }
                    
                    
                    entityItem* temporaryItem = [[entityItem alloc] init];
                    temporaryItem.name = [item objectForKey:@"Title"];
                    temporaryItem.value = [item objectForKey:@"Value"];
                    
                    NSLog(@"temporaryItem.name is %@",temporaryItem.name);
                    NSLog(@"temporaryItem.value is %@",temporaryItem.value);
                    
                    [arrayToHoldItems addObject:temporaryItem];
                    RELEASE_TO_NIL(temporaryItem);
                    
                    [entityListSubItemsDictionary setObject:arrayToHoldSubItems forKey:[item objectForKey:@"Value"]];
                    
                    RELEASE_TO_NIL(arrayToHoldSubItems);
                    
                }
                    
                
                    [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
                    NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
                    RELEASE_TO_NIL(arrayToHoldItems);
            
                            
            }
            
                        
            
        }
        
        [[App_Storage getInstance] storeEntitySubItemsIntoTable:AXC_ENTITY_SUBITEMS ContentValues:entityListSubItemsDictionary];
        
        [[App_Storage getInstance] storeEntityListIntoTable:AXC_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:AXC_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListSubItemsDictionary);
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
        
        
        [delegate parsingDidFinish:industry];
        
    }
    
    else if(industry == PK)
    {
        //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"INDMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        jsonString = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
        
        NSLog(@"jsonstring is %@",jsonString);
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
            // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
            
            NSArray *array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
            NSEnumerator *enumerator = [array1 objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) 
            {
                NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                
                entityItem* temporaryItem = [[entityItem alloc] init];
                temporaryItem.name = [item objectForKey:@"Title"];
                temporaryItem.value = [item objectForKey:@"Value"];
                [arrayToHoldItems addObject:temporaryItem];
                RELEASE_TO_NIL(temporaryItem);
                
            }
            
            [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
            NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
            RELEASE_TO_NIL(arrayToHoldItems);
            
            
        }
        
        [[App_Storage getInstance] storeEntityListIntoTable:PK_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:PK_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
        
        
        [delegate parsingDidFinish:industry];
        
    }
    else if(industry == IKG)
    {
        //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"INDMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        jsonString = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
        
        NSLog(@"jsonstring is %@",jsonString);
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
            // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
            
            NSArray *array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
            NSEnumerator *enumerator = [array1 objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) 
            {
                NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                
                entityItem* temporaryItem = [[entityItem alloc] init];
                temporaryItem.name = [item objectForKey:@"Title"];
                temporaryItem.value = [item objectForKey:@"Value"];
                [arrayToHoldItems addObject:temporaryItem];
                RELEASE_TO_NIL(temporaryItem);
                
            }
            
            [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
            NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
            RELEASE_TO_NIL(arrayToHoldItems);
            
            
        }
        
        [[App_Storage getInstance] storeEntityListIntoTable:IKG_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:IKG_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
        
        
        [delegate parsingDidFinish:industry];
        
    }



}

-(void)parseDataofIndustry:(Industry)industry
{
    //NSError* error;
    NSString *jsonString;
    if(industry == IND)
    {
         //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"INDMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        jsonString = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://bradmcalister.com/inddash/json/IndustrialsDashboardTotals.txt"]] encoding:NSASCIIStringEncoding];
        
//    NSLog(@"data is %s",[[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://bradmcalister.com/inddash/json/IndustrialsDashboardIKG.txt"]] bytes]);
        
        NSLog(@"string is %@",jsonString);
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
           // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
            
            NSArray *array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
            NSEnumerator *enumerator = [array1 objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) 
            {
                NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                
                entityItem* temporaryItem = [[entityItem alloc] init];
                temporaryItem.name = [item objectForKey:@"Title"];
                temporaryItem.value = [item objectForKey:@"Value"];
                [arrayToHoldItems addObject:temporaryItem];
                RELEASE_TO_NIL(temporaryItem);
                
            }
            
            [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
            NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
            RELEASE_TO_NIL(arrayToHoldItems);
            
            
        }
        
        [[App_Storage getInstance] storeEntityListIntoTable:IND_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:IND_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
      
    }
    else if(industry == AXC)
    {
        //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AXCMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
         jsonString = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://bradmcalister.com/inddash/json/IndustrialsDashboardAXC.txt"]] encoding:NSASCIIStringEncoding];
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
            // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
            
            NSArray *array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
            NSEnumerator *enumerator = [array1 objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) 
            {
                NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                
                entityItem* temporaryItem = [[entityItem alloc] init];
                temporaryItem.name = [item objectForKey:@"Title"];
                temporaryItem.value = [item objectForKey:@"Value"];
                [arrayToHoldItems addObject:temporaryItem];
                RELEASE_TO_NIL(temporaryItem);
                
            }
            
            [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
            NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
            RELEASE_TO_NIL(arrayToHoldItems);
            
            
        }
        
        [[App_Storage getInstance] storeEntityListIntoTable:AXC_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:AXC_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
    }
    else if(industry == PK)
    {
        //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IKGMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        jsonString = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://bradmcalister.com/inddash/json/IndustrialsDashboardPK.txt"]] encoding:NSASCIIStringEncoding];
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
            // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
            
            NSArray *array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
            NSEnumerator *enumerator = [array1 objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) 
            {
                NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                
                entityItem* temporaryItem = [[entityItem alloc] init];
                temporaryItem.name = [item objectForKey:@"Title"];
                temporaryItem.value = [item objectForKey:@"Value"];
                [arrayToHoldItems addObject:temporaryItem];
                RELEASE_TO_NIL(temporaryItem);
                
            }
            
            [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
            NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
            RELEASE_TO_NIL(arrayToHoldItems);
            
            
        }
        
        [[App_Storage getInstance] storeEntityListIntoTable:PK_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:PK_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
    }
    else if(industry == IKG)
    {
        //jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PKMatrix" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        jsonString = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://bradmcalister.com/inddash/json/IndustrialsDashboardIKG.txt"]] encoding:NSASCIIStringEncoding];
        
        NSDictionary *json = [jsonString JSONValue];
        
        RELEASE_TO_NIL(jsonString);
        
        // Get all object
        NSArray *items = [json valueForKeyPath:@"d.Items"];
        
        NSLog(@"count of items is %d",[items count]);
        
        NSMutableArray* entityListArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* entityListItemsDictionary = [[NSMutableDictionary alloc] init];
        
        for(int i=0;i<[items count];i++)
        {
            //NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Title"]);
            // NSLog(@"title is  %@",[[items objectAtIndex:i] objectForKey:@"Items"]);
            [entityListArray addObject:[[items objectAtIndex:i] objectForKey:@"Title"]];
            
            
            NSMutableArray* arrayToHoldItems = [[NSMutableArray alloc] init];
            
            NSArray *array1 = [[items objectAtIndex:i] objectForKey:@"Items"];
            NSEnumerator *enumerator = [array1 objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) 
            {
                NSLog(@"clientId = %@",  [item objectForKey:@"Title"]);
                NSLog(@"clientName = %@",[item objectForKey:@"Value"]);
                
                entityItem* temporaryItem = [[entityItem alloc] init];
                temporaryItem.name = [item objectForKey:@"Title"];
                temporaryItem.value = [item objectForKey:@"Value"];
                [arrayToHoldItems addObject:temporaryItem];
                RELEASE_TO_NIL(temporaryItem);
                
            }
            
            [entityListItemsDictionary setObject:arrayToHoldItems forKey:[[items objectAtIndex:i] objectForKey:@"Title"]];
            NSLog(@"arrayToHoldItems count is %d",[arrayToHoldItems count]);
            RELEASE_TO_NIL(arrayToHoldItems);
            
            
        }
        
        [[App_Storage getInstance] storeEntityListIntoTable:IKG_ENTITY_LIST ContentValues:entityListArray];
        [[App_Storage getInstance] storeEntityItemsIntoTable:IKG_ENTITY_ITEMS ContentValues:entityListItemsDictionary];
        
        RELEASE_TO_NIL(entityListArray);
        RELEASE_TO_NIL(entityListItemsDictionary);
    }
    
    
    

}

@end
