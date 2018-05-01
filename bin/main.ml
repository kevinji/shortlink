open! Core
open! Async
open Shortlink

let () =
  Deferred.ignore (Shortlink.server ()) |> don't_wait_for
