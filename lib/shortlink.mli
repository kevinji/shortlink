open! Core
open Async
open Cohttp_async

module Entry : sig
  type t =
    { dest_url      : Uri.t
    ; creation_time : Time_ns.t
    } [@@deriving sexp]
end

type t = Entry.t String.Map.t [@@deriving sexp]

val sample : unit -> t

val server
  :  port:int
  -> shortlinks:t
  -> (Socket.Address.Inet.t, int) Server.t Deferred.t
