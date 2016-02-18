//
//  ViewController.m
//  Acronyms
//
//  Created by vamsi vayalpati on 2/17/16.
//  Copyright © 2016 vamsi vayalpati. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "ListTableViewController.h"
#import "Acronyms.h"

@interface ViewController ()
{
    Acronyms *acronyms;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Acronyms";
}

-(void)viewWillAppear:(BOOL)animated {
    self->acronyms = nil;
}

- (IBAction)acronymsClicked:(id)sender {
    if(self.textField.text.length > 0) {
        [self getDataFromServerForAcronyms:YES searchText:self.textField.text];
    }
}

- (IBAction)initialismsClicked:(id)sender {
    if(self.textField.text.length > 0) {
        [self getDataFromServerForAcronyms:FALSE searchText:self.textField.text];
    }
}

-(void)getDataFromServerForAcronyms:(BOOL)forAcronyms searchText:(NSString *)text {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (forAcronyms) {
        [parameters setValue:text forKey:@"sf"];
    } else {
        [parameters setValue:text forKey:@"lf"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:@"http://www.nactem.ac.uk/software/acromine/dictionary.py" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",task.response);
        NSArray *serializedData = [NSJSONSerialization JSONObjectWithData: responseObject options:kNilOptions error:nil];
        NSLog(@"%@",serializedData);
        if(serializedData.count > 0) {
            self->acronyms = [[Acronyms alloc]initWith:serializedData[0]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self->acronyms.textArray.count > 0) {
            [self performSegueWithIdentifier:@"listViewSegue" sender:self];
        } else {
            [self showAlertWithMessage:@"No data available."];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlertWithMessage:[error localizedDescription]];

    }];
}

-(void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Acronyms" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]  isEqual: @"listViewSegue"]) {
        ListTableViewController *vC = segue.destinationViewController;
        vC.acronyms = self->acronyms;
    }
}

@end
