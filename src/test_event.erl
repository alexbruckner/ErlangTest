%% Copyright
-module(test_event).
-author("alexbruckner").

%% API
-compile(export_all).

test(X) -> X.

main() ->
  Pid = event:start("Event", {{2013,6,21},{22,10,0}}), event:cancel(Pid).
