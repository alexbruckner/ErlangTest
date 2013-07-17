%% Copyright
-module(test_dog_fsm).
-author("alexbruckner").

%% API
-compile(export_all).

main() ->
  Pid = dog_fsm:start(),
  dog_fsm:pet(Pid),
  dog_fsm:pet(Pid),
  dog_fsm:pet(Pid),
  dog_fsm:squirrel(Pid),
  dog_fsm:pet(Pid),
  dog_fsm:pet(Pid),
  dog_fsm:pet(Pid).
