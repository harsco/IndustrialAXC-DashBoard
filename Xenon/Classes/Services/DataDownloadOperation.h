//
//  DataDownloadOperation.h
//  Xenon
//
//  Created by SadikAli on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserInterface.h"


@protocol dataDownloadOperationDelegate;

@interface DataDownloadOperation : NSOperation<NSURLConnectionDelegate,parserDelegate>
{
    BOOL executing_;
    BOOL finished_;
    
    // The actual NSURLConnection management
    NSURL*    connectionURL;
    NSURLConnection*  connection;
    NSMutableData*    receivedData;
    NSInteger operationType;
    
    ParserInterface* parser;
    
    id<dataDownloadOperationDelegate> delegate;
}
@property(nonatomic,retain) id<dataDownloadOperationDelegate> delegate;
@property(nonatomic)NSInteger operationType;


- (id)initWithURL:(NSURL*)url;




@end


@protocol dataDownloadOperationDelegate <NSObject>
-(void)dataDownloadDidFinishForType:(NSInteger)industryType;
-(void)dataDownloadDidFail;

@end