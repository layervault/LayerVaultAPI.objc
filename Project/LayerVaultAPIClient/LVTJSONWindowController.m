//
//  LVTJSONWindowController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/1/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTJSONWindowController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>

@interface LVTJSONWindowController ()
@property (weak) IBOutlet NSTableView *tableView;
@end

@implementation LVTJSONWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowWillLoad
{
    [super windowWillLoad];
    
    @weakify(self);
    [RACObserve(self, json) subscribeNext:^(NSDictionary *json) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.json.allKeys.count;
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    NSTableCellView *cellView = nil;
    NSString *currentKey = self.json.allKeys[row];
    if ([tableColumn.identifier isEqualToString:@"KeyColumn"]) {
        cellView = [tableView makeViewWithIdentifier:@"KeyCell"
                                               owner:self];
        [cellView.textField setStringValue:currentKey];
    }
    else if ([tableColumn.identifier isEqualToString:@"ValueColumn"]) {
        cellView = [tableView makeViewWithIdentifier:@"ValueCell"
                                               owner:self];
        NSString *stringValue = nil;
        id object = [self.json objectForKey:currentKey];
        if ([object isKindOfClass:[NSString class]]) {
            stringValue = (NSString *)object;
        }
        else {
            stringValue = [object description];
        }
        [cellView.textField setStringValue:stringValue];
    }
    return cellView;
}

@end
