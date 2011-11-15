//
//  UIAsyncImageView.m
//  AsyncImage
//
//  Created by ntaku on 09/10/31.
//  Copyright 2009 http://d.hatena.ne.jp/ntaku/. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIAsyncImageView.h"
#import "EGOCache.h"

@implementation UIAsyncImageView
@synthesize name = _name;
@synthesize password = _password;
@synthesize url = _url;

-(void)loadImage:(NSString *)url name:(NSString *)name password:(NSString *)password{
    self.url = url;
    NSString *key = [[self.url pathComponents] lastObject];
    UIImage *image = [[EGOCache currentCache] imageForKey:key];
    //NSLog(@"image cache:%@",image);
    if (image != nil){
        self.image = image;
    }
    
	[self abort];
    self.password = password;
    self.name = name;
    
	self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];	
	data = [[NSMutableData alloc] initWithCapacity:0];

	NSURLRequest *req = [NSURLRequest 
						 requestWithURL:[NSURL URLWithString:url] 
						 cachePolicy:NSURLRequestUseProtocolCachePolicy
						 timeoutInterval:30.0];
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//	NSLog(@"connection didRecieveResponse");
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata{
//	NSLog(@"connection didReceiveData len=%d", [nsdata length]);
	[data appendData:nsdata];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//	NSLog(@"connection didFailWithError - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	[self abort];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSLog(@"connection connectionDidFinishLoading %@",connection);	
	//self.contentMode = UIViewContentModeScaleAspectFit;
    //self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;		
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil){
        NSString *key = [[self.url pathComponents] lastObject];
        [[EGOCache currentCache] setImage:image forKey:key withTimeoutInterval:3600*24];

        self.image = image;
    }
	//[self addCorner];
	
	[self abort];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0)
	{
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:_name
                                                 password:_password
                                              persistence:NSURLCredentialPersistencePermanent];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    }
	else
	{
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
    }
}


-(void)abort{
	if(conn != nil){
		[conn cancel];
		conn = nil;
	}
	if(data != nil){
		data = nil;
	}
}

- (void)dealloc {
	[conn cancel];
}

- (void)addCorner{	

	CALayer *layer = self.layer;
	layer.masksToBounds = YES;
	
	CGFloat bg_rgba[] = { 1.0, 0.0, 0.0, 0.7 };
	CGFloat border_rgba[] = { 0.0, 0.0, 0.0, 0.2 };
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef bgColor = CGColorCreate(colorSpace, bg_rgba);
	layer.backgroundColor = bgColor;
	CGColorRelease(bgColor);
	
	CGColorRef borderColor = CGColorCreate(colorSpace, border_rgba);
	layer.borderColor = borderColor;
	layer.borderWidth = 1;
	CGColorRelease(borderColor);
	
	CGColorSpaceRelease(colorSpace);
	
	layer.cornerRadius = 3;	
}

@end
