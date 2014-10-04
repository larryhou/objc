//
//  ViewController.m
//  MemLeak
//
//  Created by doudou on 10/3/14.
//  Copyright (c) 2014 larryhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation Account

@synthesize balance;
@synthesize client;

@end

@implementation Client

@synthesize account;
@synthesize name;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	Client* client = [[Client alloc] init];
	Account* account = [[Account alloc] init];
	account.client = client;
	client.account = account;
	
	client = nil;
	account = nil;
	
	NSLog(@"%@",client.account);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

@end
