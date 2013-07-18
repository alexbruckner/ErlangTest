%% Copyright
-module(test).
-author("alexbruckner").

%% API
-compile(export_all).

test(X) -> X.

main() -> io:format("~p~n", [tokenize()]).

tokenize() ->
  String = "muh:value1, key2 : \"value 2\"",
  tokenize(String).

tokenize(String) ->
  Tokens = string:tokens(String, ","),
  [ to_tuple(X) || X <- Tokens].

to_tuple(X) ->
  K = list_to_atom(string:strip(string:substr(X, 1, string:str(X, ":") - 1))),
  V = string:strip(string:substr(X, string:str(X, ":") + 1)),
  {K,V}.


