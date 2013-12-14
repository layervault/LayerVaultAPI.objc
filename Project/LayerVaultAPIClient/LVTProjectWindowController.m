//
//  LVTProjectWindowController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/5/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTProjectWindowController.h"
#import <layervault_objc_client/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>

@interface LVTProjectWindowController () <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (nonatomic, copy) NSArray *sortedFilesAndFolders;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (readonly) LVTHTTPClient *client;
@end

@implementation LVTProjectWindowController


- (instancetype)initWithClient:(LVTHTTPClient *)client
{
    self = [super initWithWindowNibName:@"LVTProjectWindowController"];
    if (self) {
        _client = client;
        @weakify(self);
        [RACObserve(self, project) subscribeNext:^(LVTProject *project) {
            @strongify(self);
            if (project) {
                [self.window setTitle:project.name];
                self.sortedFilesAndFolders = [self subFolderAndFilesForFolder:self.project];
                [self.outlineView reloadData];
            }
        }];
    }
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.outlineView setTarget:self];
    [self.outlineView setDoubleAction:@selector(doubleClickedTable:)];
}


#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item) {
        if ([item isKindOfClass:LVTFolder.class]) {
            LVTFolder *folder = (LVTFolder *)item;
            return (folder.files.count + folder.folders.count);
        }
        return 0;
    }
    return self.sortedFilesAndFolders.count;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item isKindOfClass:LVTFolder.class];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item) {
        if ([item isKindOfClass:LVTFolder.class]) {
            LVTFolder *folder = (LVTFolder *)item;
            return [self subFolderAndFilesForFolder:folder][index];
        }
        return nil;
    }
    return self.sortedFilesAndFolders[index];
}


#pragma mark - NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:tableColumn.identifier
                                                                   owner:self];
    if (item) {
        LVTNode *node = nil;
        if ([item isKindOfClass:LVTNode.class]) {
            node = (LVTNode *)item;
        }

        if ([tableColumn.identifier isEqualToString:@"NameColumn"]) {
            if (node.name.length > 0) {
                [tableCellView.textField setStringValue:node.name];
            }

            if ([item isKindOfClass:LVTFolder.class]) {
                tableCellView.imageView.image = [NSImage imageNamed:NSImageNamePathTemplate];
            }
            else if ([item isKindOfClass:LVTFile.class]) {
                tableCellView.imageView.image = [NSImage imageNamed:NSImageNameIChatTheaterTemplate];
            }

        }
        else if ([tableColumn.identifier isEqualToString:@"DateUpdatedColumn"]) {
            if (node.dateUpdated) {
                [tableCellView.textField.cell setObjectValue:node.dateUpdated];
            }
        }
    }
    return tableCellView;
}


#pragma mark - NSTableViewDelegate
- (void)doubleClickedTable:(NSTableView *)tableView
{
    NSUInteger row = tableView.selectedRow;
    id selectedItem = [self.outlineView itemAtRow:row];
    if ([selectedItem isKindOfClass:LVTFolder.class]) {
        LVTFolder *selectedFolder = (LVTFolder *)selectedItem;
        [self.client getFolderAtPath:[selectedFolder.path lastPathComponent]
                           inProject:self.project
                          completion:^(LVTFolder *folder,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation) {
                              NSLog(@"folder: %@", folder);
                              NSLog(@"error: %@", error);
                              NSLog(@"operation: %@", operation);
                              NSLog(@"equalFolders: %@", [folder isEqual:selectedFolder] ? @"YES" : @"NO");
                          }];
    }
    else if ([selectedItem isKindOfClass:LVTFile.class]) {
        LVTFile *selectedFile = (LVTFile *)selectedItem;
        NSLog(@"file: %@", selectedFile);
    }
}


- (IBAction)newFolderPressed:(NSButton *)sender
{
    NSInteger row = [self.outlineView rowForView:sender];
    id selectedItem = [self.outlineView itemAtRow:row];
    if ([selectedItem isKindOfClass:LVTFolder.class]) {
        LVTFolder *folder = (LVTFolder *)selectedItem;
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        panel.canChooseFiles = YES;
        [panel beginSheetModalForWindow:self.window
                      completionHandler:^(NSInteger result) {
                          if (result == NSOKButton) {
                              NSURL *url = panel.URLs[0];
                              [self.client uploadLocalFile:url
                                                    toPath:folder.path
                                                completion:^(LVTFile *file,
                                                             NSError *error,
                                                             AFHTTPRequestOperation *operation) {
                                                    NSLog(@"file: %@", file);
                                                    NSLog(@"error: %@", error);
                                                    NSLog(@"operation: %@", file);
                                                }];
                          }
                      }];
    }
    else if ([selectedItem isKindOfClass:LVTFile.class]) {
        LVTFile *file = (LVTFile *)selectedItem;
        NSString *path = @"Matt\u2019s Cool Sandb\u00F8x";
        [self.client moveFile:file
                       toPath:path
                  newFileName:@"baz.jpg"
                   completion:^(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation) {
                       NSLog(@"success: %@", success? @"YES" : @"NO");
                       NSLog(@"error: %@", error);
                       NSLog(@"operation: %@", file);
                   }];
    }
}

#pragma mark - PrivateMethods
- (NSArray *)subFolderAndFilesForFolder:(LVTFolder *)folder
{
    NSSortDescriptor *dateUpdatedSort = [NSSortDescriptor sortDescriptorWithKey:@"dateUpdated"
                                                                      ascending:NO];
    return [[folder.files arrayByAddingObjectsFromArray:folder.folders] sortedArrayUsingDescriptors:@[dateUpdatedSort]];
}

@end
