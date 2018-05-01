open! Core
open! Async
open Cohttp
open Cohttp_async

val server
  :  unit
  -> (Socket.Address.Inet.t, int) Server.t Deferred.t
