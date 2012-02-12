#import "EnviroClient.h"

@implementation EnviroClient {
	AsyncSocket *_socket;
	TCAsyncHashProtocol *_proto;
	NSDictionary *_boards;
}
@synthesize host=_host;
+(EnviroClient*)client;
{
	static EnviroClient *g = nil;
	if(!g)
		g = [self new];
	return g;
}
-init;
{
	if(!(self = [super init])) return nil;
	
	_socket = [[AsyncSocket alloc] initWithDelegate:self];
	
	_boards = [NSDictionary new];
	
	return self;
}
-(void)run;
{
	[_socket connectToHost:_host onPort:kPort error:nil];
}
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
{
	_proto = [[TCAsyncHashProtocol alloc] initWithSocket:sock delegate:self];
	
	// Dispatch on selector of the incoming command instead of using delegate methods.
	_proto.autoDispatchCommands = YES;
	
	// Start reading from the socket.
	[_proto readHash];
}

-(NSDictionary*)boards;
{
	return _boards;
}

-(void)setBoard:(NSData*)data forName:(NSString*)name;
{
	[_proto sendHash:[NSDictionary dictionaryWithObjectsAndKeys:
		@"addOrUpdateBoard", @"command",
		data, @"rep",
		name, @"name",
	nil]];
}
-(void)command:(TCAsyncHashProtocol*)proto boardList:(NSDictionary*)hash;
{
	[self willChangeValueForKey:@"boards"];
	_boards = [hash objectForKey:@"boards"];
	[self didChangeValueForKey:@"boards"];
}

-(void)protocol:(TCAsyncHashProtocol*)proto receivedHash:(NSDictionary*)hash payload:(NSData*)payload;
{
	// If we reach this delegate, command delegation failed and we don't understand
	// the command
	NSLog(@"Invalid command: %@", hash);
	[proto.socket disconnect];
}
-(void)protocol:(TCAsyncHashProtocol*)proto receivedRequest:(NSDictionary*)hash payload:(NSData*)payload responder:(TCAsyncHashProtocolResponseCallback)responder;
{
	NSLog(@"Invalid request: %@", hash);
	[proto.socket disconnect];
}
@end