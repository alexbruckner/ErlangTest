%% Copyright
-module(alex_example_handler).
-author("alexbruckner").
-compile(export_all).

handle_message(test, KeyValueList) ->
  io:format("Handling action <test> with values <~p>~n", [KeyValueList]),
  io:format("found value: <~p> for key <muh>~n", [alex:get_value(muh, KeyValueList)]);
handle_message(sync, KeyValueList) ->
  alex:get_value(muh, KeyValueList);
handle_message(RequestType, KeyValueList) ->
  io:format("Undefined action <~p> with values <~p>~n", [RequestType, KeyValueList]),
  "Undefined action <" ++ atom_to_list(RequestType) ++ "> with values <" ++ io_lib:format("~p", [KeyValueList]) ++ ">".

