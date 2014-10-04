//
//  ViewController.h
//  MemLeak
//
//  Created by doudou on 10/3/14.
//  Copyright (c) 2014 larryhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@class Client;

@interface ViewController : UIViewController


@end

@interface Account : NSObject
@property (nonatomic) int balance;
@property (strong, nonatomic) Client* client;
@end

@interface Client : NSObject
@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) Account* account;
@end