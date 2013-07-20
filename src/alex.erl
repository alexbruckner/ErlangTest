-module(alex).
-compile(export_all).
-behavior(gen_server).

start_link(Handler) when is_atom(Handler) -> gen_server:start_link(?MODULE, [Handler], []).
start(Handler) when is_atom(Handler) -> gen_server:start(?MODULE, [Handler], []).

% ie: cast(Pid, test, [{key1, value1}, {key2, value2}])
cast(Pid, Action, KeyValueList) when is_list(KeyValueList) ->
  gen_server:cast(Pid, {Action, KeyValueList}).

call(Pid, Action, KeyValueList) ->
  gen_server:call(Pid, {call, Action, KeyValueList}).

shutdown(Pid) ->
  gen_server:call(Pid, terminate).

init([Handler]) ->
  io:format("Handler: ~p~n", [Handler]),
  {ok, Handler}.

handle_cast({Action, KeyValueList}, Handler) when is_list(KeyValueList) ->
  io:format("Cast: Requested action <~p> with values <~p>~n", [Action, KeyValueList]),
  erlang:apply(Handler, handle_message, [Action, KeyValueList]),
  {noreply, Handler}.

handle_call(terminate, {_From, _Pid}, _Handler) ->
  {stop, normal, ok, []};
handle_call({call, Action, KeyValueList}, {_From, _Pid}, Handler) ->
  io:format("Call: Requested action <~p> with values <~p>~n", [Action, KeyValueList]),
  {reply, erlang:apply(Handler, handle_message, [Action, KeyValueList]), Handler}.

terminate(_Pid, Handler) ->
  io:format("Terminated.~n"),
  {ok, Handler}.

get_value(Key, KeyValueList) ->
  get_value(lists:keyfind(Key, 1, KeyValueList)).

get_value(KeyValue) when is_tuple(KeyValue)->
  element(2, KeyValue);
get_value(_) -> not_found.












