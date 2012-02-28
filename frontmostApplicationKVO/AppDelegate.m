#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize textView = _textView;
@synthesize observing = _observing;

#pragma mark -

- (void)dealloc
{
    [self stopObservingIfObserving];
}

#pragma mark -

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.observing = YES;
}

#pragma mark -

- (void)setObserving:(BOOL)observing
{
    if (_observing != observing) {
        [self stopObservingIfObserving];
        _observing = observing;
        [self startObservingIfObserving];
    }
}

- (void)logMessage:(NSString *)message
{
    [self.textView replaceCharactersInRange:NSMakeRange(self.textView.textStorage.length, 0) withString:message];
    [self.textView replaceCharactersInRange:NSMakeRange(self.textView.textStorage.length, 0) withString:@"\n"];
    [self.textView scrollToEndOfDocument:nil];
}

void *kContextFrontmostApp = &kContextFrontmostApp;

- (void)startObservingIfObserving
{
    if (_observing) {
        [self logMessage:@"{"];
        [[NSWorkspace sharedWorkspace] addObserver:self forKeyPath:@"frontmostApplication" options:NSKeyValueObservingOptionInitial context:kContextFrontmostApp];
    }
}

- (void)stopObservingIfObserving
{
    if (_observing) {
        [[NSWorkspace sharedWorkspace] removeObserver:self forKeyPath:@"frontmostApplication" context:kContextFrontmostApp];
        [self logMessage:@"}\n"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextFrontmostApp) {
        NSRunningApplication *frontmostApp = [object valueForKey:keyPath];
        [self logMessage:[NSString stringWithFormat:@"\t%@;", frontmostApp.bundleIdentifier]];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
