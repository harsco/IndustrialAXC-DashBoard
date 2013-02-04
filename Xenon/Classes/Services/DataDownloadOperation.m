//
//  DataDownloadOperation.m
//  Xenon
//
//  Created by SadikAli on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataDownloadOperation.h"

@implementation DataDownloadOperation
@synthesize delegate;
@synthesize operationType;

- (id)initWithURL:(NSURL *)url
{
    if( (self = [super init]) ) {
        connectionURL = [url copy];
        receivedData = [[NSMutableData alloc] init];
        
        parser = [[ParserInterface alloc] init];
        parser.delegate = self;
        //NSLog(@"URL is %@",connectionURL);
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    
    [receivedData release];
}

-(void)start
{
   if( finished_ || [self isCancelled] ) { //[self done]; 
       return; }
    
    [self performSelectorOnMainThread:@selector(initiateNetworkConnection) withObject:nil waitUntilDone:NO];
    
   
}


-(void)initiateNetworkConnection
{
     connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:connectionURL] delegate:self startImmediately:YES];
}


-(void)finish
{
    [parser parseDataofIndustry:self.operationType withData:receivedData];
}



#pragma mark Parser Callback
-(void)parsingDidFinish:(NSInteger)industryType
{
    
//    NSNotification* note = [NSNotification notificationWithName:@"dataUpdateFinished" object:self];
//    [[NSNotificationCenter defaultCenter] postNotification:note];
    
    NSLog(@"parsing did finish");
    
    [delegate dataDownloadDidFinishForType:industryType];
}


-(void)parsingDidFail:(NSError*)error
{
    
}


#pragma mark network Call backs

#pragma mark NSURL
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"data bytes is %s",[data bytes]);
    [receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[connection release];
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[connection release];
    //[self movieReceived];
   // NSLog(@"data is %s",[receivedData bytes]);
  
    [self finish];
    
}


@end
