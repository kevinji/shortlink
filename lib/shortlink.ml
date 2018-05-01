open! Core
open! Async
open Cohttp
open Cohttp_async

module Shortlink = struct
  type t =
    { dest_url      : Uri.t
    ; creation_time : Time_ns.t
    } [@@deriving sexp]
end

type t = Shortlink.t String.Map.t [@@deriving sexp]

let test_shortlink =
  { Shortlink.
    dest_url      = Uri.of_string "https://berkeley.edu/"
  ; creation_time = Time_ns.now ()
  }

let shortlink_map : t = String.Map.of_alist_exn [("cal", test_shortlink)]

let handler ~body address request =
  let in_path = Request.uri request |> Uri.path in
  match Map.find shortlink_map in_path with
  | None ->
    Server.respond (Code.status_of_code 404)
  | Some shortlink ->
    Server.respond_with_redirect shortlink.dest_url

let server () =
  let where_to_listen =
    Tcp.Where_to_listen.bind_to Localhost (On_port 8001)
  in
  Server.create ~on_handler_error:`Raise where_to_listen handler
