//
//  ViewController.m
//  test.Bonjour
//
//  Created by Florian Günther on 13.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
@property (strong, nonatomic) NSMutableArray *list;
@end

@implementation ViewController


@synthesize serviceBrowser = _serviceBrowser;
@synthesize list = _list;

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.list = [[NSMutableArray alloc] init];
    NSLog(@"Searching for services");
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    self.serviceBrowser.delegate = self;
    //    [self.serviceBrowser searchForServicesOfType:@"_airplay._tcp" inDomain:@"local."];
    [self.serviceBrowser searchForServicesOfType:@"_stage_com._tcp" inDomain:@"local."];

}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data
{
    NSLog(@"Did Update: %@", data);
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%i", sender.hostName, sender.port];
    NSLog(@"Resolved Address: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)netServiceDidStop:(NSNetService *)sender
{
    NSLog(@"Service STOPPED");
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"Serivce PUBLISHED");
}


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"NOT Resolved: ");
}


- (void)netServiceWillPublish:(NSNetService *)sender
{
    NSLog(@"Service WILL PUBLISH");
}

- (void)netServiceWillResolve:(NSNetService *)sender
{
    NSLog(@"Will resolve");
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    NSLog(@"Found Service: %@", aNetService);
    
    [self.list addObject:aNetService];
    
    aNetService.delegate = self;
    //    [aNetService startMonitoring];
    [aNetService resolveWithTimeout:5.0];
    //    NSLog(@"Service: %@:%i", aNetService.hostName, aNetService.port);
    
    [aNetService startMonitoring];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    NSLog(@"Removed Service: %@", aNetService);
    
}

@end
