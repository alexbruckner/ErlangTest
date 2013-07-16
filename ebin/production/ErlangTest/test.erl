%% Copyright
-module(test).
-author("alexbruckner").

%% API
-compile(export_all).

test(X) -> X.

main() -> io:format("value is: ~p~n", [test(20)]),
          io:format("value is: ~p~n", [test(30)]).
