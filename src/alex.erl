-module(alex).
-compile(export_all).
-behavior(gen_server).

start_link() -> gen_server:start_link(?MODULE, [], []).
start() -> gen_server:start(?MODULE, [], []).

% ie: cast(Pid, test, [{key1, value1}, {key2, value2}])
cast(Pid, Action, KeyValueList) when is_list(KeyValueList) ->
  gen_server:cast(Pid, {Action, KeyValueList}).

call(Pid, Action, KeyValueList) ->
  gen_server:call(Pid, {call, Action, KeyValueList}).

shutdown(Pid) ->
  gen_server:call(Pid, terminate).

init([]) -> {ok, []}.

handle_cast({Action, KeyValueList}, _State) when is_list(KeyValueList) ->
  io:format("Cast: Requested action <~p> with values <~p>~n", [Action, KeyValueList]),
  handle_message(Action, KeyValueList),
  {noreply, []}.

handle_call(terminate, {_From, _Pid}, _State) ->
  {stop, normal, ok, []};
handle_call({call, Action, KeyValueList}, {_From, _Pid}, _State) ->
  io:format("Call: Requested action <~p> with values <~p>~n", [Action, KeyValueList]),
  {reply, handle_message(Action, KeyValueList), []}.

terminate(_Pid, _State) ->
  io:format("Terminated.~n"),
  {ok, []}.

handle_message(test, KeyValueList) ->
  io:format("Handling action <test> with values <~p>~n", [KeyValueList]),
  io:format("found value: <~p> for key <muh>~n", [get_value(muh, KeyValueList)]);
handle_message(sync, KeyValueList) ->
  get_value(muh, KeyValueList);
handle_message(RequestType, KeyValueList) ->
  io:format("Undefined action <~p> with values <~p>~n", [RequestType, KeyValueList]).

get_value(Key, KeyValueList) ->
  get_value(lists:keyfind(Key, 1, KeyValueList)).

get_value(KeyValue) when is_tuple(KeyValue)->
  element(2, KeyValue);
get_value(_) -> not_found.












