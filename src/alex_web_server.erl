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
      gen_tcp:send(Socket,  content(Url)),
      gen_tcp:close(Socket),

      io:format("closed...~n")
  end.

content(Request) ->
%%   http://localhost:8080/cast?test=muh:value1,%20key2%20:%20%22value%202%22
%%   ie: Request Type: GET, CastOrCall: cast, Action: test, Params: key1:value1, key2 : \"value 2\"
%%   should perform sync action: test - with keyvalue list: [{key1, value1}, {key2, "value 2"}]
%%   TODO - deal with favicon request + deal with missing stuff in general
  Url = http_uri:decode(string:substr(Request, string:str(Request, " "))),
  CastOrCall = string:substr(Url, 3, 4),
  ActionString = string:substr(Url, string:str(Url, "?") + 1),
  Action = string:substr(ActionString, 1, string:str(ActionString, "=") - 1),
  KeyValuePairs = string:substr(ActionString, string:str(ActionString, "=") + 1),
  return(list_to_atom(CastOrCall), list_to_atom(Action), string:strip(KeyValuePairs)).


%% example: http://localhost:8080/cast?test=muh:value1,%20key2%20:%20%22value%202%22
return(cast, Action, KeyValuePairs) ->
  KeyValueList = tokenize(KeyValuePairs),
  io:format("Cast: Action=~p, KeyValuePairs=~p~n", [Action, KeyValueList]),
  {ok, Pid} = alex:start(),
  alex:cast(Pid, Action, KeyValueList),
  "ok";
%% example: http://localhost:8080/call?sync=muh:value1,%20key2%20:%20%22value%202%22
return(call, Action, KeyValuePairs) ->
  KeyValueList = tokenize(KeyValuePairs),
  io:format("Call: Action=~p, KeyValuePairs=~p~n", [Action, KeyValueList]),
  {ok, Pid} = alex:start(),
  alex:call(Pid, Action, KeyValueList);
return(_, _Action, _KeyValuePairs) ->
  "context must be <cast> or <call>".

tokenize(String) ->
  Tokens = string:tokens(String, ","),
  [ to_tuple(X) || X <- Tokens].

to_tuple(X) ->
  K = list_to_atom(string:strip(string:substr(X, 1, string:str(X, ":") - 1))),
  V = string:strip(string:substr(X, string:str(X, ":") + 1)),
  {K,V}.






