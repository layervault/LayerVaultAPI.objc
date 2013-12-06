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
@end

@implementation LVTProjectWindowController

- (instancetype)init
{
    return [self initWithWindowNibName:@"LVTProjectWindowController"];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
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


- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:@"NodeIdentifier"
                                                                   owner:self];
    if (item) {
        NSString *name = @"";
        if ([item isKindOfClass:LVTFolder.class]) {
            tableCellView.imageView.image = [NSImage imageNamed:NSImageNamePathTemplate];;
            LVTFolder *folder = (LVTFolder *)item;
            if (folder.name) {
                name = folder.name;
            }
            else if (folder.path) {
                name = folder.path.lastPathComponent;
            }
        }
        else if ([item isKindOfClass:LVTFile.class]) {
            tableCellView.imageView.image = [NSImage imageNamed:NSImageNameIChatTheaterTemplate];
            LVTFile *file = (LVTFile *)item;
            if (file.localPath) {
                name = file.localPath.lastPathComponent;
            }
        }
        [tableCellView.textField setStringValue:name];
    }
    return tableCellView;
}


- (NSArray *)subFolderAndFilesForFolder:(LVTFolder *)folder
{
    NSSortDescriptor *dateUpdatedSort = [NSSortDescriptor sortDescriptorWithKey:@"dateUpdated"
                                                                      ascending:NO];
    return [[folder.files arrayByAddingObjectsFromArray:folder.folders] sortedArrayUsingDescriptors:@[dateUpdatedSort]];
}

@end
