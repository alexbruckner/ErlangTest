%% Copyright
-module(test_alex).
-author("alexbruckner").

%% API
-compile(export_all).

main() ->
  {ok, Pid} = alex:start(),
  alex:cast(Pid, test, [{key1, "value1"}, {key2, "value2"}]),
  io:format("return: ~p~n", [alex:cast(Pid, test, [{muh, "caaaaassssssstt!!!"}])]),
  io:format("return: ~p~n", [alex:call(Pid, sync, [{muh, "caaaaaallllllll!!!"}])]).
