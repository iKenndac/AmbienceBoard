#import "EnviroServer.h"

@implementation EnviroServer {
	AsyncSocket *_listen;
	NSMutableArray *_clients;
	NSMutableDictionary *_boards;
}
-init;
{
	if(!(self = [super init])) return nil;
	_listen = [[AsyncSocket alloc] initWithDelegate:self];
	_clients = [NSMutableArray new];
	_boards = [NSMutableDictionary new];
	
	
	return self;
}
-(void)run;
{
	NSError *err = nil;
	NSAssert(
		[_listen acceptOnPort:kPort error:&err] == YES,
		@"Failed to listen on port %d: %@", kPort, err
	);
}
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket;
{
	// The TCAHP takes ownership of the socket and becomes its delegate. We only need to implement
	// TCAHP's delegate now.
	TCAsyncHashProtocol *proto = [[TCAsyncHashProtocol alloc] initWithSocket:newSocket delegate:self];
	
	// Dispatch on selector of the incoming command instead of using delegate methods.
	proto.autoDispatchCommands = YES;
	
	// Hang on to it, or else it has no owner and will disconnect.
	[_clients addObject:proto];
	
	[proto sendHash:[NSDictionary dictionaryWithObjectsAndKeys:
		@"boardList", @"command",
		_boards, @"boards",
	nil]];

}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock;
{
	TCAsyncHashProtocol *proto = nil;
	for(TCAsyncHashProtocol *potential in _clients)
		if(potential.socket == sock) proto = potential;

	[_clients removeObject:proto];
}

-(void)broadcast:(NSDictionary*)hash;
{
	for(TCAsyncHashProtocol *proto in _clients)
		[proto sendHash:hash];
}

-(void)command:(TCAsyncHashProtocol*)proto addOrUpdateBoard:(NSDictionary*)hash;
{
	[_boards setObject:[hash objectForKey:@"rep"] forKey:[hash objectForKey:@"name"]];
	[self broadcast:[NSDictionary dictionaryWithObjectsAndKeys:
		@"boardList", @"command",
		_boards, @"boards",
	nil]];
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