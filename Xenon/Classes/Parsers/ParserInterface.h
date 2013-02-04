//
//  ParserInterface.h
//  Xenon
//
//  Created by SadikAli on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "App_Storage.h"

@protocol parserDelegate; 


@interface ParserInterface : NSObject
{
    id <parserDelegate> delegate;
}

@property(nonatomic,retain)id<parserDelegate> delegate;

-(id)init;
-(void)parseDataofIndustry:(Industry)industry;
-(void)parseDataofIndustry:(Industry)industry withData:(NSData*)receivedData;



@end


@protocol parserDelegate <NSObject>

-(void)parsingDidFinish:(NSInteger)industryType;
-(void)parsingDidFail:(NSError*)error;

@end
