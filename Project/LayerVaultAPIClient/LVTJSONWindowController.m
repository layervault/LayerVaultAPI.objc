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
    [RACObserve(self, model) subscribeNext:^(MTLModel<MTLJSONSerializing> *model) {
        @strongify(self);
        if (model) {
            NSString *name = @"";
            if ([model respondsToSelector:@selector(name)]) {
                name = [NSString stringWithFormat:@" (%@)", [(id)model name]];
            }
            [self.window setTitle:[NSString stringWithFormat:@"%@%@",
                                   NSStringFromClass(model.class), name]];
            self.json = [MTLJSONAdapter JSONDictionaryFromModel:model];
        }
    }];

    [RACObserve(self, json) subscribeNext:^(NSDictionary *json) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}


#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.json.allKeys.count;
}


#pragma mark - NSTableViewDelegate
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

        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+"
                                                                               options:0
                                                                                 error:nil];
        if (regex) {
            stringValue = [regex stringByReplacingMatchesInString:stringValue
                                                          options:0
                                                            range:NSMakeRange(0, stringValue.length)
                                                     withTemplate:@" "];
        }
        stringValue = [stringValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        stringValue = [stringValue stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [cellView.textField setStringValue:stringValue];
    }
    return cellView;
}


- (NSDictionary *)dictForItem:(id)item;
{
    if ([item isKindOfClass:NSDictionary.class]) {
        return (NSDictionary *)item;
    }
    return nil;
}


#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item) {
        NSDictionary *d = [self dictForItem:item];
        id value = d[d.allKeys[0]];
        return [value isKindOfClass:NSArray.class] ? [value count] : 0;
    }
    return self.json.allKeys.count;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    NSDictionary *d = [self dictForItem:item];
    id value = d[d.allKeys[0]];
    return [value isKindOfClass:NSArray.class];
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item) {
        NSDictionary *d = [self dictForItem:item];
        id value = d[d.allKeys[0]];
        return [value isKindOfClass:NSArray.class] ? [[value objectAtIndex:index] copy] : nil;
    }
    NSString *key = self.json.allKeys[index];
    return @{key: self.json[key]};
}


- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    NSDictionary *d = [self dictForItem:item];
    if ([tableColumn.identifier isEqualToString:@"KeyColumn"]) {
        NSTableCellView *cellView = [outlineView makeViewWithIdentifier:@"KeyCell"
                                                                  owner:self];
        [cellView.textField setStringValue:d.allKeys[0]];
        return cellView;
    }
    else if ([tableColumn.identifier isEqualToString:@"ValueColumn"]) {
        NSTableCellView *cellView = [outlineView makeViewWithIdentifier:@"ValueCell"
                                                                  owner:self];
        id value = d[d.allKeys[0]];
        if (![value isKindOfClass:NSArray.class]) {
            [cellView.textField setStringValue:[value description]];
        }
        else {
            [cellView.textField setStringValue:@"<array>"];
        }
        return cellView;
    }
    return nil;
}

@end
