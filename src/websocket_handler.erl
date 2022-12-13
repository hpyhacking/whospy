-module(websocket_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, _Opts) ->
  #{uuid := UUID, nickname := Nickname} = fetch_query(Req),
  {cowboy_websocket, Req, #{uuid => list_to_atom(UUID), nickname => Nickname}}.

websocket_init(State) ->
  #{uuid := UUID, nickname := Nickname} = State,

  %% spawn player process using nickname & uuid
  player_sup:start_player(UUID, Nickname),
  {[], State}.

websocket_handle({text, Msg}, State) ->
  Pid = list_to_binary(pid_to_list(self())),
	{[{text, <<"[", Pid/binary, "] That's what she said! ",  Msg/binary >>}], State};
websocket_handle(_Data, State) ->
	{[], State}.

websocket_info({timeout, _Ref, Msg}, State) ->
  io:format("~s websocket_info ~s ~n", [?MODULE, pid_to_list(self())]),
	%erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{[{text, Msg}], State};
websocket_info(_Info, State) ->
	{[], State}.

fetch_query(Req) ->
  #{qs := Query} = Req,

  QueryList = lists:map(fun(Item) -> 
                            [Key, Val] = string:split(Item, "="),
                            {binary_to_atom(Key), binary_to_list(Val)}
                        end, string:split(Query, "&")),

  maps:from_list(QueryList).

