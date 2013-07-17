-module(alex_web_server).
-compile(export_all).

main() ->
  start(8080).

start(Port) ->
  io:format("server started.~n"),
  {ok, ServerSocket} = gen_tcp:listen(Port, [binary, {packet, 0},
    {reuseaddr, true}, {active, true}]),
  server_loop(ServerSocket).

server_loop(ServerSocket) ->
  {ok, Socket} = gen_tcp:accept(ServerSocket),

  Pid = spawn(fun() -> handle_client(Socket) end),
  inet:setopts(Socket, [{packet, 0}, binary,
    {nodelay, true}, {active, true}]),
  gen_tcp:controlling_process(Socket, Pid),

  server_loop(ServerSocket).

handle_client(Socket) ->
  receive
    {tcp, Socket, Request} ->
      io:format("received: ~s~n", [Request]),
      RequestString = binary_to_list(Request),
      Url = string:substr(RequestString, 1, string:str(RequestString, " HTTP")),
      io:format("url: ~s~n", [Url]),
      gen_tcp:send(Socket, header() ++ content(Url)),
      gen_tcp:close(Socket),

      io:format("closed...~n")
  end.

header() ->
  "HTTP/1.0 200 OK\r\n" ++
    "Cache-Control: private\r\n" ++
    "Content-Type: text/html\r\n" ++
    "Connection: Close\r\n\r\n".

content(Request) ->
%%   ie: http://localhost:8080/sync?test=[{key1, value1}, {key2, "value 2"}]
%%   should perform action: test - with keyvalue list: [{key1, value1}, {key2, "value 2"}]
%%   TODO - deal with favicon request
  Type = string:substr(Request, 1, string:str(Request, " ")),
  Url = http_uri:decode(string:substr(Request, string:str(Request, " "))),
  CastOrCall = string:substr(Url, 3, 4),
  ActionString = string:substr(Url, string:str(Url, "?") + 1),
  Action = string:substr(ActionString, 1, string:str(ActionString, "=") - 1),
  ["Request Type: ", Type, ", Url: ", Url, ", CastOrCall: ", CastOrCall, ", Action: ", Action].

trim_whitespace(Input) -> re:replace(Input, "\\s+", "", [global]).

